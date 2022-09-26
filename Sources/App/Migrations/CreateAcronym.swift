//
//  CreateAcronym.swift
//  
//
//  Created by Gus Adi on 26/09/22.
//

import Fluent

struct CreateAcronym: Migration {
	func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
		database.schema("acronyms")
			.id()
			.field("short", .string, .required)
			.field("long", .string, .required)
			.create()
	}

	func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
		database.schema("acronyms")
			.delete()
	}
}
