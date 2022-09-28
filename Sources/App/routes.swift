import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

	app.post("api", "acronyms") { req -> EventLoopFuture<Acronym> in
		let acronym = try req.content.decode(Acronym.self)

		return acronym.save(on: req.db).map {
			acronym
		}
	}

	app.get("api", "acronyms") { req -> EventLoopFuture<[Acronym]> in
		Acronym.query(on: req.db).all()
	}

	app.get("api", "acronyms", ":acronymID") { req -> EventLoopFuture<Acronym> in
		Acronym.find(req.parameters.get("acronymID"), on: req.db)
			.unwrap(or: Abort(.notFound))
	}
}
