import Foundation
struct List : Codable {
	let weight : Weight?
	let height : Height?
	let id : Int?
	let name : String?
	let bred_for : String?
	let breed_group : String?
	let life_span : String?
	let temperament : String?
	let origin : String?
	let reference_image_id : String?
	let image : Image?

	enum CodingKeys: String, CodingKey {

		case weight = "weight"
		case height = "height"
		case id = "id"
		case name = "name"
		case bred_for = "bred_for"
		case breed_group = "breed_group"
		case life_span = "life_span"
		case temperament = "temperament"
		case origin = "origin"
		case reference_image_id = "reference_image_id"
		case image = "image"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		weight = try values.decodeIfPresent(Weight.self, forKey: .weight)
		height = try values.decodeIfPresent(Height.self, forKey: .height)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		bred_for = try values.decodeIfPresent(String.self, forKey: .bred_for)
		breed_group = try values.decodeIfPresent(String.self, forKey: .breed_group)
		life_span = try values.decodeIfPresent(String.self, forKey: .life_span)
		temperament = try values.decodeIfPresent(String.self, forKey: .temperament)
		origin = try values.decodeIfPresent(String.self, forKey: .origin)
		reference_image_id = try values.decodeIfPresent(String.self, forKey: .reference_image_id)
		image = try values.decodeIfPresent(Image.self, forKey: .image)
	}

}
