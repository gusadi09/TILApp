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
		acronymsGroupRoute.post(use: createHandler)
		acronymsGroupRoute.put(":acronymID", use: updateHandler)
	}

	func getAllHandler(_ req: Request) -> EventLoopFuture<[Acronym]> {
		Acronym.query(on: req.db).all()
	}

	func createHandler(_ req: Request) throws -> EventLoopFuture<Acronym> {
		let acronym = try req.content.decode(Acronym.self)

		return acronym.save(on: req.db).map { acronym }
	}

	func updateHandler(_ req: Request) throws -> EventLoopFuture<Acronym> {
		let updateAcronym = try req.content.decode(Acronym.self)

		return Acronym.find(
			req.parameters.get("acronymID"),
			on: req.db
		)
		.unwrap(or: Abort(.notFound))
		.flatMap { acronym in
			acronym.short = updateAcronym.short
			acronym.long = updateAcronym.long

			return acronym.save(on: req.db).map { acronym }
		}
	}
}
