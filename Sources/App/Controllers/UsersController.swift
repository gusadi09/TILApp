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
	}

	func createHandler(_ req: Request) throws -> EventLoopFuture<User> {
		let user = try req.content.decode(User.self)

		return user.save(on: req.db).map { user }
	}
}
