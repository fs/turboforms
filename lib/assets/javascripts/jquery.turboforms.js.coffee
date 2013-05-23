$ = jQuery

$.fn.extend
  turboForms: (options) ->
    return @each (i, el) ->

      CSRFToken =
        get: (doc = document) ->
          node:   tag = doc.querySelector 'meta[name="csrf-token"]'
          token:  tag?.getAttribute? 'content'

        update: (latest) ->
          current = @get()
          if current.token? and latest? and current.token isnt latest
            current.node.setAttribute 'content', latest

      browserCompatibleDocumentParser = ->
        createDocumentUsingParser = (html) ->
          (new DOMParser).parseFromString html, 'text/html'

        createDocumentUsingDOM = (html) ->
          doc = document.implementation.createHTMLDocument ''
          doc.documentElement.innerHTML = html
          doc

        createDocumentUsingWrite = (html) ->
          doc = document.implementation.createHTMLDocument ''
          doc.open 'replace'
          doc.write html
          doc.close()
          doc

        try
          if window.DOMParser
            testDoc = createDocumentUsingParser '<html><body><p>test'
            createDocumentUsingParser
        catch e
          testDoc = createDocumentUsingDOM '<html><body><p>test'
          createDocumentUsingDOM
        finally
          unless testDoc?.body?.childNodes.length is 1
            return createDocumentUsingWrite

      triggerEvent = (name) ->
        event = document.createEvent 'Events'
        event.initEvent name, true, true
        document.dispatchEvent event

      executeScriptTags = ->
        scripts = Array::slice.call document.body.querySelectorAll 'script:not([data-turbolinks-eval="false"])'
        for script in scripts when script.type in ['', 'text/javascript']
          copy = document.createElement 'script'
          copy.setAttribute attr.name, attr.value for attr in script.attributes
          copy.appendChild document.createTextNode script.innerHTML
          { parentNode, nextSibling } = script
          parentNode.removeChild script
          parentNode.insertBefore copy, nextSibling
        return

      createDocument = browserCompatibleDocumentParser()
      el = $(el)
      el.data('remote', true)
      el.data('type', 'html')

      el.bind 'ajax:beforeSend', (event, data, status, xhr) ->
        triggerEvent 'page:fetch'

      el.bind 'ajax:complete', (event, xhr, status) ->
      # create new document
        doc = createDocument xhr.responseText
      # setup title and body
        document.title = doc.querySelector('title')?.textContent
        document.documentElement.replaceChild doc.body, document.body
      # reset scrolls
        window.scrollTo 0, 0
      # remove noscript tags
        noscriptTags = Array::slice.call document.body.getElementsByTagName 'noscript'
        noscript.parentNode.removeChild noscript for noscript in noscriptTags
      # setup csrf token
        CSRFToken.update CSRFToken.get(doc).token
      # execute sscripts
        executeScriptTags()
        triggerEvent 'page:load'

      return
$ ->
  $('form[data-turboform]').turboForms()

$(document).on 'page:load', ->
  $('form[data-turboform]').turboForms()
