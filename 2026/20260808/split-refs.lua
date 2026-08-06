-- Split the bibliography across multiple revealjs slides.
-- Runs citeproc internally, so set `citeproc: false` in YAML.

local refs_per_slide = 12

function Pandoc(doc)
  -- Run citeproc to generate the #refs div
  doc = pandoc.utils.citeproc(doc)

  -- Walk the document looking for the #refs div
  local result = pandoc.List()
  local refs_found = false

  for _, block in ipairs(doc.blocks) do
    if block.t == "Div" and block.identifier == "refs" then
      refs_found = true
      
      local entries = block.content
      if #entries <= refs_per_slide then
        -- If fewer than refs_per_slide, keep original structure
        table.insert(result, block)
      else
        -- Split into multiple slides
        local chunk = pandoc.List()
        local count = 0
        local slide_num = 0

        for i, item in ipairs(entries) do
          count = count + 1
          table.insert(chunk, item)

          if count >= refs_per_slide or i == #entries then
            slide_num = slide_num + 1
            
            -- Create a new slide section for this reference chunk
            local slide_blocks = pandoc.List()
            
            if slide_num == 1 then
              -- First slide: add "References" header
              table.insert(slide_blocks, pandoc.Header(3, "References", pandoc.Attr("", {"smaller"}, {})))
            else
              -- Continuation slides: add "References (cont.)" header
              table.insert(slide_blocks, pandoc.Header(3, "References (cont.)", pandoc.Attr("", {"smaller"}, {})))
            end
            
            -- Add the reference chunk
            local refs_div_attr = pandoc.Attr("refs-" .. slide_num, {"references", "csl-bib-body"}, {})
            table.insert(slide_blocks, pandoc.Div(chunk, refs_div_attr))
            
            -- Create a reveal.js slide section
            local slide_section = pandoc.Div(slide_blocks, pandoc.Attr("", {"slide", "level2", "smaller", "scrollable"}, {}))
            table.insert(result, slide_section)
            
            -- Reset for next chunk
            chunk = pandoc.List()
            count = 0
          end
        end
      end
    else
      -- Skip any headers that might be part of the original references section
      if not (block.t == "Header" and block.level == 3 and 
             (block.content[1].text == "References" or block.content[1].text == "References (cont.)")) then
        table.insert(result, block)
      end
    end
  end



  doc.blocks = result
  return doc
end