import UIKit

// MARK: The bakery

class Bakery {
    let name: String

    init(name: String) {
        self.name = name
    }

    func placeOrder(donut: Donut, toppings: [Topping]) {
        let order = Order(donut: donut, toppings: toppings)
        order.finishReceipt()
    }
}

class Order {
    let donut: Donut
    let toppings: [Topping]

    init(donut: Donut, toppings: [Topping]) {
        self.donut = donut
        self.toppings = toppings
    }

    func finishReceipt() {
        let receiptSum = calculateSum(of: [donut] + toppings)
        print("Receipt for donut sized \(donut.size.rawValue) and \(toppings.count) topping\(toppings.count > 1 ? "s" : "") closed with \(receiptSum) PLN")
    }

    private func calculateSum(of sellableItems: [SellableItem]) -> Double {
        return sellableItems.reduce(0, { $0 + $1.price})
    }
}

protocol SellableItem {
    var price: Double { get }
}

class Donut: SellableItem {
    enum Size: String {
        case standard
        case extraLarge = "extra large"
    }

    let size: Size

    var price: Double {
        switch size {
        case .standard: return 2
        case .extraLarge: return 3.5
        }
    }

    init(size: Size) {
        self.size = size
    }
}

enum Topping: SellableItem {
    case cranberryJam
    case blueberryJam
    case raspberryJam
    case strawberryJam
    case nutella

    var price: Double {
        switch self {
        default:
            return 1
        }
    }
}

let bakery = Bakery(name: "Cukiernia - ACC")

bakery.placeOrder(donut: Donut(size: .extraLarge), toppings: [.blueberryJam, .nutella])


// MARK: The cruise ship

class Ship {
    let restaurant = Restaurant(capacity: 300)

    let bars = [Bar(capacity: 50), Bar(capacity: 50)]

    var peopleOnBoard: [Person] {
        return tourists + crew
    }
    var tourists: [Tourist] = Array<Tourist>(repeating: Tourist(), count: 350)
    var crew: [CrewMember] = Array<CrewMember>(repeating: CrewMember(), count: 50)

    var engines: [Engine]

    init() {
        engines = [Engine(powerInkHP: 2), Engine(powerInkHP: 4)]
    }

    func runAllEngines() {
        engines.forEach { $0.isOperating = true }
    }

    func runSmallerEngine() {
        engines.forEach { $0.isOperating = false }
        engines.sorted(by: { $0.horsepowerInkHP < $1.horsepowerInkHP }).first?.isOperating = false
    }

    func runBiggerEngine() {
        engines.forEach { $0.isOperating = false }
        engines.sorted(by: { $0.horsepowerInkHP < $1.horsepowerInkHP }).last?.isOperating = false
    }

    func turnOffEngines() {
        engines.forEach { $0.isOperating = false }
    }
}

class Engine {
    let horsepowerInkHP: Int
    var isOperating: Bool = false

    init(powerInkHP: Int) {
        horsepowerInkHP = powerInkHP
    }
}

protocol Person {

}

class CrewMember: Person {

}

class Tourist: NSObject, Person {
    let age: Int

    var friends: [Tourist] = []

    var isAllowedToBar: Bool {
        age >= 18
    }

    weak var visitedPlace: Place?

    override init() {
        self.age = Int.random(in: 0...100)
        super.init()
    }

    func visit(_ place: Place) {
        visitedPlace?.leavePlace(self)

        if place.visitPlace(self) {
            visitedPlace = place
        }
    }
}

protocol Place: AnyObject {
    var capacity: Int { get }
    var peopleIn: [Tourist] { get set }

    func visitPlace(_ person: Tourist) -> Bool
    func leavePlace(_ person: Tourist)
}

extension Place {
    func leavePlace(_ person: Tourist) {
        if let index = peopleIn.index(of: person) {
            peopleIn.remove(at: index)
        }
    }
}

class Restaurant: Place {
    let capacity: Int

    var peopleIn: [Tourist] = []

    init(capacity: Int) {
        self.capacity = capacity
    }

    func visitPlace(_ person: Tourist) -> Bool {
        if peopleIn.count < capacity {
            peopleIn.append(person)
            return true
        }
        return false
    }
}

class Bar: Place {
    let capacity: Int

    var peopleIn: [Tourist] = []

    init(capacity: Int) {
        self.capacity = capacity
    }

    func visitPlace(_ person: Tourist) -> Bool {
        if peopleIn.count < capacity {
            if person.isAllowedToBar {
                peopleIn.append(person)
                return true
            }
            return false
        }
        return false
    }
}

class Cabin {
    let capacity: Int

    var tourists: [Tourist] = []

    init() {
        capacity = [2, 4].randomElement()!
    }

    func append(_ tourist: Tourist) -> Bool {
        if tourists.count < capacity {
            tourists.append(tourist)
            return true
        }
        return false
    }
}




//
//  unitTestingTests.swift
//  unitTestingTests
//
//  Created by Leszek Barszcz on 03/03/2020.
//  Copyright © 2020 lpb. All rights reserved.
//
import XCTest

class unitTestingTests: XCTestCase {

    override func setUp() {
        // set up instances here
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSampleFunc() {
        // prepare, execute and assert here
    }
}











