<img height="100" alt="hyperexecute_logo" src="https://user-images.githubusercontent.com/1688653/159473714-384e60ba-d830-435e-a33f-730df3c3ebc6.png">

HyperExecute is a smart test orchestration platform to run end-to-end Selenium tests at the fastest speed possible. HyperExecute lets you achieve an accelerated time to market by providing a test infrastructure that offers optimal speed, test orchestration, and detailed execution logs.

The overall experience helps teams test code and fix issues at a much faster pace. HyperExecute is configured using a YAML file. Instead of moving the Hub close to you, HyperExecute brings the test scripts close to the Hub!

* <b>HyperExecute HomePage</b>: https://www.lambdatest.com/hyperexecute
* <b>Lambdatest HomePage</b>: https://www.lambdatest.com
* <b>LambdaTest Support</b>: [support@lambdatest.com](mailto:support@lambdatest.com)

To know more about how HyperExecute does intelligent Test Orchestration, do check out [HyperExecute Getting Started Guide](https://www.lambdatest.com/support/docs/getting-started-with-hyperexecute/)

[<img alt="Try it now" width="200 px" align="center" src="images/Try it Now.svg" />](https://hyperexecute.lambdatest.com/?utm_source=github&utm_medium=repository&utm_content=python&utm_term=robot)

## Gitpod

Follow the below steps to run Gitpod button:

1. Click '**Open in Gitpod**' button (You will be redirected to Login/Signup page).
2. Login with Lambdatest credentials and it will be redirected to Gitpod editor in new tab and current tab will show hyperexecute dashboard.

[<img alt="Run in Gitpod" width="200 px" align="center" src="images/Gitpod.svg" />](https://hyperexecute.lambdatest.com/hyperexecute/jobs?type=gitpod&framework=Robot)
---
<!---If logged in, it will be redirected to Gitpod editor in new tab where current tab will show hyperexecute dashboard.

If not logged in, it will be redirected to Login/Signup page and simultaneously redirected to Gitpod editor in a new tab where current tab will show hyperexecute dashboard.

If not signed up, you need to sign up and simultaneously redirected to Gitpod in a new tab where current tab will show hyperexecute dashboard.--->

# How to run Selenium automation tests on HyperExecute (using Robot framework)

* [Pre-requisites](#pre-requisites)
   - [Download HyperExecute CLI](#download-hyperexecute-cli)
   - [Configure Environment Variables](#configure-environment-variables)

* [Auto-Split Execution with Robot](#auto-split-execution-with-robot)
   - [Core](#core)
   - [Pre Steps and Dependency Caching](#pre-steps-and-dependency-caching)
   - [Post Steps](#post-steps)
   - [Artifacts Management](#artifacts-management)
   - [Test Execution](#test-execution)

* [Matrix Execution with Robot](#matrix-execution-with-robot)
   - [Core](#core-1)
   - [Pre Steps and Dependency Caching](#pre-steps-and-dependency-caching-1)
   - [Post Steps](#post-steps-1)
   - [Artifacts Management](#artifacts-management-1)
   - [Test Execution](#test-execution-1)

* [Secrets Management](#secrets-management)
* [Navigation in Automation Dashboard](#navigation-in-automation-dashboard)

# Pre-requisites

Before using HyperExecute, you have to download HyperExecute CLI corresponding to the host OS. Along with it, you also need to export the environment variables *LT_USERNAME* and *LT_ACCESS_KEY* that are available in the [LambdaTest Profile](https://accounts.lambdatest.com/detail/profile) page.

## Download HyperExecute CLI

HyperExecute CLI is a CLI for interacting and running the tests on the HyperExecute Grid. It provides a host of other useful features that accelerate test execution. In order to trigger tests using the CLI, you need to download the HyperExecute CLI binary corresponding to the platform (or OS) from where the tests are triggered:

Also, it is recommended to download the binary in the project's parent directory. Shown below is the location from where you can download the HyperExecute CLI binary:

* Mac: https://downloads.lambdatest.com/hyperexecute/darwin/hyperexecute
* Linux: https://downloads.lambdatest.com/hyperexecute/linux/hyperexecute
* Windows: https://downloads.lambdatest.com/hyperexecute/windows/hyperexecute.exe

## Configure Environment Variables

Before the tests are run, please set the environment variables LT_USERNAME & LT_ACCESS_KEY from the terminal. The account details are available on your [LambdaTest Profile](https://accounts.lambdatest.com/detail/profile) page.

For macOS:

```bash
export LT_USERNAME=LT_USERNAME
export LT_ACCESS_KEY=LT_ACCESS_KEY
```

For Linux:

```bash
export LT_USERNAME=LT_USERNAME
export LT_ACCESS_KEY=LT_ACCESS_KEY
```

For Windows:

```bash
set LT_USERNAME=LT_USERNAME
set LT_ACCESS_KEY=LT_ACCESS_KEY
```

## Auto-Split Execution with Robot

Auto-split execution mechanism lets you run tests at predefined concurrency and distribute the tests over the available infrastructure. Concurrency can be achieved at different levels - file, module, test suite, test, scenario, etc.

For more information about auto-split execution, check out the [Auto-Split Getting Started Guide](https://www.lambdatest.com/support/docs/getting-started-with-hyperexecute/#smart-auto-test-splitting)

### Core

Auto-split YAML file (*yaml/win/robot_hyperexecute_autosplit_sample.yaml*) in the repo contains the following configuration:

```yaml
globalTimeout: 90
testSuiteTimeout: 90
testSuiteStep: 90
```

Global timeout, testSuite timeout, and testSuite timeout are set to 90 minutes.
 
The *runson* key determines the platform (or operating system) on which the tests are executed. Here we have set the target OS as Windows.

```yaml
runson: win
```

Auto-split is set to true in the YAML file.

```yaml
 autosplit: true
```

*retryOnFailure* is set to true, instructing HyperExecute to retry failed command(s). The retry operation is carried out till the number of retries mentioned in *maxRetries* are exhausted or the command execution results in a *Pass*. In addition, the concurrency (i.e. number of parallel sessions) is set to 2.

```yaml
retryOnFailure: true
maxRetries: 5
concurrency: 2
```

### Pre Steps and Dependency Caching

Dependency caching is enabled in the YAML file to ensure that the package dependencies are not downloaded in subsequent runs. The first step is to set the Key used to cache directories.

```yaml
cacheKey: '{{ checksum "requirements.txt" }}'
```

Set the array of files & directories to be cached. The packages installed using *pi3* are cached in *pip_cache* directory and packages installed using *poetry install* are cached in the *poetry_cache* directory. In a nutshell, all the packages will be cached in the *pip_cache* and *poetry_cache* directories.

```yaml
cacheDirectories:
  - pip_cache
  - poetry_cache
```

Content under the *pre* directive is the pre-condition that is triggered before the tests are executed on HyperExecute grid. In the example, we have used *Poetry*  for handling dependency & packaging of the Python packages required for running the tests.

Poetry, Robot framework (*robotframework*), and Robot Selenium library (*robotframework-seleniumlibrary*) are installed by triggering the *pip* command. All the required packages are also installed in this step using *pip3 install*. Packages mentioned in *pyprojet.toml* are installed by triggering *poetry install* as a part of the *pre* directive.

```yaml
pre:
  - pip3 install -r requirements.txt --cache-dir pip_cache
  - poetry config virtualenvs.path poetry_cache
  - poetry install
```

### Post Steps

Steps (or commands) that need to run after the test execution are listed in the *post* step. In the example, we *cat* the contents of *yaml/win/robot_hyperexecute_matrix_sample.yaml*

```yaml
post:
  - cat yaml/win/robot_hyperexecute_autpsplit_sample.yaml
```

The *testDiscovery* directive contains the command that gives details of the mode of execution, along with detailing the command that is used for test execution. Here, we are fetching the list of Python files that would be further executed using the *value* passed in the *testRunnerCommand*

```yaml
testDiscovery:
  type: raw
  mode: dynamic
  command: grep 'test_windows' makefile | sed 's/\(.*\):/\1 /'

testRunnerCommand: make $test
```

Running the above command on the terminal will give a list of Python files that are located in the Project folder:

* test_windows_10_edge_latest
* test_windows_10_chrome_latest

The *testRunnerCommand* contains the command that is used for triggering the test. The output fetched from the *testDiscoverer* command acts as an input to the *testRunner* command.

```yaml
testRunnerCommand: python3 -s $test
```

### Artifacts Management

The *mergeArtifacts* directive (which is by default *false*) is set to *true* for merging the artifacts and combing artifacts generated under each task.

The *uploadArtefacts* directive informs HyperExecute to upload artifacts [files, reports, etc.] generated after task completion. In the example, *path* consists of a regex for parsing the directory/file (i.e. *report* that contains the test reports).

```yaml
mergeArtifacts: true

uploadArtefacts:
 - name: HTML_Reports
   path:
    - /*.html
 - name: XML_Reports
   path:
    - /*.xml
```

HyperExecute also facilitates the provision to download the artifacts on your local machine. To download the artifacts, click on *Artifacts* button corresponding to the associated TestID.

<img width="1415" alt="robot_autosplit_artefacts_1" src="https://user-images.githubusercontent.com/1688653/162383459-a812913f-a633-4b00-8cc0-39d1e4a41bbf.png">

Now, you can download the artifacts by clicking on the *Download* button as shown below:

<img width="1422" alt="robot_autosplit_artefacts_2" src="https://user-images.githubusercontent.com/1688653/162383462-6159654c-ca02-45db-935b-d4d3cc5afef9.png">

### Test Execution

The CLI option *--config* is used for providing the custom HyperExecute YAML file (i.e. *yaml/win/robot_hyperexecute_autosplit_sample.yaml* for Windows and *yaml/win/robot_hyperexecute_autosplit_sample.yaml* for Linux).

#### Execute Robot tests using Autosplit mechanism on Windows platform

Run the following command on the terminal to trigger the tests in Robot files with HyperExecute platform set to Windows. The *--download-artifacts* option is used to inform HyperExecute to download the artifacts for the job.

```bash
./hyperexecute --download-artifacts --verbose --config yaml/win/robot_hyperexecute_autosplit_sample.yaml
```

#### Execute Robot tests using Autosplit mechanism on Windows platform

Run the following command on the terminal to trigger the tests in Robot files with HyperExecute platform set to Linux. The *--download-artifacts* option is used to inform HyperExecute to download the artifacts for the job.

```bash
./hyperexecute --download-artifacts --verbose --config yaml/linux/robot_hyperexecute_autosplit_sample.yaml
```

Visit [HyperExecute Automation Dashboard](https://automation.lambdatest.com/hyperexecute) to check the status of execution

<img width="1414" alt="robot_autosplit_execution" src="https://user-images.githubusercontent.com/1688653/162383459-a812913f-a633-4b00-8cc0-39d1e4a41bbf.png">

Shown below is the execution screenshot when the YAML file is triggered from the terminal:

<img width="1422" alt="robot_autosplit_cli1_execution" src="https://user-images.githubusercontent.com/1688653/162383466-af86f03e-2459-4ef8-986a-32a9abfb60fa.png">

<img width="1406" alt="robot_autosplit_cli2_execution" src="https://user-images.githubusercontent.com/1688653/162383469-fc172b8e-6033-476a-bf2d-137cd62ab609.png">

# Matrix Execution with Robot

Matrix-based test execution is used for running the same tests across different test (or input) combinations. The Matrix directive in HyperExecute YAML file is a *key:value* pair where value is an array of strings.

Also, the *key:value* pairs are opaque strings for HyperExecute. For more information about matrix multiplexing, check out the [Matrix Getting Started Guide](https://www.lambdatest.com/support/docs/getting-started-with-hyperexecute/#matrix-based-build-multiplexing)

### Core

In the current example, matrix YAML file (*yaml/win/robot_hyperexecute_matrix_sample.yaml*) in the repo contains the following configuration:

```yaml
globalTimeout: 90
testSuiteTimeout: 90
testSuiteStep: 90
```

Global timeout, testSuite timeout, and testSuite timeout are set to 90 minutes.
 
The target platform is set to Windows. Please set the *[runson]* key to *[mac]* if the tests have to be executed on the macOS platform.

```yaml
runson: win
```

Automation tests using the Robot framework are located in the *Tests* folder (i.e. *lt_todo_app.robot* and *lt_selenium_playground.robot*). In the matrix YAML file, *files* specifies a list (or array) of *.robot* files that have to be executed on the HyperExecute grid.

```yaml
files: ["Tests/lt_todo_app.robot", "Tests/lt_selenium_playground.robot"]
```

The *testSuites* object contains a list of commands (that can be presented in an array). In the example, commands for executing the tests are put in an array (with a '-' preceding each item). Execution of Robot tests is triggered using the *makefile* that is placed at the root location of the project. Since the target *OS* is set to *win*, tests to be executed on Windows 10 are triggered as a part of the *testSuites* object:

```yaml
testSuites:
  - make test_windows_10_edge_latest
  - make test_windows_10_chrome_latest
```

### Pre Steps and Dependency Caching

Dependency caching is enabled in the YAML file to ensure that the package dependencies are not downloaded in subsequent runs. The first step is to set the Key used to cache directories.

```yaml
cacheKey: '{{ checksum "requirements.txt" }}'
```

Set the array of files & directories to be cached. The packages installed using *pi3* are cached in *pip_cache* directory and packages installed using *poetry install* are cached in the *poetry_cache* directory. In a nutshell, all the packages will be cached in the *pip_cache* and *poetry_cache* directories.

```yaml
cacheDirectories:
  - pip_cache
  - poetry_cache
```

Content under the *pre* directive is the pre-condition that is triggered before the tests are executed on HyperExecute grid. In the example, we have used *Poetry*  for handling dependency & packaging of the Python packages required for running the tests.

Poetry, Robot framework (*robotframework*), and Robot Selenium library (*robotframework-seleniumlibrary*) are installed by triggering the *pip* command. All the required packages are also installed in this step using *pip3 install*. Packages mentioned in *pyprojet.toml* are installed by triggering *poetry install* as a part of the *pre* directive.

```yaml
pre:
  - pip3 install -r requirements.txt --cache-dir pip_cache
  - poetry config virtualenvs.path poetry_cache
  - poetry install
```

### Post Steps

Steps (or commands) that need to run after the test execution are listed in the *post* step. In the example, we *cat* the contents of *yaml/win/robot_hyperexecute_matrix_sample.yaml*

```yaml
post:
  - cat yaml/win/robot_hyperexecute_matrix_sample.yaml
```

### Artifacts Management

The *mergeArtifacts* directive (which is by default *false*) is set to *true* for merging the artifacts and combing artifacts generated under each task.

The *uploadArtefacts* directive informs HyperExecute to upload artifacts [files, reports, etc.] generated after task completion. In the example, *path* consists of a regex for parsing the directory/file (i.e. *report* that contains the test reports).

```yaml
mergeArtifacts: true

uploadArtefacts:
 - name: HTML_Reports
   path:
    - /*.html
 - name: XML_Reports
   path:
    - /*.xml
```

HyperExecute also facilitates the provision to download the artifacts on your local machine. To download the artifacts, click on Artifacts button corresponding to the associated TestID.

<img width="1428" alt="robot_matrix_artefacts_1" src="https://user-images.githubusercontent.com/1688653/160470835-dc5730d0-e90c-4df4-97ac-8535b3b62a55.png">

Now, you can download the artifacts by clicking on the Download button as shown below:

<img width="1428" alt="robot_matrix_artefacts_2" src="https://user-images.githubusercontent.com/1688653/160470847-a2e8789e-d46f-4512-b7a4-95b47b89ec20.png">

## Test Execution

The CLI option *--config* is used for providing the custom HyperExecute YAML file (i.e. *yaml/win/robot_hyperexecute_matrix_sample.yaml* for Windows and *yaml/win/robot_hyperexecute_matrix_sample.yaml* for Linux).

#### Execute Robot tests using Matrix mechanism on Windows platform

Run the following command on the terminal to trigger the tests in Robot files with HyperExecute platform set to Windows. The *--download-artifacts* option is used to inform HyperExecute to download the artifacts for the job.

```bash
./hyperexecute --download-artifacts --verbose --config yaml/win/robot_hyperexecute_matrix_sample.yaml
```

#### Execute Robot tests using Matrix mechanism on Linux platform

Run the following command on the terminal to trigger the tests in Robot files with HyperExecute platform set to Linux. The *--download-artifacts* option is used to inform HyperExecute to download the artifacts for the job.

```bash
./hyperexecute --download-artifacts --verbose --config yaml/linux/robot_hyperexecute_matrix_sample.yaml
```

Visit [HyperExecute Automation Dashboard](https://automation.lambdatest.com/hyperexecute) to check the status of execution:

<img width="1414" alt="robot_matrix_execution" src="https://user-images.githubusercontent.com/1688653/160470835-dc5730d0-e90c-4df4-97ac-8535b3b62a55.png">

Shown below is the execution screenshot when the YAML file is triggered from the terminal:

<img width="1413" alt="robot_cli1_execution" src="https://user-images.githubusercontent.com/1688653/162383480-f6e2e389-3d23-4bb1-85b3-21c07a8b8fa7.png">

<img width="1101" alt="robot_cli2_execution" src="https://user-images.githubusercontent.com/1688653/162383481-39ccfa30-4bd5-4745-bf80-a87f1cede631.png">



## Secrets Management

In case you want to use any secret keys in the YAML file, the same can be set by clicking on the *Secrets* button the dashboard.

<img width="703" alt="robot_secrets_key_1" src="https://user-images.githubusercontent.com/1688653/152540968-90e4e8bc-3eb4-4259-856b-5e513cbd19b5.png">

Now create a *secret* key that you can use in the HyperExecute YAML file.

<img width="359" alt="secrets_management_1" src="https://user-images.githubusercontent.com/1688653/153250877-e58445d1-2735-409a-970d-14253991c69e.png">

All you need to do is create an environment variable that uses the secret key:

```yaml
env:
  PAT: ${{ .secrets.testKey }}
```

## Navigation in Automation Dashboard

HyperExecute lets you navigate from/to *Test Logs* in Automation Dashboard from/to *HyperExecute Logs*. You also get relevant get relevant Selenium test details like video, network log, commands, Exceptions & more in the Dashboard. Effortlessly navigate from the automation dashboard to HyperExecute logs (and vice-versa) to get more details of the test execution.

Shown below is the HyperExecute Automation dashboard which also lists the tests that were executed as a part of the test suite:

<img width="1238" alt="robot_hyperexecute_automation_dashboard" src="https://user-images.githubusercontent.com/1688653/162383474-152c59ad-0e66-47f0-956e-0fd590c821f1.png">

Here is a screenshot that lists the automation test that was executed on the HyperExecute grid:

<img width="1423" alt="robot_testing_automation_dashboard" src="https://user-images.githubusercontent.com/1688653/162383477-d5bce408-69c1-49dc-b31a-58da54c3eb64.png">

## LambdaTest Community :busts_in_silhouette:

The [LambdaTest Community](https://community.lambdatest.com/) allows people to interact with tech enthusiasts. Connect, ask questions, and learn from tech-savvy people. Discuss best practises in web development, testing, and DevOps with professionals from across the globe.

## Documentation & Resources :books:
    
If you want to learn more about the LambdaTest's features, setup, and usage, visit the [LambdaTest documentation](https://www.lambdatest.com/support/docs/). You can also find in-depth tutorials around test automation, mobile app testing, responsive testing, manual testing on [LambdaTest Blog](https://www.lambdatest.com/blog/) and [LambdaTest Learning Hub](https://www.lambdatest.com/learning-hub/).     
      
 ## About LambdaTest

[LambdaTest](https://www.lambdatest.com) is a leading test execution and orchestration platform that is fast, reliable, scalable, and secure. It allows users to run both manual and automated testing of web and mobile apps across 3000+ different browsers, operating systems, and real device combinations. Using LambdaTest, businesses can ensure quicker developer feedback and hence achieve faster go to market. Over 500 enterprises and 1 Million + users across 130+ countries rely on LambdaTest for their testing needs.

[<img height="70" src="https://user-images.githubusercontent.com/70570645/169649126-ed61f6de-49b5-4593-80cf-3391ca40d665.PNG">](https://accounts.lambdatest.com/register)
      
## We are here to help you :headphones:

* Got a query? we are available 24x7 to help. [Contact Us](mailto:support@lambdatest.com)
* For more info, visit - https://www.lambdatest.com

## License
Licensed under the [MIT license](LICENSE).
