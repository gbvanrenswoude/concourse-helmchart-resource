# helm-chart-resource

A Concourse resource for managing Helm charts. It's based of the work of the linkyard guys, but is also able to push up chart updates to multiple registries.

## Installing

Use this resource by adding the following to the resource_types section of a pipeline config:

```yaml
resource_types:

- name: helm-chart
  type: docker-image
  source:
    repository: gbvanrenswoude/helm-chart-resource
```

See the [Concourse docs](https://concourse-ci.org/resource-types.html) for more details on adding `resource_types` to a pipeline config.

## Source Configuration

* `chart`: *Required.* Name of chart, with or without repo name
* `repos`: *Optional.* Array of Helm repositories to initialize, each repository is defined as an object with properties name, url (required) username and password (optional).

Example source configuration:
```yml
chart: skodje
repos:
  - name: cpt-helm-vr
    url: https://artifactory.prd.ss.aws.insim.biz/artifactory/cpt-helm-vr
    username: cpt-helm-npa-rw
    password: {{artifactory_password}}
  - name: cpt-helm
    url: https://artifactory.prd.ss.aws.insim.biz/artifactory/cpt-helm-vr
    username: cpt-helm-npa-rw
    password: {{artifactory_password}}
```

## Behavior

### `check`: Check for new chart version.

### `in`: Downloads the chart.

Downloads the chart that was discovered during the `check` phase as a tar.

#### Parameters

- `untar`: *Optional.* Extract the tar after downloading. Defaults to `false`.
- `untardir`: *Optional.* Name of the directory that untar will extract to.
- `verify`: *Optional.* Verify the package against its signature. Defaults to `false`.

### `out`: Packages and uploads a new version of the chart.

- `directory`: *Required.* Give the directory where to package and upload the chart from.


## Examples

### In

Checks for version changes on the chart, downloads and untars it:

```yaml
resources:
- name: chart-code-nc
  type: git
  source:
    uri: https://vcs.aws.insim.biz/dockernn/nn-controller
    branch: master
    username: concourse
    password: {{gitlab_password}}
    skip_ssl_verification: true
    paths:
      - chart/nn-controller/**

- name: chart-nc
  type: helm-chart
  source:
    chart: {{ artifactory.repository }}/nn-controller
    repos:
      - name: {{ artifactory.repository }}   
        url: {{ artifactory.url }}/{{ artifactory.repository }}
        username: {{ artifactory.user }}
        password: {{artifactory_password}}

jobs:
- name: build-helm-nc
  plan:
  - get: chart-code-nc
    trigger: true
  - put: chart-nc
    params:
      directory: chart-code-nc/chart/nn-controller
```

----
### How to run locally
To run the check or in commands locally, use:
```
cd assets
cat ../test/sample_input_in.json | ./in './'
cat ../test/sample_input_in.json | ./in './' 2> /dev/null
```
and check
```
cat ../test/sample_input_check.json | ./check
cat ../test/sample_input_check.json | ./check 2> /dev/null
```
and out
```
cat ../test/sample_input_out.json | ./check
cat ../test/sample_input_out.json | ./check 2> /dev/null
```
Make sure you have python3 and your dependencies installed if you run the code directly and not via the Docker image.

If you run the Docker image, comment in the ENV vars in the Dockerfile bc corporate. Run the docker image and pass the sample input to stdin
```
docker build -t bob .
docker run --rm -it -v ~/.aws:/root/.aws bob
```
When in bob
```
cd /opt/resource
cat ../test/sample_input_in.json | ./in './'
```
----
☁ ☼  ☁

_̴ı̴̴̡̡̡ ̡͌l̡̡̡ ̡͌l̡*̡̡ ̴̡ı̴̴̡ ̡̡͡|̲̲̲͡͡͡ ̲▫̲͡ ̲̲̲͡͡π̲̲͡͡ ̲̲͡▫̲̲͡͡ ̲|̡̡̡ ̡ ̴̡ı̴̡̡ ̡͌l̡̡̡̡.__  
°º¤ø,¸¸,ø¤º°°º¤ø,¸,ø¤°º¤ø,¸¸,ø¤º°°º¤ø,¸
