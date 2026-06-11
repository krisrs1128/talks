-- Split the bibliography across multiple revealjs slides.
-- Runs citeproc internally, so set `citeproc: false` in YAML.

local refs_per_slide = 12

function Pandoc(doc)
  -- Run citeproc to generate the #refs div
  doc = pandoc.utils.citeproc(doc)

  -- Walk the document looking for the #refs div
  local found = false
  local result = pandoc.List()

  for _, block in ipairs(doc.blocks) do
    if block.t == "Div" and block.identifier == "refs" then
      found = true
      local entries = block.content
      if #entries <= refs_per_slide then
        result:insert(block)
      else
        local chunk = pandoc.List()
        local count = 0
        local slide_num = 0

        for i, item in ipairs(entries) do
          count = count + 1
          chunk:insert(item)

          if count >= refs_per_slide or i == #entries then
            slide_num = slide_num + 1
            if slide_num > 1 then
              result:insert(pandoc.HorizontalRule())
              result:insert(pandoc.Header(3, "References (cont.)"))
            end
            result:insert(pandoc.Div(chunk, pandoc.Attr("refs-" .. slide_num, {"references", "csl-bib-body"})))
            chunk = pandoc.List()
            count = 0
          end
        end
      end
    else
      result:insert(block)
    end
  end

  doc.blocks = result
  return doc
end
