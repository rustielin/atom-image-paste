{dirname, join} = require 'path'
shell = require 'shelljs';
fs = require 'fs'
clipboard = require 'clipboard'

module.exports =
  activate: (state)->
    attachEvent()

attachEvent = ->
  ws = atom.views.getView atom.workspace
  ws.addEventListener 'keyup', (evt)->
    if (evt.shiftKey and evt.altKey and evt.ctrlKey and evt.keyCode is 86 and not (evt.metaKey)) or (evt.shiftKey and evt.cmdKey and evt.ctrlKey and evt.keyCode is 86 and not (evt.metaKey))

      img = clipboard.readImage()
      if img.isEmpty()
        return
      else
        cursor = atom.workspace.getActiveTextEditor()

        if !checkFiletype(cursor.getPath())
          return

        if atom.config.get 'atom-image-paste.use_subfolder'
            subFolderToUse = atom.config.get 'atom-image-paste.subfolder'
            if subFolderToUse != ""
                curDirectory = atom.project.getPaths()[0]
                assetsDirectory = join(curDirectory, subFolderToUse)

                if !fs.existsSync assetsDirectory
                    # fs.mkdirSync assetsDirectory
                    shell.mkdir("-p", assetsDirectory)

        else
            subFolderToUse = ""
            curDirectory = dirname(cursor.getPath())
            assetsDirectory = curDirectory

        fileName = "atom-image-paste-#{formatDate(new Date())}.png"
        fullName = join(assetsDirectory, fileName)

        fs.writeFile join(assetsDirectory, fileName), img.toPng(), ->
          console.info 'Ok! Image is saved'

        printName = join(subFolderToUse, fileName)
        # switch on filetype
        if cursor.getPath()
            if cursor.getPath().substr(-3) == '.md'
                cursor.insertText "![#{printName}](#{printName})"
            else if cursor.getPath().substr(-4) == '.tex'
                cursor.insertText "\\includegraphics[](#{printName})"

forceTwoDigits = (val) ->
  if val < 10
    return "0#{val}"
  return val

  

formatDate = (date) ->
  year = date.getFullYear()
  month = forceTwoDigits(date.getMonth()+1)
  day = forceTwoDigits(date.getDate())
  hour = forceTwoDigits(date.getHours())
  minute = forceTwoDigits(date.getMinutes())
  second = forceTwoDigits(date.getSeconds())
  ms = forceTwoDigits(date.getMilliseconds())
  return "#{year}#{month}#{day}#{hour}#{minute}#{second}#{ms}"

checkFiletype = (name) ->
    return name.substr(-3) == '.md' or name.substr(-4) == '.tex'
