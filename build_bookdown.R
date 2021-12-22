bookdown::render_book("content",
    # css="style.css" is required for <link> tag in HTML index
    # so that custom block styling works
    output_format=bookdown::gitbook(css="style.css")
)