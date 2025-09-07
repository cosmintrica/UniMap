//
//  UCVData.swift
//  UniMap
//
//  Created by Cosmin Trica on 13.08.2025.
//


import SwiftUI

enum UCVData {
    static let building: Building = {
        // Camere — parter (subset reprezentativ; poți adăuga rapid după model)
        let r: [RoomPolygon] = [
            .init(id:"A001", name:"Secretariat", floor:0, points:[
                .init(x:0.05,y:0.08), .init(x:0.26,y:0.08), .init(x:0.26,y:0.23), .init(x:0.05,y:0.23)
            ], info:"Program 09–16"),
            .init(id:"A002", name:"Amfiteatru", floor:0, points:[
                .init(x:0.28,y:0.08), .init(x:0.70,y:0.08), .init(x:0.70,y:0.24), .init(x:0.28,y:0.24)
            ], info:"Capacitate 120"),
            .init(id:"A003", name:"Cancelarie", floor:0, points:[
                .init(x:0.05,y:0.26), .init(x:0.22,y:0.26), .init(x:0.22,y:0.40), .init(x:0.05,y:0.40)
            ], info:nil),
            .init(id:"A004", name:"Birou decanat", floor:0, points:[
                .init(x:0.24,y:0.26), .init(x:0.40,y:0.26), .init(x:0.40,y:0.40), .init(x:0.24,y:0.40)
            ], info:nil),
            .init(id:"A005", name:"Aula", floor:0, points:[
                .init(x:0.42,y:0.26), .init(x:0.70,y:0.26), .init(x:0.70,y:0.40), .init(x:0.42,y:0.40)
            ], info:"Evenimente"),
            .init(id:"A006", name:"Lab", floor:0, points:[
                .init(x:0.72,y:0.26), .init(x:0.88,y:0.26), .init(x:0.88,y:0.40), .init(x:0.72,y:0.40)
            ], info:"Laborator"),
            .init(id:"WC0M", name:"WC Bărbați", floor:0, points:[
                .init(x:0.74,y:0.08), .init(x:0.81,y:0.08), .init(x:0.81,y:0.20), .init(x:0.74,y:0.20)
            ], info:nil),
            .init(id:"WC0F", name:"WC Femei", floor:0, points:[
                .init(x:0.82,y:0.08), .init(x:0.88,y:0.08), .init(x:0.88,y:0.20), .init(x:0.82,y:0.20)
            ], info:nil),
            // câteva săli mici pe centru (holuri laterale)
            .init(id:"A007", name:"Sala 207", floor:0, points:[.init(x:0.08,y:0.44),.init(x:0.19,y:0.44),.init(x:0.19,y:0.52),.init(x:0.08,y:0.52)], info:nil),
            .init(id:"A008", name:"Sala 208", floor:0, points:[.init(x:0.21,y:0.44),.init(x:0.32,y:0.44),.init(x:0.32,y:0.52),.init(x:0.21,y:0.52)], info:nil),
            .init(id:"A009", name:"Sala 209", floor:0, points:[.init(x:0.34,y:0.44),.init(x:0.45,y:0.44),.init(x:0.45,y:0.52),.init(x:0.34,y:0.52)], info:nil),
            .init(id:"A010", name:"Sala 210", floor:0, points:[.init(x:0.55,y:0.44),.init(x:0.66,y:0.44),.init(x:0.66,y:0.52),.init(x:0.55,y:0.52)], info:nil),
            .init(id:"A011", name:"Sala 211", floor:0, points:[.init(x:0.68,y:0.44),.init(x:0.79,y:0.44),.init(x:0.79,y:0.52),.init(x:0.68,y:0.52)], info:nil),
        ]

        // Noduri (holuri pe ax + legături la camere + scări/entrance)
        var nodes: [Node] = [
            .init(id:"n0_ent_main", floor:0, point:.init(x:0.10,y:0.92), kind:.entrance("Principală")),
            .init(id:"n0_ent_side", floor:0, point:.init(x:0.90,y:0.90), kind:.entrance("Laterală")),
            .init(id:"n0_h1", floor:0, point:.init(x:0.12,y:0.58), kind:.hallway),
            .init(id:"n0_h2", floor:0, point:.init(x:0.28,y:0.58), kind:.hallway),
            .init(id:"n0_h3", floor:0, point:.init(x:0.50,y:0.58), kind:.hallway),
            .init(id:"n0_h4", floor:0, point:.init(x:0.72,y:0.58), kind:.hallway),
            .init(id:"n0_h5", floor:0, point:.init(x:0.88,y:0.58), kind:.hallway),
            .init(id:"n0_stairC", floor:0, point:.init(x:0.50,y:0.65), kind:.stairs("C")),
            .init(id:"n0_elev1",  floor:0, point:.init(x:0.46,y:0.65), kind:.elevator("E1")),
            .init(id:"n0_stairA", floor:0, point:.init(x:0.85,y:0.68), kind:.stairs("A")),
        ]
        // noduri la uși (centrul camerei către holul cel mai apropiat)
        for room in r {
            let door = CGPoint(x: room.center.x, y: room.points.map{$0.y}.max()! + 0.02) // aproximăm ieșirea spre hol
            nodes.append(.init(id:"n0_r_\(room.id)", floor:0, point:door, kind:.room(room.id)))
        }

        // Muchii
        var e: [Edge] = [
            .init(from:"n0_ent_main", to:"n0_h1", weight:4),
            .init(from:"n0_ent_side", to:"n0_h5", weight:4),
            .init(from:"n0_h1", to:"n0_h2", weight:2.5),
            .init(from:"n0_h2", to:"n0_h3", weight:2.5),
            .init(from:"n0_h3", to:"n0_h4", weight:2.5),
            .init(from:"n0_h4", to:"n0_h5", weight:2.5),
            .init(from:"n0_h3", to:"n0_stairC", weight:1),
            .init(from:"n0_h3", to:"n0_elev1", weight:1),
            .init(from:"n0_h4", to:"n0_stairA", weight:1.5),
        ]
        for room in r {
            // leagă camera de cel mai apropiat nod de hol (din h1..h5)
            let hallIDs = ["n0_h1","n0_h2","n0_h3","n0_h4","n0_h5"]
            let hall = hallIDs.compactMap { hid in nodes.first{ $0.id==hid } }
                .min { $0.point.distance(to: room.center) < $1.point.distance(to: room.center) }!
            e.append(.init(from:"n0_r_\(room.id)", to: hall.id, weight:1.2))
        }

        // Subsoluri / Parter / Etaje
        let f_2 = Floor(id: -2, name: "Subsol -2", rooms: [], nodes: [], edges: [])
        let f_1 = Floor(id: -1, name: "Subsol -1", rooms: [], nodes: [], edges: [])

        // IMPORTANT: facem f0 VAR ca să-i putem seta corridors & stairs
        var f0  = Floor(id: 0, name: "Parter", rooms: r, nodes: nodes, edges: e)

        // ===== Holuri & Scări (aprox. 0..1 coordonate ecran) =====
        // hol perimetral: facem 4 benzile (sus, jos, stânga, dreapta) + traversări
        let corridorsParter: [AreaPolygon] = [
            // sus (bandă orizontală)
            AreaPolygon(id: "c_top", points: [
                CGPoint(x: 0.06, y: 0.06),
                CGPoint(x: 0.94, y: 0.06),
                CGPoint(x: 0.94, y: 0.16),
                CGPoint(x: 0.06, y: 0.16),
            ]),
            // jos
            AreaPolygon(id: "c_bottom", points: [
                CGPoint(x: 0.06, y: 0.84),
                CGPoint(x: 0.94, y: 0.84),
                CGPoint(x: 0.94, y: 0.94),
                CGPoint(x: 0.06, y: 0.94),
            ]),
            // stânga (bandă verticală)
            AreaPolygon(id: "c_left", points: [
                CGPoint(x: 0.06, y: 0.16),
                CGPoint(x: 0.16, y: 0.16),
                CGPoint(x: 0.16, y: 0.84),
                CGPoint(x: 0.06, y: 0.84),
            ]),
            // dreapta
            AreaPolygon(id: "c_right", points: [
                CGPoint(x: 0.84, y: 0.16),
                CGPoint(x: 0.94, y: 0.16),
                CGPoint(x: 0.94, y: 0.84),
                CGPoint(x: 0.84, y: 0.84),
            ]),
            // traversare orizontală centrală
            AreaPolygon(id: "c_mid_h", points: [
                CGPoint(x: 0.16, y: 0.48),
                CGPoint(x: 0.84, y: 0.48),
                CGPoint(x: 0.84, y: 0.52),
                CGPoint(x: 0.16, y: 0.52),
            ]),
            // traversare verticală centrală
            AreaPolygon(id: "c_mid_v", points: [
                CGPoint(x: 0.48, y: 0.16),
                CGPoint(x: 0.52, y: 0.16),
                CGPoint(x: 0.52, y: 0.84),
                CGPoint(x: 0.48, y: 0.84),
            ]),
        ]

        // scări – gri deschis (doar desen)
        let stairsParter: [AreaPolygon] = [
            AreaPolygon(id: "st_nw", points: [
                CGPoint(x: 0.18, y: 0.18),
                CGPoint(x: 0.24, y: 0.18),
                CGPoint(x: 0.24, y: 0.24),
                CGPoint(x: 0.18, y: 0.24),
            ]),
            AreaPolygon(id: "st_ne", points: [
                CGPoint(x: 0.76, y: 0.18),
                CGPoint(x: 0.82, y: 0.18),
                CGPoint(x: 0.82, y: 0.24),
                CGPoint(x: 0.76, y: 0.24),
            ]),
            AreaPolygon(id: "st_sw", points: [
                CGPoint(x: 0.18, y: 0.76),
                CGPoint(x: 0.24, y: 0.76),
                CGPoint(x: 0.24, y: 0.82),
                CGPoint(x: 0.18, y: 0.82),
            ]),
            AreaPolygon(id: "st_se", points: [
                CGPoint(x: 0.76, y: 0.76),
                CGPoint(x: 0.82, y: 0.76),
                CGPoint(x: 0.82, y: 0.82),
                CGPoint(x: 0.76, y: 0.82),
            ]),
        ]

        // atașăm la Parter
        f0.corridors = corridorsParter
        f0.stairs = stairsParter

        let f1  = Floor(id: 1, name: "Etaj 1", rooms: [], nodes: [], edges: [])
        let f2  = Floor(id: 2, name: "Etaj 2", rooms: [], nodes: [], edges: [])
        let f3  = Floor(id: 3, name: "Etaj 3", rooms: [], nodes: [], edges: [])

        return Building(id: "ucv_central_corpA", name: "UCV — Corp A", floors: [f_2, f_1, f0, f1, f2, f3])

    }()
}
