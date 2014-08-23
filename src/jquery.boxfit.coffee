###
BoxFit v1.1 - jQuery Plugin
(c) 2012 Michi Kono (michikono.com); https://github.com/michikono/boxfit
License: http://www.opensource.org/licenses/mit-license.php
To use: $('#target-div').boxFit()
Will make the *text* content inside the div (or whatever tag) scale to fit that tag
###

(($) ->
  $.fn.boxfit = (options) ->
    return this.each () ->
      settings =
        # manually set a width if you haven't set one explicitly via CSS
        width: null
        # manually set a height if you haven't set one explicitly via CSS
        height: null
        # the amount to change each time - bigger numbers are faster but fit less perfectly
        step_size: 1
        # the number of font size iterations we should step through until we give up
        step_limit: 200
        # set to false to NOT align middle (vertically)
        align_middle: true
        # set to false this to NOT center the text (horizontally)
        align_center: true
        # set to false to allow the big text to wrap (useful for when you want text to fill a big vertical area)
        multiline: false
        # minimum font size (changing this may cause some "shrink" scenarios to overflow instead)
        minimum_font_size: 5
        # set to a number to limit the maximum font size allowed
        maximum_font_size: null

      $.extend( settings, options );

      # take measurements
      if settings.width
        original_width = settings.width
        $(this).width original_width + "px"
      else
        original_width = $(this).width()
      if settings.height
        original_height = settings.height
        $(this).height original_height + "px"
      else
        original_height = $(this).height()

      settings.maxFont = true if settings.maxFontSize isnt `undefined`

      if !original_width || !original_height
        console.info("Set static height/width on target DIV before using boxfit! Detected width: '#{original_width}'; height: '#{original_height}'") if window.console?
      else
        unless settings.multiline
          $(this).css('white-space', 'nowrap')

        original_text = $(this).html()

        if $("<div>" + original_text + "</div>").find("span.boxfitted").length is 0
          span = $($("<span></span>").addClass("boxfitted").html(original_text))
          $(this).html span
        else
          span = $($(this).find('span.boxfitted')[0])

        current_step = 0
        inner_span = span

        $(this).css "display", "table"
        inner_span.css "display", "table-cell"
        if settings.align_middle
          inner_span.css "vertical-align", "middle"
        if settings.align_center
          $(this).css "text-align", "center"
          inner_span.css "text-align", "center"

        # keep growing the target so long as we haven't exceeded the width or height
        inner_span.css("font-size", settings.minimum_font_size)
        while $(this).width() <= original_width  && $(this).height() <= original_height
          break if current_step++ > settings.step_limit
          next_font_size = parseInt(inner_span.css("font-size"), 10)
          break if settings.maximum_font_size && next_font_size > settings.maximum_font_size
          inner_span.css("font-size", next_font_size + settings.step_size)
        # go back one step
        inner_span.css("font-size", parseInt(inner_span.css("font-size"), 10) - settings.step_size)
        return $(this)
)( jQuery )
