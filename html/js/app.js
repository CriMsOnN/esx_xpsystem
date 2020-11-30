$(document).ready(() => {
    $("body").hide();

})

window.addEventListener("message", (event) => {
    if (event.data.action === "show") {
        $.each(event.data.items, (index, name) => {
            console.log(name.description)
            $(".items").append(`
                <div class="item">
                    <div class="item-description">${name.description}</div>
                    <div class="item-buy" data-id="${name}">
                        <button class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored"><span class="material-icons">
                            shopping_cart
                        </span>Buy</button>
                    </div>
                    <div class="item-price">
                        <p>Price: ${name.price} XP points</p>
                    </div>
                </div>
            `)
            // $("#XPMenu-items").append(`
            //     <div id="item-${index}" class="col s4 items"><span class="flow-text">${name.toUpperCase()}</span><img src="./images/${name}.png"></div>
            // `)
        })
        $("body").show();
        $(".title").append(`<p>Redeem XP POINTS: ${event.data.xp}</p>`)

        $(".flow-text").mouseover((e) => {
            $.post("http://exp_system/playSound", JSON.stringify({}))
        })

        $("#button-close").on("click", (e) => {
            e.preventDefault()
            $.post("http://exp_system/close", JSON.stringify({}))
        })
    } else if (event.data.action === "close") {
        $("#xpText").html("")
        $("#XPMenu-items").html("")
        $("body").hide();
    }
})