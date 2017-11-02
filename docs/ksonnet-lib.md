---
layout: docs
title: ksonnet-lib
description: A Jsonnet base library for Kubernetes
permalink: /docs/core-packages/ksonnet-lib
package: ksonnet-lib
package_source: ksonnet-lib
---
{% capture readme %}
{% include submodules/ksonnet-lib/README.md %}
{% endcapture %}

{% comment %}
The markdown that we are taking from github refers to images in a different
place.  Here we replace the links to point to where those images are for this
site.
{% endcomment %}

{{ readme | markdownify | replace: 'src="docs/images', 'src="/images/ksonnet-lib' }}
