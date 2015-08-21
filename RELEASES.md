
## 0.0.13-SNAPSHOT/20150821-18:59:53

* Depencies
  * 'mustache',          '>=1.0.1' (prev ~>1.0.1)
  * 'thor',              '>=0.18.1'(prev ~>0.18.1)

## 0.0.12/20150821-18:59:43

* code modifications:
  * refractor aws-must.generate --> aws-must.generate_str
  * better support for rspec 
  
## 0.0.11/20150820-21:22:43

* [README](README.md) added link to
  [aws-must-templates](https://github.com/jarjuk/aws-must-templates)

## 0.0.10/20150814-10:56:52

* added option -g (for specifiyng template gem and version information)
* gemspec modifications


## 0.0.9/20150811-11:19:16

* 	https://rawgit.com/[user]/[repository]/[branch]/[filename.ext] for
	html links

## 0.0.8/20150811-11:05:16

* linked example documents to README
* include html-documents for demo cases in `generated-docs` folder

## 0.0.7/20150810-14:17:33

* add support for folding template data using `+++fold-on+++` and
  `+++fold-off+++` directives, see more in `aws-must.rb help doc`

* output instructions to use `--template_path` -option when root template file not found

* Adjust rule changed: "By default 'adjusts' data, i.e. adds property
  "`_comma`" with the value "," to each sub document, expect the last
  sub-document is adjusted with empty string "".


## 0.0.6/20150617-16:50:24

* sync with [blog post](https://jarjuk.wordpress.com/2015/06/15/love-aws-part3-2/)

## 0.0.5/20150615-10:31:24

* added documentation to `rake demo:html-i`

## 0.0.4/20150611-11:57:05

* added paramter `with_adjust` to `aws-must.rb json` command 
* added demo case 8 (installs Chef)

## 0.0.3/20150610-15:22:38

* `rake  demo:diff`: added the possibility choose prev demo case
* Documentation clarification

## 0.0.2/20150610-12:17:07

* Added `rake dev:full-delivery`
* Documentation enc

## 0.0.1/20150610-10:53:30

* fist version


## 0.0.0/18.00.2013

- Base release
