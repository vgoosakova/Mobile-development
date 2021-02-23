
import Foundation

// Частина 1

// Дано рядок у форматі "Student1 - Group1; Student2 - Group2; ..."

let studentsStr = "Дмитренко Олександр - ІП-84; Матвійчук Андрій - ІВ-83; Лесик Сергій - ІО-82; Ткаченко Ярослав - ІВ-83; Аверкова Анастасія - ІО-83; Соловйов Даніїл - ІО-83; Рахуба Вероніка - ІО-81; Кочерук Давид - ІВ-83; Лихацька Юлія - ІВ-82; Головенець Руслан - ІВ-83; Ющенко Андрій - ІО-82; Мінченко Володимир - ІП-83; Мартинюк Назар - ІО-82; Базова Лідія - ІВ-81; Снігурець Олег - ІВ-81; Роман Олександр - ІО-82; Дудка Максим - ІО-81; Кулініч Віталій - ІВ-81; Жуков Михайло - ІП-83; Грабко Михайло - ІВ-81; Іванов Володимир - ІО-81; Востриков Нікіта - ІО-82; Бондаренко Максим - ІВ-83; Скрипченко Володимир - ІВ-82; Кобук Назар - ІО-81; Дровнін Павло - ІВ-83; Тарасенко Юлія - ІО-82; Дрозд Світлана - ІВ-81; Фещенко Кирил - ІО-82; Крамар Віктор - ІО-83; Іванов Дмитро - ІВ-82"

// Завдання 1
// Заповніть словник, де:
// - ключ – назва групи
// - значення – відсортований масив студентів, які відносяться до відповідної групи

var studentsGroups: [String: [String]] = [:]

// Ваш код починається тут

// Масив у вигляді "Student1 - Group1"
let arrayForStudens = studentsStr.components(separatedBy: "; ")

for students in arrayForStudens {
    // Масив у вигляді "Student1", "Group1"
    let newArrayForStudens = students.components(separatedBy: " - ")
    
    // Перевірка чи була група додана у словник
    if var arrayForGroup = studentsGroups[newArrayForStudens[1]] {
        arrayForGroup.append(newArrayForStudens[0])
        studentsGroups[newArrayForStudens[1]] = arrayForGroup
    } else {
        studentsGroups[newArrayForStudens[1]] = [newArrayForStudens[0]]
    }
}

// Ваш код закінчується тут

print("Завдання 1")
print(studentsGroups)
print()

// Дано масив з максимально можливими оцінками

let points: [Int] = [12, 12, 12, 12, 12, 12, 12, 16]

// Завдання 2
// Заповніть словник, де:
// - ключ – назва групи
// - значення – словник, де:
//   - ключ – студент, який відносяться до відповідної групи
//   - значення – масив з оцінками студента (заповніть масив випадковими значеннями, використовуючи функцію `randomValue(maxValue: Int) -> Int`)

func randomValue(maxValue: Int) -> Int {
    switch(arc4random_uniform(6)) {
    case 1:
        return Int(ceil(Float(maxValue) * 0.7))
    case 2:
        return Int(ceil(Float(maxValue) * 0.9))
    case 3, 4, 5:
        return maxValue
    default:
        return 0
    }
}

var studentPoints: [String: [String: [Int]]] = [:]

// Ваш код починається тут

studentsGroups.forEach { group, students in
    
    var studentsWithMark: [String: [Int]] = [:]
    
    for student in students {
        var mark: [Int] = []
        for max in points {
            mark.append(randomValue(maxValue: max))
        }
        studentsWithMark[student] = mark
    }
    studentPoints[group] = studentsWithMark
}

// Ваш код закінчується тут

print("Завдання 2")
print(studentPoints)
print()

// Завдання 3
// Заповніть словник, де:
// - ключ – назва групи
// - значення – словник, де:
//   - ключ – студент, який відносяться до відповідної групи
//   - значення – сума оцінок студента

var sumPoints: [String: [String: Int]] = [:]

// Ваш код починається тут

studentPoints.forEach { group, students in
    
    var studentsWithMarkSum: [String: Int] = [:]
    
    students.forEach { student, points in
        studentsWithMarkSum[student] = points.reduce(0, { $0 + $1 })
    }
    sumPoints[group] = studentsWithMarkSum
}

// Ваш код закінчується тут

print("Завдання 3")
print(sumPoints)
print()

// Завдання 4
// Заповніть словник, де:
// - ключ – назва групи
// - значення – середня оцінка всіх студентів групи

var groupAvg: [String: Float] = [:]

// Ваш код починається тут

sumPoints.forEach { group, students in
    
    let points = students.reduce(0, { $0 + $1.value })
    groupAvg[group] = Float(points) / Float(students.count)
}

// Ваш код закінчується тут

print("Завдання 4")
print(groupAvg)
print()

// Завдання 5
// Заповніть словник, де:
// - ключ – назва групи
// - значення – масив студентів, які мають >= 60 балів

var passedPerGroup: [String: [String]] = [:]

// Ваш код починається тут

sumPoints.forEach { group, students in
    
    var studentsGroup: [String] = []
    
    students.forEach { student, points in
        if points >= 60 {
            studentsGroup.append(student)
        }
    }
    passedPerGroup[group] = studentsGroup
}


// Ваш код закінчується тут

print("Завдання 5")
print(passedPerGroup)

// Частина 2

class CoordinateVG {
    enum Direction {
        case latitude
        case longtitude
    }
    let direction: Direction
    let degrees: Int
    let minutes: UInt
    let seconds: UInt
    
    init(direction: Direction = .longtitude, degrees: Int = 0, minutes: UInt = 0, seconds: UInt = 0) {
        self.minutes = (0...59).contains(minutes) ? minutes : 0
        self.seconds = (0...59).contains(seconds) ? seconds : 0
        self.direction = direction
        switch (degrees, direction) {
        case (-180...180, .longtitude) :
            self.degrees = degrees
        case (-90...90, .latitude) :
            self.degrees = degrees
        default:
            self.degrees = 0
        }
    }
  
    func getPossition() -> String {
        var position: String
        switch (direction, degrees) {
        case (.latitude, ..<0):
            position = "S"
        case (.latitude, 0...):
            position = "N"
        case (.longtitude, ..<0):
            position = "W"
        case (.longtitude, 0...):
            position = "E"
        default:
            position = ""
        }
        return position
    }
    
    func getMinutes() -> Int {
        return degrees > 0 ? Int(minutes): Int(minutes) * -1
    }
    
    func getSeconds() -> Int {
        return degrees > 0 ? Int(seconds): Int(seconds) * -1
    }
    
    func getCoord() -> String {
        return "\(degrees)°\(minutes)′\(seconds)″ \(getPossition())"
    }
    
    func getCoordDec() -> String {
        return "\(Float(degrees) + Float(getMinutes()) / 60 + Float(getSeconds()) / 3600) \(getPossition())"
    }
    
    func middleCoord(newCoord: CoordinateVG) -> CoordinateVG? {
        if newCoord.direction != direction{
            return nil
        }
        return CoordinateVG(direction: direction,
                            degrees: Int((degrees + newCoord.degrees) / 2),
                            minutes: UInt((getMinutes() + Int(newCoord.getMinutes())) / 2),
                            seconds: UInt((getSeconds() + Int(newCoord.getSeconds())) / 2))
    }
    
    class func middleCoordTwo(coord1: CoordinateVG, coord2: CoordinateVG) -> CoordinateVG? {
        if coord1.direction != coord2.direction{
            return nil
        }
        return CoordinateVG(direction: coord1.direction,
                            degrees: Int((coord1.degrees + coord2.degrees) / 2),
                            minutes: UInt((coord1.getMinutes() + Int(coord2.getMinutes())) / 2),
                            seconds: UInt((coord1.getSeconds() + Int(coord2.getSeconds())) / 2))
    }
}

//50°29′28″ с. ш. 30°29′52″ в. д.
//50°31′41″ с. ш. 30°29′56″ в. д.

let coordLongDefault = CoordinateVG()
let coordLatiDefault = CoordinateVG()

let coordLongBegin = CoordinateVG(direction: .longtitude, degrees: 30, minutes: 29, seconds: 52)
let coordLatiBegin = CoordinateVG(direction: .latitude, degrees: 50, minutes: 29, seconds: 28)

let coordLongEnd = CoordinateVG(direction: .longtitude, degrees: 30, minutes: 29, seconds: 56)
let coordLatiEnd = CoordinateVG(direction: .latitude, degrees: 50, minutes: 31, seconds: 41)


print()
print("Вивід координат із значеннями за замовчуванням у звичайному форматі:")
print(coordLongDefault.getCoord())
print(coordLatiDefault.getCoord())

print()
print("Вивід координат із значеннями за замовчуванням у десятковому форматі:")
print(coordLongDefault.getCoordDec())
print(coordLatiDefault.getCoordDec())

print()
print("Вивід координат із заданим набором значень у звичайному форматі:")
print(coordLongBegin.getCoord())
print(coordLatiBegin.getCoord())
print(coordLongEnd.getCoord())
print(coordLatiEnd.getCoord())

print()
print("Вивід координат із заданим набором значень у десятковому форматі:")
print(coordLongBegin.getCoordDec())
print(coordLatiBegin.getCoordDec())
print(coordLongEnd.getCoordDec())
print(coordLatiEnd.getCoordDec())

print()
print("Вивід середньої кординати між заданою і поточною точками коли однакові напрямки:")
print(coordLongBegin.middleCoord(newCoord: coordLongEnd)?.getCoord() ?? "")

print()
print("Вивід середньої кординати між заданою і поточною точками коли різні напрямки:")
print(coordLongBegin.middleCoord(newCoord: coordLatiBegin)?.getCoord() ?? "")

print()
print("Вивід середньої кординати між заданими точками коли однакові напрямки:")
print(CoordinateVG.middleCoordTwo(coord1: coordLatiBegin, coord2: coordLatiEnd)?.getCoord() ?? "")

print()
print("Вивід середньої кординати між заданими точками коли різні напрямки:")
print(CoordinateVG.middleCoordTwo(coord1: coordLatiBegin, coord2: coordLongEnd)?.getCoord() ?? "")


