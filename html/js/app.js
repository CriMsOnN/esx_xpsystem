$(document).ready(() => {
    $("body").hide();
})



window.addEventListener("message", (event) => {
    var elems = document.querySelectorAll(".modal")
    var instance = M.Modal.getInstance(elems)
    if (event.data.action === "show") {
        $(".modal").modal();
        $(".title").html("")
        $(".items").html("")
        $.each(event.data.items, (index, name) => {
            $(".items").append(`
                <div class="item" data-key="${name.name}">
                    <div class="item-description">${name.description}</div>
                    <div class="item-buy">
                        <button class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored"><span class="material-icons">
                            shopping_cart
                        </span>Buy</button>
                    </div>
                    <div class="item-price">
                        <p>Price: ${name.price} XP points</p>
                    </div>
                </div>
            `)
        })
        $(document).on("click", "#redeem", (e) => {
            e.preventDefault();
            const value = $("#code").val()
            $.post("http://xp_system/givePromo", JSON.stringify({
                data: value
            }),
                $("#code").val("")
            )
        })
        $(document).on("click", ".item", function(e) {
            e.preventDefault();
            const item = $(this).data("key")
            $.post("http://xp_system/giveItem", JSON.stringify({
                giveItem: item
            }))
        })
        $("body").show();
        $(".title").append(`<p>Redeem XP POINTS: ${event.data.xp}</p>`)

        $(".item-buy").mouseover((e) => {
            $.post("http://xp_system/playSound", JSON.stringify({}))
        })

        $(".close").on("click", (e) => {
            e.preventDefault()
            $.post("http://xp_system/close", JSON.stringify({}))
        })
    } else if (event.data.action == "updateHUD") {
        $(".title").html("")
        $(".title").append(`<p>Reedem XP POINTS: ${event.data.xp}</p>`)
    }else if (event.data.action === "close") {
        $("#xpText").html("")
        $("#XPMenu-items").html("")
        $("body").hide();
    }
})