cronAdd("sync_rappels", "0 0,12 * * *", () => {
    const reponse = $http.send({
        url:"https://codelabs.formation-flutter.fr/assets/rappels.json",
        method: "GET"
    });

    const produits = JSON.parse(reponse.raw);
    const anciens = $app.findAllRecords("Rappel_Produit");
    for (let i = 0; i < anciens.length; i++) {
        $app.delete(anciens[i]);
    }
    console.log("Nombre de produits récupérés:", produits.length);
    const collection = $app.findCollectionByNameOrId("Rappel_Produit");

    for (let i = 0; i < produits.length; i++) {
        const item = produits[i];
        if (!item.gtin) continue;
        try {
            const record = new Record(collection, {
                "gtin": String(item.gtin),
                "motif": item.motif_rappel ?? "",
                "conseil": item.preconisations_sanitaires ?? "",
                "zone": item.zone_geographique_de_vente ?? "",
                "distributeur": item.distributeurs ?? "",
                "date_debut_comm": item.date_debut_commercialisation ?? "",
                "date_fin_comm": item.date_date_fin_commercialisation ?? ""
            });
            $app.save(record);
            console.log("Créé:", item.gtin);
        } catch(e) {
            console.log("Erreur:", e.message ?? String(e));
        }
    }
    console.log("Sync terminée !");
});