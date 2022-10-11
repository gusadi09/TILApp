//
//  UsersController.swift
//  
//
//  Created by Gus Adi on 11/10/22.
//

import Vapor
import Fluent

struct UsersController: RouteCollection {
	func boot(routes: Vapor.RoutesBuilder) throws {
		let userRoutes = routes.grouped("api", "users")

		userRoutes.post(use: createHandler)
		userRoutes.get(use: getAllHandler)
		userRoutes.get(":userID", use: getSingleHandler)
	}

	func createHandler(_ req: Request) throws -> EventLoopFuture<User> {
		let user = try req.content.decode(User.self)

		return user.save(on: req.db).map { user }
	}

	func getAllHandler(_ req: Request) -> EventLoopFuture<[User]> {
		User.query(on: req.db).all()
	}

	func getSingleHandler(_ req: Request) -> EventLoopFuture<User> {
		User.find(
			req.parameters.get("userID"),
			on: req.db
		)
		.unwrap(or: Abort(.notFound))
	}
}
