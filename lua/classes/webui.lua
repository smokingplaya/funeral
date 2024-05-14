/**
 * WebUI
 * * Класс, отвечающий за CEF юзер интерфейсы.
*/

local class = {}
class.name = "WebUI"

/**
    * constructor
    * * Задает необходимые поля
    * @param name - Ключ конкретного WebUI в таблице со всеми WebUI
    * @param url - URL-ссылка, которая будет открываться
    * @param save_on_close? - Будет ли текущий WebUI полностью удалятся при вызове метода Close?
*/

function class:new(name, url, save_on_close)
    self.panel = NULL
    self.name = name
    self.url = url
    self.isSave = save_on_close or false
end

/**
    * Open
    * * Создает и открывает WebUI
    * @param parent? - VGUI панель, на которой будет открыт текущий WebUI (по умолч. = vgui.GetWorldPanel())
*/

function class:Open(parent)
    if IsValid(self.panel) then
        self.panel[self.isSave and "Show" or "Remove"](self.panel)
    end

    self.panel = vgui.Create("DHTML", parent)
    self.panel:Dock(FILL)
    self.panel:OpenURL(self.url)
end

/**
    * GetPanel
    * * Возвращает DHTML панель
    * @param parent? - Закрывает WebUI. Если у текущего WebUI save_on_close == true, то тогда WebUI будет просто скрыт, без удаления панели через panel:Remove()
*/

function class:GetPanel()
    return self.panel
end

/**
    * PushTable
    * * Добавляет переменную в JS, которая будет являться таблицей
    * @param variable_name - название переменной в JS
    * @param tab - таблица, которяа будет добавлена в JS
*/

function class:PushTable(variable_name, tab)
    if not IsValid(self.panel) then
        return
    end

    /* я не придумал другого метода, как можно пушить таблицу в js */
    local code = "var " .. variable_name .. " = " .. util.TableToJSON(tab)

    self.panel:QueueJavascript(code)
end

/**
    * Close
    * * Закрывает/скрывает WebUI
    * @param parent? - Закрывает WebUI. Если у текущего WebUI save_on_close == true, то тогда WebUI будет просто скрыт, без удаления панели через panel:Remove()
*/

function class:Close()
    if not IsValid(self.panel) then
        return
    end

    self.panel[self.isSave and "Hide" or "Remove"](self.panel)
end

return class