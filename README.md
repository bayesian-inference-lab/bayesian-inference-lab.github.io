# Bayesian Inference LAB Website

This repository contains the Jekyll source for the Bayesian Inference LAB website at INHA University.

## Pages

- Home
- Research
- People
- Publications
- Software
- Projects
- Contact

## Editing Content

Most recurring content is stored in `_data`.

- `_data/people.yml`: lab members
- `_data/publications.yml`: publications
- `_data/software.yml`: software and packages
- `_data/projects.yml`: research projects

Static pages are in the repository root:

- `index.html`
- `research.html`
- `people.html`
- `publications.html`
- `software.html`
- `projects.html`
- `contact.html`

## Local Preview

Install Ruby and Bundler, then run:

```bash
bundle install
bundle exec jekyll serve
```

The site will be available at `http://localhost:4000`.

