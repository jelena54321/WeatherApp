//
//  Store.swift
//  WeatherApp
//

import RxSwift
import CoreData

enum ContextType {
    case main
    case background
}

class Store {
    
    private let dataController: DataController
    private let notificationCenter: NotificationCenter
    
    init(dataController: DataController, notificationCenter: NotificationCenter) {
        self.dataController = dataController
        self.notificationCenter = notificationCenter
        
        notificationCenter.addObserver(
            self,
            selector: #selector(handleContextSaved),
            name: .NSManagedObjectContextDidSave,
            object: dataController.backgroundContext
        )
    }
    
    @objc func handleContextSaved(_ notification: Notification) {
        dataController.mainContext.perform { [weak self] in
            self?.dataController.mainContext.mergeChanges(fromContextDidSave: notification)
        }
    }
    
    func fetchDailyWeatherForecast(fromContext contextType: ContextType) -> Observable<[DailyWeatherForecastModel]> {
        let context = contextFor(type: contextType)
        let request: NSFetchRequest<DailyWeatherForecast> = DailyWeatherForecast.fetchRequest()
        request.returnsObjectsAsFaults = false
        
        return Observable.create { observer in
            context.perform {
                do {
                    let result = try context.fetch(request)
                    observer.onNext(result.map { DailyWeatherForecastModel(from: $0) })
                    observer.onCompleted()
                } catch (let error) {
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    func update(dailyWeatherForcasts: [DailyWeatherForecastModel],
                into contextType: ContextType) -> Observable<[DailyWeatherForecastModel]> {
        
        let context = contextFor(type: contextType)
        let request: NSFetchRequest<DailyWeatherForecast> = DailyWeatherForecast.fetchRequest()
        request.returnsObjectsAsFaults = false
        
        return Observable.create { observer in
            context.perform {
                for weatherForecast in dailyWeatherForcasts {
                    request.predicate = NSPredicate(format: "city = %@", weatherForecast.city)
                    
                    do {
                        let weatherForecastEntities = try context.fetch(request)
                        let weatherForecastEntity = weatherForecastEntities.first
                            ?? DailyWeatherForecast(context: context)
                        
                        weatherForecastEntity.populate(withModel: weatherForecast)
                    } catch {
                        observer.onError(CoreDataError.entityCouldNotBeFetched)
                        return
                    }
                }
                
                do {
                    try context.save()
                } catch {
                    observer.onError(CoreDataError.contextCouldNotBeSaved)
                    return
                }
                
                observer.onNext(dailyWeatherForcasts)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func fetchWeatherForecast(forCity city: String, fromContext contextType: ContextType) -> Observable<WeatherForecastModel> {
        let context = contextFor(type: contextType)
        let request: NSFetchRequest<WeatherForecast> = WeatherForecast.fetchRequest()
        request.predicate = NSPredicate(format: "city = %@", city)
        request.returnsObjectsAsFaults = false
        
        return Observable.create { observer in
            context.perform {
                do {
                    let result = try context.fetch(request)
                    if let weatherForecast = result.first {
                        observer.onNext(WeatherForecastModel(from: weatherForecast))
                        observer.onCompleted()
                    } else {
                        observer.onError(CoreDataError.entityCouldNotBeFetched)
                    }
                    
                } catch {
                    observer.onError(CoreDataError.entityCouldNotBeFetched)
                }
            }
            
            return Disposables.create()
        }
    }
    
    func update(weatherForecast: WeatherForecastModel, into contextType: ContextType) -> Observable<WeatherForecastModel> {
        
        let context = contextFor(type: contextType)
        let request: NSFetchRequest<WeatherForecast> = WeatherForecast.fetchRequest()
        request.predicate = NSPredicate(format: "city = %@", weatherForecast.city)
        request.returnsObjectsAsFaults = false
        
        return Observable.create { observer in
            context.perform {
                do {
                    let result = try context.fetch(request)
                    let weatherForecastEntity = result.first ?? WeatherForecast(context: context)
                    weatherForecastEntity.populate(withModel: weatherForecast)
                    
                    weatherForecastEntity.futureForecasts.forEach { futureForecast in
                        context.delete(futureForecast)
                    }
                    
                    var futureForecasts = Set<FutureWeatherForecast>()
                    for futureForecast in weatherForecast.futureForecasts {
                        let futureWeatherForecastEntity = FutureWeatherForecast(context: context)
                        futureWeatherForecastEntity.populate(withModel: futureForecast)
                        futureForecasts.insert(futureWeatherForecastEntity)
                    }
                    
                    weatherForecastEntity.futureForecasts = futureForecasts
                } catch {
                    observer.onError(CoreDataError.entityCouldNotBeFetched)
                    return
                }
                
                do {
                    try context.save()
                } catch {
                    observer.onError(CoreDataError.contextCouldNotBeSaved)
                    return
                }
                
                observer.onNext(weatherForecast)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    private func contextFor(type: ContextType) -> NSManagedObjectContext {
        return type == .main ? dataController.mainContext : dataController.backgroundContext
    }
    
}
