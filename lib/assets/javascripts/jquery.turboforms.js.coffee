$ = jQuery
TL = Turbolinks

$.fn.extend
  turboForms: (options) ->
    return @each (i, el) ->
      createDocument = TL.browserCompatibleDocumentParser()
      el = $(el)

      el.data('remote', true)
      el.data('type', 'html')

      el.bind 'ajax:beforeSend', (event, data, status, xhr) ->
        TL.triggerEvent 'page:fetch'

      el.bind 'ajax:complete', (event, xhr, status) ->
        doc = createDocument xhr.responseText

        TL.changePage TL.extractTitleAndBody(doc)...
        TL.reflectRedirectedUrl xhr
        TL.resetScrollPosition()
        TL.triggerEvent 'page:load'

$ ->
  $('form[data-turboform]').turboForms()

$(document).on 'page:load', ->
  $('form[data-turboform]').turboForms()