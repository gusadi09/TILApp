//
//  AcronymsController.swift
//  
//
//  Created by Gus Adi on 11/10/22.
//

import Vapor
import Fluent

struct AcronymsController: RouteCollection {
	func boot(routes: Vapor.RoutesBuilder) throws {
		routes.get("api", "acronyms", use: getAllHandler)
	}

	func getAllHandler(_ req: Request) -> EventLoopFuture<[Acronym]> {
		Acronym.query(on: req.db).all()
	}
}
