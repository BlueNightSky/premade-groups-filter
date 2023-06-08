-------------------------------------------------------------------------------
-- Premade Groups Filter
-------------------------------------------------------------------------------
-- Copyright (C) 2022 Elotheon-Arthas-EU
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License along
-- with this program; if not, write to the Free Software Foundation, Inc.,
-- 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
-------------------------------------------------------------------------------

local PGF = select(2, ...)
local L = PGF.L
local C = PGF.C

function PGF.UI_SetupMinMaxField(panel, field, keyword)
    field.Title:SetText(L["dialog."..keyword])
    field.Title:SetWidth(135)
    field.To:SetText(L["dialog.to"])

    -- check box
    field.Act:SetScript("OnClick", function(element)
        panel.state[keyword].act = element:GetChecked()
        panel:TriggerFilterExpressionChange()
    end)

    -- text change
    local autoCheckbox = function ()
        local shouldCheck = PGF.NotEmpty(field.Min:GetText()) or PGF.NotEmpty(field.Max:GetText())
        field.Act:SetChecked(shouldCheck)
        panel.state[keyword].act = shouldCheck
    end
    field.Min:SetScript("OnTextChanged", function(element)
        autoCheckbox()
        panel.state[keyword].min = element:GetText()
        panel:TriggerFilterExpressionChange()
    end)
    field.Max:SetScript("OnTextChanged", function(element)
        autoCheckbox()
        panel.state[keyword].max = element:GetText()
        panel:TriggerFilterExpressionChange()
    end)

    -- tabbing
    field.Min:SetScript("OnTabPressed", function(element)
        field.Max:SetFocus()
    end)
    field.Max:SetScript("OnTabPressed", function(element)
        field.Min:SetFocus()
    end)
end

function PGF.UI_SetupDropDown(panel, field, name, title, entryTable)
    field.DropDown.SetKey = function(self, key)
        for _, v in ipairs(entryTable) do
            if v.key == key then
                self.Text:SetText(v.title)
                break
            end
        end
    end
    field.Title:SetText(title)
    field.Title:SetWidth(135)
    field.Act:SetScript("OnClick", function(element)
        panel.state.difficulty.act = element:GetChecked()
        panel:TriggerFilterExpressionChange()
    end)
    local onDifficultyChanged = function (item)
        field.Act:SetChecked(true)
        field.DropDown.Text:SetText(item.title)
        panel.state.difficulty.act = true
        panel.state.difficulty.val = item.value
        panel:TriggerFilterExpressionChange()
    end
    local dropdown = field.DropDown
    local entries = {}
    for _, v in ipairs(entryTable) do
        table.insert(entries, {
            value = v.key,
            title = v.title,
            func = onDifficultyChanged
        })
    end
    PGF.PopupMenu_Register(name, entries, field:GetParent(), "TOPRIGHT", dropdown, "BOTTOMRIGHT", -15, 10, 95, 150)
    dropdown.Button:SetScript("OnClick", function () PGF.PopupMenu_Toggle(name) end)
    dropdown:SetScript("OnHide", PGF.PopupMenu_Hide)
end
