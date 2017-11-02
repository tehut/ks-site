---
layout: default
custom_js:
- ksonnet.js
- monaco-editor/min/vs/loader.js
- jsonnet-lang.js
- editor.js
- slider.js
third_party_js:
- //cdn.rawgit.com/thejameskyle/slick/lazy-load-responsive-2/slick/slick.min.js
---

<!-- NOTE ON THE IMPORTS ABOVE: The order of these imports is *very*
important. Browserify, which is used to package `ksonnet.js` does not
play well with `loader.js`, so it is important for that to come
second. -->

<div class="hero">
  <div class="hero__content">
    <h1>ksonnet: Simplify working with Kubernetes</h1>
    <p>A Jsonnet library that compiles to Kubernetes YAML</p>
  </div>

  <div class="hero__content">
    <div class="hero-repl">
      <div class="hero-repl__editor">
        <div class="hero-repl__pane hero-repl__pane--left">
          <h3>Type Jsonnet code</h3>
            <div id="hero-repl-in" class="hero-repl__code">
              <div id="hero-repl-in-placeholder">loading...</div>
            </div>
        </div>
        <div class="hero-repl__pane hero-repl__pane--right">
          <h3>Get API-compatible Kubernetes YAML objects</h3>
          <div id="hero-repl-out" class="hero-repl__code"></div>
          <div class="hero-repl__error"></div>
        </div>
      </div>
    </div>
  </div>
</div>

<div class="container">
  <div class="row featurette featurette--get-started">
    <div class="col-md-12">
      <h2>Tools for Kubernetes configuration.</h2>
      <div class="row">
        <div class="col-md-6">
          <h3>Install the ksonnet toolchain</h3>
<div markdown="1">
```shell
# Install Jsonnet CLI tool, clone the library repository
brew install jsonnet
git clone git@github.com:ksonnet/ksonnet-lib.git
```
</div>
        </div>
        <div class="col-md-6">
          <h3>Install the <a href="https://marketplace.visualstudio.com/items?itemName=heptio.jsonnet">Visual Studio Code extension</a></h3>
<div markdown="1">
```shell
# Install the Jsonnet Visual Studio Code extension
code --install-extension heptio.jsonnet
```
</div>
        </div>
      </div>
    </div>
  </div>

  <hr class="featurette-divider">

  <div class="row featurette">
    <div class="col-md-7">
      <h2>ksonnet: a Jsonnet library.</h2>
      <p>
        <a href="http://jsonnet.org/">Jsonnet</a> is an open-source JSON templating language from Google. Its design is informed in part by the experience of using Borg Configuration Language (BCL) to operate some of the largest clusters on the planet.
      </p>
      <p>
        As a Jsonnet library, <a href="https://github.com/ksonnet/ksonnet-lib">ksonnet-lib</a> leverages the modern langauge features of Jsonnet to make it easy to write flexible, modular Kubernetes applications.
      </p>
    </div>
    <div class="col-md-5">
      <h3 class="top-level">Some Jsonnet language features:</h3>
      <ul class="ksonnet-tick-list">
          <li><a href="http://jsonnet.org/docs/tutorial.html#locals">Variables</a></li>
          <li><a href="http://jsonnet.org/docs/tutorial.html#references">References</a></li>
          <li><a href="http://jsonnet.org/docs/tutorial.html#functions">Functions</a></li>
          <li><a href="http://jsonnet.org/docs/tutorial.html#arith_cond">Arithmetic</a></li>
          <li><a href="http://jsonnet.org/docs/tutorial.html#arith_cond">Conditionals</a></li>
          <li><a href="http://jsonnet.org/docs/tutorial.html#comprehension">Array comprehension</a></li>
          <li><a href="http://jsonnet.org/docs/tutorial.html#comprehension">Object comprehension</a></li>
          <li><a href="http://jsonnet.org/docs/tutorial.html#imports">Imports and libraries</a></li>
          <li><a href="http://jsonnet.org/docs/tutorial.html#oo">Object-orientation and mixins</a></li>
          <li><a href="http://jsonnet.org/docs/tutorial.html#computed_optional_fields">Optional object fields</a></li>
          <br>
          <p><a href="http://jsonnet.org/">Visit jsonnet.org &rarr;</a></p>
      </ul>
    </div>
  </div>

  <hr class="featurette-divider">

  <div class="row featurette">
    <div class="col-md-12">
      <h2>Kubernetes objects with sensible defaults.</h2>
      <p>
        ksonnet includes a number of utility functions that allow users to easily create sensible default values for the <a href="https://kubernetes.io/docs/api-reference/v1.6/">Kubernetes API objects</a>. This way, developers can use the API, but ignore the parts of it they don't need.
      </p>
      <p>
        This example defines a deployment for an nginx container, and then generates a default <a href="https://kubernetes.io/docs/api-reference/v1.6/#deployment-v1beta1-apps">Deployment</a> object from it.
      </p>
      <div class="row">
        <div class="col-md-6">
          <h3>Input Jsonnet code:</h3>
<div markdown="1">
```jsonnet
local k = import "ksonnet.beta.2/k.libsonnet";
local deployment = k.apps.v1beta1.deployment;
local container = deployment.mixin.spec.template.spec.containersType;
local containerPort = container.portsType;

// Create nginx container with container port 80 open.
local nginxContainer =
  container.new("nginx", "nginx:1.13.0") +
  container.ports(containerPort.newNamed("http", 80));

// Create default `Deployment` object from nginx container.
deployment.new("nginx", 5, nginxContainer, {app: "nginx"})


```
</div>
        </div>
        <div class="col-md-6">
          <h3>Output YAML:</h3>
<div markdown="1">
```yaml
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 5
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - image: 'nginx:1.13.0'
          name: nginx
          ports:
            - containerPort: 80
              name: http
```
</div>
        </div>
      </div>
    </div>
  </div>

  <hr class="featurette-divider">

  <div class="row featurette">
    <div class="col-md-12">
      <h2 id="pluggable">Flexible when the defaults aren't right for you.</h2>
      <div class="row">
        <div class="col-md-6">
          <p>Sometimes the defaults aren't enough. ksonnet uses Jsonnet's flexible object model to let users "mix in" changes to objects. This example shows how to write these mixins to make changes to the update strategy or the selector.</p>
          <p><a href="http://jsonnet.org/docs/tutorial.html#oo">Learn more about Jsonnet mixins. &rarr;</a></p>
        </div>
        <div class="col-md-6">
<div markdown="1">
```jsonnet
local k = import "ksonnet.beta.2/k.libsonnet";
local deployment = k.apps.v1beta1.deployment;
local container = deployment.mixin.spec.template.spec.containersType;
local containerPort = container.portsType;

// Create nginx container with container port 80 open.
local nginxContainer =
  container.new("nginx", "nginx:1.13.0") +
  container.ports(containerPort.newNamed("http", 80));

// Create default `Deployment` object from nginx container.
deployment.new("nginx", 5, nginxContainer, {app: "nginx"}) +
deployment.mixin.spec.revisionHistoryLimit(10) +
deployment.mixin.spec.minReadySeconds(60)
```
</div>
        </div>
      </div>
    </div>
  </div>

  <hr class="featurette-divider">

  <div class="row featurette">
    <div class="col-md-12">
      <h2 id="pluggable">Use templates only when you need them.</h2>
      <div class="row">
        <div class="col-md-6">
          <p>ksonnet is designed to work well with JSON versions of the Kubernetes API objects. This approach lets users choose templates only when they need them, and not when they don't.</p>

          <p>This example uses the ksonnet mixin facilities to customize a default deployment object. Notice that the <code>+</code> operator is all you need to work with the raw JSON.</p>
        </div>
        <div class="col-md-6">
<div markdown="1">
```jsonnet
local k = import "ksonnet.beta.2/k.libsonnet";
local deployment = k.apps.v1beta1.deployment;
local spec = deployment.mixin.spec;

{
  "apiVersion": "extensions/v1beta1",
  "kind": "Deployment",
  "metadata": {
    "name": "nginx",
  },
  "spec": {
    "replicas": 2,
    "template": {
        "spec": {
          "containers": [{
            "image": "nginx:1.7.9",
            "imagePullPolicy": "Always",
            "name": "nginx",
          }],
}}}} +
spec.revisionHistoryLimit(10) +
spec.template.metadata.labels({ "app": "nginx" })
```
</div>
        </div>
      </div>
    </div>
  </div>

  <hr class="featurette-divider">

  <div class="row featurette">
    <div class="col-md-12">
      <h2 id="debuggable">Visual Studio Code support.</h2>
      <div class="row">
        <div class="col-md-6">
          <p>Tooling is important. ksonnet is supported by a <a href="https://marketplace.visualstudio.com/items?itemName=heptio.jsonnet">VS Code extension</a> that includes static analysis features, like autocompletion and syntax highlighting. More are on the way!</p>
        </div>
        <div class="col-md-6">
          <img src="{{ site.baseurl }}/images/featurettes/autocomplete.png?t={{ site.time | date_to_xmlschema }}" alt="autocompletion" class="featurette-image img-responsive">
        </div>
      </div>
    </div>
  </div>

  <hr class="featurette-divider">

  <div class="featurette">
    <h2 class="text-center">
      <a href="{{ site.baseurl }}/working-with/">
        Who is working with ksonnet?
      </a>
    </h2>

    <div class="ksonnet-working-with-container ksonnet-slider">
      {% for working-with in site.data.working-with limit:18 %}
        <div class="col-md-4 col-sm-6">
          <a class="ksonnet-working-with" href="{{working-with.url}}" title="{{working-with.name}}">
            <img class="img-responsive" data-lazy="/images/working-with/{{working-with.logo}}" alt="{{working-with.name}}" data-proofer-ignore>
          </a>
        </div>
      {% endfor %}
    </div>

    <div class="text-center">
      <div class="btn-wrapper">
        <a href="{{ site.baseurl }}/working-with/" class="btn btn-sm btn-featured">Meet more... </a>
      </div>
    </div>
  </div>

  <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.4.1/slick.css">
</div>
