/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_1137935767")

  // remove field
  collection.fields.removeById("number3396881563")

  // add field
  collection.fields.addAt(7, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text3396881563",
    "max": 0,
    "min": 0,
    "name": "gtin",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_1137935767")

  // add field
  collection.fields.addAt(1, new Field({
    "hidden": false,
    "id": "number3396881563",
    "max": null,
    "min": null,
    "name": "gtin",
    "onlyInt": false,
    "presentable": false,
    "required": false,
    "system": false,
    "type": "number"
  }))

  // remove field
  collection.fields.removeById("text3396881563")

  return app.save(collection)
})
