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
		acronymsGroupRoute.get(":acronymID", use: getSingleHandler)
		acronymsGroupRoute.delete(":acronymID", use: deleteHandler)
		acronymsGroupRoute.get("search", use: searchHandler)
		acronymsGroupRoute.get("first", use: getFirstHandler)
		acronymsGroupRoute.get("ascending", use: sortedHandler)
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

	func getSingleHandler(_ req: Request) throws -> EventLoopFuture<Acronym> {
		Acronym.find(
			req.parameters.get("acronymID"),
			on: req.db
		)
		.unwrap(or: Abort(.notFound))
	}

	func deleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
		Acronym.find(
			req.parameters.get("acronymID"),
			on: req.db
		)
		.unwrap(or: Abort(.notFound))
		.flatMap { acronym in
			acronym.delete(on: req.db)
				.transform(to: .noContent)
		}
	}

	func searchHandler(_ req: Request) throws -> EventLoopFuture<[Acronym]> {
		guard let searchTerm = req.query[String.self, at: "term"] else {
			throw Abort(.badRequest)
		}

		return Acronym.query(on: req.db).group(.or) { or in
			or.filter(\.$short == searchTerm)
			or.filter(\.$long == searchTerm)
		}.all()
	}

	func getFirstHandler(_ req: Request) throws -> EventLoopFuture<Acronym> {
		Acronym.query(on: req.db)
			.first()
			.unwrap(or: Abort(.notFound))
	}

	func sortedHandler(_ req: Request) -> EventLoopFuture<[Acronym]> {
		Acronym.query(on: req.db)
			.sort(\.$short, .ascending).all()
	}
}
