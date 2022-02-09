<img width="92" alt="hypertest_logo" src="https://user-images.githubusercontent.com/1688653/153131001-02ff0fdb-73dc-49d6-98bc-351a7b320f65.png">

HyperTest is a smart test orchestration platform to run end-to-end Selenium tests at the fastest speed possible. HyperTest lets you achieve an accelerated time to market by providing a test infrastructure that offers optimal speed, test orchestration, and detailed execution logs.

The overall experience helps teams test code and fix issues at a much faster pace. HyperTest is configured using a YAML file. Instead of moving the Hub close to you, HyperTest brings the test scripts close to the Hub!

* <b>HyperTest HomePage</b>: https://www.lambdatest.com/hypertest
* <b>Lambdatest HomePage</b>: https://www.lambdatest.com
* <b>LambdaTest Support</b>: [support@lambdatest.com](mailto:support@lambdatest.com)

To know more about how HyperTest does intelligent Test Orchestration, do check out [HyperTest Getting Started Guide](https://www.lambdatest.com/support/docs/getting-started-with-hypertest/)

# How to run Selenium automation tests on HyperTest (using Robot framework)

* [Pre-requisites](#pre-requisites)
   - [Download Concierge](#download-concierge)
   - [Configure Environment Variables](#configure-environment-variables)
   
* [Matrix Execution with Robot](#matrix-execution-with-robot)
   - [Core](#core)
   - [Pre Steps and Dependency Caching](#pre-steps-and-dependency-caching)
   - [Post Steps](#post-steps)
   - [Artefacts Management](#artefacts-management)
   - [Test Execution](#test-execution)

* [Auto-Split Execution with Robot](#auto-split-execution-with-robot)
   - [Core](#core-1)
   - [Pre Steps and Dependency Caching](#pre-steps-and-dependency-caching-1)
   - [Post Steps](#post-steps-1)
   - [Artefacts Management](#artefacts-management-1)
   - [Test Execution](#test-execution-1)

* [Secrets Management](#secrets-management)
* [Navigation in Automation Dashboard](#navigation-in-automation-dashboard)

# Pre-requisites

Before using HyperTest, you have to download Concierge CLI corresponding to the host OS. Along with it, you also need to export the environment variables *LT_USERNAME* and *LT_ACCESS_KEY* that are available in the [LambdaTest Profile](https://accounts.lambdatest.com/detail/profile) page.

## Download Concierge

Concierge is a CLI for interacting and running the tests on the HyperTest Grid. Concierge provides a host of other useful features that accelerate test execution. In order to trigger tests using Concierge, you need to download the Concierge binary corresponding to the platform (or OS) from where the tests are triggered:

Also, it is recommended to download the binary in the project's parent directory. Shown below is the location from where you can download the Concierge binary: 

* Mac: https://downloads.lambdatest.com/concierge/darwin/concierge
* Linux: https://downloads.lambdatest.com/concierge/linux/concierge
* Windows: https://downloads.lambdatest.com/concierge/windows/concierge.exe

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

# Matrix Execution with Robot

Matrix-based test execution is used for running the same tests across different test (or input) combinations. The Matrix directive in HyperTest YAML file is a *key:value* pair where value is an array of strings.

Also, the *key:value* pairs are opaque strings for HyperTest. For more information about matrix multiplexing, check out the [Matrix Getting Started Guide](https://www.lambdatest.com/support/docs/getting-started-with-hypertest/#matrix-based-build-multiplexing)

### Core

In the current example, matrix YAML file (*yaml/robot_hypertest_matrix_sample.yaml*) in the repo contains the following configuration:

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

Automation tests using the Robot framework are located in the *Tests* folder (i.e. *lt_todo_app.robot* and *lt_selenium_playground.robot*). In the matrix YAML file, *files* specifies a list (or array) of *.robot* files that have to be executed on the HyperTest grid.

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

Content under the *pre* directive is the pre-condition that is triggered before the tests are executed on HyperTest grid. In the example, we have used *Poetry*  for handling dependency & packaging of the Python packages required for running the tests.

Poetry, Robot framework (*robotframework*), and Robot Selenium library (*robotframework-seleniumlibrary*) are installed by triggering the *pip* command. All the required packages are also installed in this step using *pip3 install*. Packages mentioned in *pyprojet.toml* are installed by triggering *poetry install* as a part of the *pre* directive.

```yaml
pre:
  - pip3 install -r requirements.txt --cache-dir pip_cache
  - poetry config virtualenvs.path poetry_cache
  - poetry install
```

### Post Steps

Steps (or commands) that need to run after the test execution are listed in the *post* step. In the example, we *cat* the contents of *yaml/robot_hypertest_matrix_sample.yaml*

```yaml
post:
  - cat yaml/robot_hypertest_matrix_sample.yaml
```

### Artefacts Management

The *mergeArtifacts* directive (which is by default *false*) is set to *true* for merging the artefacts and combing artefacts generated under each task.

The *uploadArtefacts* directive informs HyperTest to upload artefacts [files, reports, etc.] generated after task completion. In the example, *path* consists of a regex for parsing the directory/file (i.e. *report* that contains the test reports).

```yaml
mergeArtifacts: true

uploadArtefacts:
  [
    {
      "name": "report",
      "path": ["report.html"]
    }
  ]
```

HyperTest also facilitates the provision to download the artefacts on your local machine. To download the artefacts, click on Artefacts button corresponding to the associated TestID.

<img width="1428" alt="robot_matrix_artefacts_1" src="https://user-images.githubusercontent.com/1688653/152778296-171cd64a-1606-44cb-89bd-700a414f58ae.png">

Now, you can download the artefacts by clicking on the Download button as shown below:

<img width="1428" alt="robot_matrix_artefacts_2" src="https://user-images.githubusercontent.com/1688653/152778325-b769c3ab-cf7e-4fa1-9ab0-9005c237fd0e.png">

## Test Execution

The CLI option *--config* is used for providing the custom HyperTest YAML file (i.e. *yaml/robot_hypertest_matrix_sample.yaml*). Run the following command on the terminal to trigger the tests in Python files on the HyperTest grid. The *--download-artifacts* option is used to inform HyperTest to download the artefacts for the job.

```bash
./concierge --download-artifacts --config --verbose yaml/robot_hypertest_matrix_sample.yaml
```

Visit [HyperTest Automation Dashboard](https://automation.lambdatest.com/hypertest) to check the status of execution:

<img width="1414" alt="robot_matrix_execution" src="https://user-images.githubusercontent.com/1688653/152778296-171cd64a-1606-44cb-89bd-700a414f58ae.png">

Shown below is the execution screenshot when the YAML file is triggered from the terminal:

<img width="1413" alt="robot_cli1_execution" src="https://user-images.githubusercontent.com/1688653/153120274-170efd8c-5b23-4ecf-a89b-e70f2b395a22.png">

<img width="1101" alt="robot_cli2_execution" src="https://user-images.githubusercontent.com/1688653/152779162-344651ff-7f80-40ca-9c8a-ebd3da8d9170.png">

## Auto-Split Execution with Robot

Auto-split execution mechanism lets you run tests at predefined concurrency and distribute the tests over the available infrastructure. Concurrency can be achieved at different levels - file, module, test suite, test, scenario, etc.

For more information about auto-split execution, check out the [Auto-Split Getting Started Guide](https://www.lambdatest.com/support/docs/getting-started-with-hypertest/#smart-auto-test-splitting)

### Core

Auto-split YAML file (*yaml/robot_hypertest_autosplit_sample.yaml*) in the repo contains the following configuration:

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

*retryOnFailure* is set to true, instructing HyperTest to retry failed command(s). The retry operation is carried out till the number of retries mentioned in *maxRetries* are exhausted or the command execution results in a *Pass*. In addition, the concurrency (i.e. number of parallel sessions) is set to 2.

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

Content under the *pre* directive is the pre-condition that is triggered before the tests are executed on HyperTest grid. In the example, we have used *Poetry*  for handling dependency & packaging of the Python packages required for running the tests.

Poetry, Robot framework (*robotframework*), and Robot Selenium library (*robotframework-seleniumlibrary*) are installed by triggering the *pip* command. All the required packages are also installed in this step using *pip3 install*. Packages mentioned in *pyprojet.toml* are installed by triggering *poetry install* as a part of the *pre* directive.

```yaml
pre:
  - pip3 install -r requirements.txt --cache-dir pip_cache
  - poetry config virtualenvs.path poetry_cache
  - poetry install
```

### Post Steps

Steps (or commands) that need to run after the test execution are listed in the *post* step. In the example, we *cat* the contents of *yaml/robot_hypertest_matrix_sample.yaml*

```yaml
post:
  - cat yaml/robot_hypertest_autpsplit_sample.yaml
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

### Artefacts Management

The *mergeArtifacts* directive (which is by default *false*) is set to *true* for merging the artefacts and combing artefacts generated under each task.

The *uploadArtefacts* directive informs HyperTest to upload artefacts [files, reports, etc.] generated after task completion. In the example, *path* consists of a regex for parsing the directory/file (i.e. *report* that contains the test reports).

```yaml
mergeArtifacts: true

uploadArtefacts:
  [
    {
      "name": "report",
      "path": ["report.html"]
    }
  ]
```

HyperTest also facilitates the provision to download the artefacts on your local machine. To download the artefacts, click on *Artefacts* button corresponding to the associated TestID.

<img width="1415" alt="robot_autosplit_artefacts_1" src="https://user-images.githubusercontent.com/1688653/152783525-8fb709cc-63d8-4888-b513-4fac37404604.png">

Now, you can download the artefacts by clicking on the *Download* button as shown below:

<img width="1422" alt="robot_autosplit_artefacts_2" src="https://user-images.githubusercontent.com/1688653/152780924-058e83bd-7e9e-4bc9-a52d-834c78760af9.png">

### Test Execution

The CLI option *--config* is used for providing the custom HyperTest YAML file (i.e. *yaml/robot_hypertest_autosplit_sample.yaml*). Run the following command on the terminal to trigger the tests in Python files on the HyperTest grid. The *--download-artifacts* option is used to inform HyperTest to download the artefacts for the job.

```bash
./concierge --download-artifacts --verbose --config yaml/robot_hypertest_autosplit_sample.yaml
```

Visit [HyperTest Automation Dashboard](https://automation.lambdatest.com/hypertest) to check the status of execution

<img width="1414" alt="robot_autosplit_execution" src="https://user-images.githubusercontent.com/1688653/152783525-8fb709cc-63d8-4888-b513-4fac37404604.png">

Shown below is the execution screenshot when the YAML file is triggered from the terminal:

<img width="1422" alt="robot_autosplit_cli1_execution" src="https://user-images.githubusercontent.com/1688653/152782594-fc4ed050-f425-403c-b8d6-f8894d66ab93.png">

<img width="1406" alt="robot_autosplit_cli2_execution" src="https://user-images.githubusercontent.com/1688653/152783131-f1b8ef7a-48ce-447b-ba48-320bdc43656e.png">

## Secrets Management

In case you want to use any secret keys in the YAML file, the same can be set by clicking on the *Secrets* button the dashboard.

<img width="703" alt="robot_secrets_key_1" src="https://user-images.githubusercontent.com/1688653/152540968-90e4e8bc-3eb4-4259-856b-5e513cbd19b5.png">

Now create *secrets* that you can use in the HyperTest YAML file.

<img width="362" alt="robot_secrets_key_2" src="https://user-images.githubusercontent.com/1688653/152540977-436a8ba8-0ded-44db-8407-b3fb21b1f98d.png">

## Navigation in Automation Dashboard

HyperTest lets you navigate from/to *Test Logs* in Automation Dashboard from/to *HyperTest Logs*. You also get relevant get relevant Selenium test details like video, network log, commands, Exceptions & more in the Dashboard. Effortlessly navigate from the automation dashboard to HyperTest logs (and vice-versa) to get more details of the test execution.

Shown below is the HyperTest Automation dashboard which also lists the tests that were executed as a part of the test suite:

<img width="1238" alt="robot_hypertest_automation_dashboard" src="https://user-images.githubusercontent.com/1688653/152783525-8fb709cc-63d8-4888-b513-4fac37404604.png">

Here is a screenshot that lists the automation test that was executed on the HyperTest grid:

<img width="1423" alt="robot_testing_automation_dashboard" src="https://user-images.githubusercontent.com/1688653/152784306-749c5d8c-b72c-40e9-a707-5374cc530430.png">

## We are here to help you :)
* LambdaTest Support: [support@lambdatest.com](mailto:support@lambdatest.com)
* Lambdatest HomePage: https://www.lambdatest.com
* HyperTest HomePage: https://www.lambdatest.com/support/docs/getting-started-with-hypertest/

## License
Licensed under the [MIT license](LICENSE).
