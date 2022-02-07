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

<img width="1413" alt="robot_cli1_execution" src="https://user-images.githubusercontent.com/1688653/152779140-a734a848-2ee1-4547-b727-87569baa8cae.png">

<img width="1101" alt="robot_cli2_execution" src="https://user-images.githubusercontent.com/1688653/152779162-344651ff-7f80-40ca-9c8a-ebd3da8d9170.png">

## Running tests in Robot using the Auto-Split strategy

Auto-split YAML file (yaml/robot_hypertest_autosplit_sample.yaml) in the repo contains the following configuration:

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
maxRetries: 3
concurrency: 2
```

### Auto-Split Execution: Pre, Post, and Dependency Caching for faster package download & installation

Dependency caching is enabled in the YAML file to ensure that the package dependencies are not downloaded in subsequent runs. The first step is to set the Key used to cache directories.

```yaml
cacheKey: '{{ checksum "requirements.txt" }}'
```

Set the array of files & directories to be cached. The packages installed using *pi3* are cached in *pip_cache* directory and packages installed using *poetry install* are cached in the *poetry_cache* directory.

In a nutshell, all the packages will be cached in the *pip_cache* and *poetry_cache* directories.

```yaml
cacheDirectories:
  - pip_cache
  - poetry_cache
```

Content under the *pre* directive is the pre-condition that is triggered before the tests are executed on HyperTest grid. In the example, we have used *Poetry*  for handling dependency and packaging of the Python packages required for running the tests.

Poetry, Robot framework (*robotframework*), and Robot Selenium library (*robotframework-seleniumlibrary*) are installed by triggering the *pip* command. All the required packages are also installed in this step using *pip3 install*. Packages mentioned in *pyprojet.toml* are installed by triggering *poetry install* as a part of the *pre* directive.

```yaml
pre:
  # Robot Framework and Robot Selenium Library need to be installed globally
  # Rest of the packages can be installed in venv
  - pip3 install -r requirements.txt --cache-dir pip_cache
  - poetry config virtualenvs.path poetry_cache
  - poetry install
```

Steps (or commands) that need to run after the test execution are listed in the *post* step. In the example, we cat the contents of *yaml/robot_hypertest_autosplit_sample.yaml*

```yaml
post:
  - cat yaml/robot_hypertest_autosplit_sample.yaml
```

The *upload* directive informs HyperTest to upload artefacts [files, reports, etc.] generated after task completion. In the example, the *reports.html* file that contains details of the test execution is uploaded by HyperTest. 

```yaml
upload:
  - report.html
```

The *testDiscoverer* contains the command that gives details of the tests that are a part of the project. Here, we are fetching the list of Robot files that meet the search criteria mentioned in the command. The result is further passed in the *testRunnerCommand*

```bash
grep 'test_windows' makefile | sed 's/\(.*\):/\1 /'
```

Running the above command on the terminal gives the list of *makefile* labels that match our requirement:

```
test_windows_10_edge_latest 
test_windows_10_chrome_latest
```

*testRunnerCommand* contains the command that is used for triggering the test. The output fetched from the *testDiscoverer* command acts as an input to the *testRunner* command.

```
make $test
```

The CLI option *--config* is used for providing the custom HyperTest YAML file (i.e. yaml/robot_hypertest_autosplit_sample.yaml). Run the following command on the terminal to trigger the tests in Robot files on the HyperTest grid. The *--download-artifacts* option is used to inform HyperTest to download the artefacts for the job.

```bash
./concierge --download-artifacts --config yaml/robot_hypertest_autosplit_sample.yaml --verbose
```

Visit [HyperTest Automation Dashboard](https://automation.lambdatest.com/hypertest) to check the status of execution

<img width="1433" alt="robot_autosplit_execution" src="https://user-images.githubusercontent.com/1688653/152325722-d3c492a4-efc5-4d7e-b969-51b9d3f65231.png">
