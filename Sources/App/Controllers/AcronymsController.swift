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
		let acronymsGroupRoute = routes.grouped("api", "acronyms")

		acronymsGroupRoute.get(use: getAllHandler)
	}

	func getAllHandler(_ req: Request) -> EventLoopFuture<[Acronym]> {
		Acronym.query(on: req.db).all()
	}
}