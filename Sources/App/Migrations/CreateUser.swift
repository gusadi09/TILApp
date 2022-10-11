//
//  CreateUser.swift
//  
//
//  Created by Gus Adi on 11/10/22.
//

import Vapor
import Fluent

struct CreateUser: Migration {
	func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
		database.schema("users")
			.id()
			.field("name", .string, .required)
			.field("username", .string, .required)
			.create()
	}

	func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
		database.schema("users").delete()
	}
}
