/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_1137935767")

  // remove field
  collection.fields.removeById("text2862495610")

  // add field
  collection.fields.addAt(6, new Field({
    "hidden": false,
    "id": "date1852283465",
    "max": "",
    "min": "",
    "name": "date_debut_comm",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "date"
  }))

  // add field
  collection.fields.addAt(7, new Field({
    "hidden": false,
    "id": "date2940795914",
    "max": "",
    "min": "",
    "name": "date_fin_comm",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "date"
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_1137935767")

  // add field
  collection.fields.addAt(6, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text2862495610",
    "max": 0,
    "min": 0,
    "name": "date",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  // remove field
  collection.fields.removeById("date1852283465")

  // remove field
  collection.fields.removeById("date2940795914")

  return app.save(collection)
})
