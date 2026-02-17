local SCIENCE_NAME = "space-science-pack"
local SCIENCE_AMOUNT = 1000  -- сколько науки выдавать
local REQUIRED_PAYLOAD = "satellite"  -- можно убрать проверку, если не нужно

script.on_event(defines.events.on_rocket_launched, function(event)
    local silo = event.rocket_silo
    local rocket = event.rocket

    if not silo or not silo.valid then return end

    -- Проверяем полезную нагрузку (если нужно)
    local inventory = rocket.get_inventory(defines.inventory.rocket)
    if inventory and inventory.get_item_count(REQUIRED_PAYLOAD) > 0 then
        
        -- Добавляем науку прямо в инвентарь шахты
        local inserted = silo.insert({
            name = SCIENCE_NAME,
            count = SCIENCE_AMOUNT
        })

        -- Если не влезло — остаток можно заспавнить на землю (опционально)
        if inserted < SCIENCE_AMOUNT then
            silo.surface.spill_item_stack(
                silo.position,
                {name = SCIENCE_NAME, count = SCIENCE_AMOUNT - inserted},
                true
            )
        end
    end
end)
