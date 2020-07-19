//
//  EditBoardViewController.swift
//  netfit
//
//  Created by Yonghyun on 2020/07/18.
//  Copyright © 2020 Yonghyun. All rights reserved.
//

import Foundation
import UIKit
import EventKit
import KDCalendar

class EditBoardViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var calendarView: CalendarView!
    @IBOutlet var ddayTextField: UITextField!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var ddayLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    
    override func viewDidLoad() {
        let style = CalendarView.Style()
        
        style.cellShape                = .bevel(8.0)
        style.cellColorDefault         = UIColor.clear
        style.cellColorToday           = UIColor(red:196/255, green:217/255, blue:254/255, alpha:1.00)
        style.cellSelectedBorderColor  = UIColor(red:252/255, green:73/255, blue:20/255, alpha:0.5)
        style.cellSelectedColor        = UIColor(red:252/255, green:73/255, blue:20/255, alpha:0.5)
        style.cellEventColor           = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        style.headerTextColor          = UIColor.gray

        style.cellTextColorDefault     = UIColor(red: 160/255, green: 169/255, blue: 186/255, alpha: 1.0)
        style.cellTextColorToday       = UIColor.black
        style.cellTextColorWeekend     = UIColor(red: 167/255, green: 175/255, blue: 191/255, alpha: 1.0)
        style.cellColorOutOfRange      = UIColor(red: 249/255, green: 226/255, blue: 212/255, alpha: 1.0)

        style.headerBackgroundColor    = UIColor.white
        style.weekdaysBackgroundColor  = UIColor.white
        style.firstWeekday             = .sunday
        style.locale                   = Locale(identifier: "ko_KR")

        style.cellFont = UIFont(name: "Helvetica", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0)
        style.headerFont = UIFont(name: "Helvetica", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0)
        style.weekdaysFont = UIFont(name: "Helvetica", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)

        calendarView.style = style
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.direction = .horizontal
        calendarView.multipleSelectionEnable = false
        calendarView.marksWeekends = true
        
        navigationBarDesign()
        
        ddayTextField.delegate = self
        messageTextField.delegate = self
        ddayTextField.isHidden = true
        messageTextField.isHidden = true
        ddayLabel.isUserInteractionEnabled = true
        messageLabel.isUserInteractionEnabled = true
        
        let ddaySelector : Selector = #selector(self.ddayTapped)
        let ddayTapGesture = UITapGestureRecognizer(target: self, action: ddaySelector)
        ddayTapGesture.numberOfTapsRequired = 1
        ddayLabel.addGestureRecognizer(ddayTapGesture)
        
        let messageSelector : Selector = #selector(self.messageTapped)
        let messageTapGesture = UITapGestureRecognizer(target: self, action: messageSelector)
        messageTapGesture.numberOfTapsRequired = 1
        messageLabel.addGestureRecognizer(messageTapGesture)
        
        if UserDefaults.exists(key: UserDefaultKey.boardMessage) {
            messageLabel.text = UserDefaults.standard.string(forKey: UserDefaultKey.boardMessage)
        }
        else {
            messageLabel.text = "목표 메시지를 설정해주세요"
        }
        
        if UserDefaults.exists(key: UserDefaultKey.boardDday) {
            ddayLabel.text = UserDefaults.standard.string(forKey: UserDefaultKey.boardDday)
        }
        else {
            ddayLabel.text = "D-day"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let today = Date()
        self.calendarView.setDisplayDate(today)
        
        
        
        // 목표 설정한 날짜 보이게 하기
        var tomorrowComponents = DateComponents()
        tomorrowComponents.day = 1
        let tomorrow = self.calendarView.calendar.date(byAdding: tomorrowComponents, to: today)!
        self.calendarView.selectDate(tomorrow)
    }
    
    @objc func ddayTapped(){
        ddayLabel.isHidden = true
        ddayTextField.isHidden = false
        ddayTextField.text = ddayLabel.text
    }
    
    @objc func messageTapped(){
        messageLabel.isHidden = true
        messageTextField.isHidden = false
        messageTextField.text = messageLabel.text
    }

    func textFieldShouldReturn(userText: UITextField) -> Bool {
        if userText == ddayTextField {
            userText.resignFirstResponder()
            ddayTextField.isHidden = true
            ddayLabel.isHidden = false
            ddayLabel.text = ddayTextField.text
            return true
        }
        else {
            userText.resignFirstResponder()
            messageTextField.isHidden = true
            messageLabel.isHidden = false
            messageLabel.text = messageTextField.text
            return true
        }
    }
    
    func navigationBarDesign() {
        let rect:CGRect = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: 65, height: 30))
        let titleView: UIView = UIView.init(frame: rect)
        let titleImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 65, height: 24))
        titleImage.image = UIImage(named: "netfitLogo")
        titleImage.contentMode = .scaleAspectFit
        titleView.addSubview(titleImage)
        self.navigationItem.titleView = titleView
        
        let leftButton = UIButton(type: UIButton.ButtonType.custom)
        leftButton.setImage(UIImage(named: "backButton"), for: .normal)
        leftButton.addTarget(self, action:#selector(goBack), for: .touchDown)
        leftButton.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        let leftBarButton = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItems = [leftBarButton]
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension EditBoardViewController: CalendarViewDataSource {
    func headerString(_ date: Date) -> String? {
        return "나의 달력"
    }

    func startDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = -3
        let today = Date()
        let threeMonthsAgo = self.calendarView.calendar.date(byAdding: dateComponents, to: today)!

        return threeMonthsAgo
    }

    func endDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = 12
        let today = Date()
        let twoYearsFromNow = self.calendarView.calendar.date(byAdding: dateComponents, to: today)!

        return twoYearsFromNow
    }
}

extension EditBoardViewController: CalendarViewDelegate {
    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
    }
    
    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {
        return true
    }
    
    func calendar(_ calendar: CalendarView, didSelectDate date : Date, withEvents events: [CalendarEvent]) {
        print("Did Select: \(date) with \(events.count) events")
        
        for event in events {
            print("\t\"\(event.title)\" - Starting at:\(event.startDate)")
        }
        
        
        // 디데이 바뀐 거 알림 보여주기
    }

    func calendar(_ calendar: CalendarView, didLongPressDate date : Date, withEvents events: [CalendarEvent]?) {
    }
}
