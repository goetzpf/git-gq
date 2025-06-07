# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'git-gq'
copyright = '2025, Goetz Pfeiffer <goetzpf@googlemail.com>'
author = 'Goetz Pfeiffer <goetzpf@googlemail.com>'
version = '1.0' #VERSION#
release = version

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = ['sphinx.ext.autodoc', 'sphinx.ext.doctest', 'sphinx.ext.viewcode',
              'sphinx_rtd_theme'
             ]

templates_path = ['_templates']
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']



# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = "sphinx_rtd_theme"

# Theme options are theme-specific and customize the look and feel of a theme
# further.  For a list of options available for each theme, see the
# documentation.
#html_theme_options = {}
html_theme_options = {
    #'canonical_url': '',
    #'analytics_id': 'UA-XXXXXXX-1',  #  Provided by Google in your dashboard
    #'logo_only': False,
    #'display_version': True,
    #'prev_next_buttons_location': 'bottom',
    #'style_external_links': False,
    ##'vcs_pageview_mode': '',
    #'style_nav_header_background': 'white',
    # Toc options
    'collapse_navigation': False,
    'sticky_navigation': True,
    'navigation_depth': -1,
    'includehidden': True,
    'titles_only': False
}

# The name of an image file (relative to this directory) to place at the top
# of the sidebar.
html_logo = None
#html_logo = "logo_hzb_big.gif"

html_static_path = ['_static']
