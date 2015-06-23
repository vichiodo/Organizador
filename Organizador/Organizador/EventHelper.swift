//
//  EventHelper.swift
//  Organizador
//
//  Created by Rubens Gondek on 6/22/15.
//  Copyright (c) 2015 Vivian Chiodo Dias. All rights reserved.
//

import Foundation
import EventKit
import UIKit

class EventHelper {
    static let shared = EventHelper()
    
    var eventStore: EKEventStore!
    
    init(){
        eventStore = EKEventStore()
    }
    
    // Notificação
    
    func setAtividade(at: Atividade) {
        criarNotificacao(at)
        criarEventoCalendario(at)
    }
    
    func cancelAtividade(at: Atividade) {
        cancelarNotificacao(at)
        excluirEventoCalendario(at)
    }
    
    func notif(at: Atividade, i: Int) -> UILocalNotification{
        var localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "Ver a prova"
        var diasRestantes = 7 - i
        var strNotif = "\(at.nome) de \(at.disciplina.nome)"
        if diasRestantes == 0 {
            localNotification.alertBody = "Vish, a '\(strNotif)' é hoje!"
        }
        else if diasRestantes == 1 {
            localNotification.alertBody = "Vish, falta \(diasRestantes) dia para a '\(strNotif)'!"
        }
        else {
            localNotification.alertBody = "Vish, faltam \(diasRestantes) dias para a '\(strNotif)'!"
        }
        
        let dateFix: NSTimeInterval = floor(at.data.timeIntervalSinceReferenceDate / 60.0) * 60.0
        var horario: NSDate = NSDate(timeIntervalSinceReferenceDate: dateFix)
        
        let intervalo: NSTimeInterval = -NSTimeInterval(60*60*24 * (diasRestantes))
        
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.applicationIconBadgeNumber = 1
        
        localNotification.fireDate = NSDate(timeInterval: intervalo, sinceDate: horario)
        return localNotification
    }
    
    func criarNotificacao(at: Atividade) {
        for i in 0...7 {
            UIApplication.sharedApplication().scheduleLocalNotification(notif(at, i: i))
        }
    }
    
    func cancelarNotificacao(at: Atividade) {
        for i in 0...7 {
            UIApplication.sharedApplication().cancelLocalNotification(notif(at, i: i))
        }
    }
    
    // Calendário
    func criarEventoCalendario(at: Atividade){
        var evento: EKEvent = EKEvent(eventStore: eventStore)
        
        evento.title = "\(at.nome) de \(at.disciplina.nome)"
        evento.startDate = at.data
        evento.endDate = NSDate(timeInterval: 3600, sinceDate: evento.startDate)
        
        eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: { (granted: Bool, error NSError) -> Void in
            if !granted {
                return
            } else {
                evento.calendar = self.eventStore.defaultCalendarForNewEvents
                
                self.eventStore.saveEvent(evento, span: EKSpanThisEvent, commit: true, error: NSErrorPointer())
            }
        })
    }
    
    func excluirEventoCalendario(at: Atividade){
        var endData: NSDate = NSDate(timeInterval: 3600, sinceDate: at.data)
        var predicate = eventStore.predicateForEventsWithStartDate(at.data, endDate: endData, calendars:[eventStore.defaultCalendarForNewEvents])
        
        var eventos = eventStore.eventsMatchingPredicate(predicate)
        eventStore.removeEvent((eventos.last as! EKEvent), span: EKSpanThisEvent, error: NSErrorPointer())
    }
}
