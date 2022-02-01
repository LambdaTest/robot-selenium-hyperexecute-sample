# How to run Selenium automation tests on Hypertest (using Robot framework)

Download the concierge binary corresponding to the host operating system. It is recommended to download the binary in the project's Parent Directory.

* Mac: https://downloads.lambdatest.com/concierge/darwin/concierge
* Linux: https://downloads.lambdatest.com/concierge/linux/concierge
* Windows: https://downloads.lambdatest.com/concierge/windows/concierge.exe

[Note - The current project has concierge for macOS. Irrespective of the host OS, the concierge will auto-update whenever there is a new version on the server]

## Running tests in Robot using the Matrix strategy

Matrix YAML file (robot_hypertest_matrix_sample.yaml) in the repo contains the following configuration:

```yaml
globalTimeout: 90
testSuiteTimeout: 90
testSuiteStep: 90
```

Global timeout, testsuite timeout, and suite step timeout are each set to 90 minutes.
 
The target platform is set to macOS

```yaml
os: [mac]
```

Environment variables *LT_USERNAME* and *LT_ACCESS_KEY* are added under *env* in the YAML file.

```yaml
env:
 LT_USERNAME: ${ YOUR_LAMBDATEST_USERNAME()}
 LT_ACCESS_KEY: ${ YOUR_LAMBDATEST_ACCESS_KEY()}
```

Automation tests using the Robot framework are located in the *Tests* folder (i.e. lt_todo_app.robot and lt_selenium_playground.robot). In the matrix YAML file, *files* specifies a list (or array) of *.robot* files that have to be executed on the Hypertest grid.

```yaml
files: ["Tests/lt_todo_app.robot", "Tests/lt_selenium_playground.robot"]
```

Content under the *pre* directive is the pre-condition that will be run before the tests are executed on Hypertest grid. In the reference code, we have used Poetry tool for handling dependency and packaging of the Python packages that are required in running the tests.

Poetry, Robot framework (robotframework), and Robot Selenium library (robotframework-seleniumlibrary) are installed by triggering the *pip* command. All the required packages are also installed in this step using *pip3 install*. Packages mentioned in *pyprojet.toml* are installed by triggering *poetry install* as a part of the *pre* condition.

```yaml
pre:
 pip3 install poetry
 pip3 install robotframework
 pip3 install robotframework-seleniumlibrary
 # Rest of the packages can be installed in venv
 poetry install
```

The *testSuites* object contains a list of commands (that can be presented in an array). In the current YAML file, commands to be run for executing the tests are put in an array (with a '-' preceding each item). In the current YAML file, the *robot* execution is triggered using the *makefile* that is placed at the root location of the project. 

```yaml
testSuites:
  - make test_macos_12_firefox_latest
  - make test_macos_10_chrome_latest
```

The [user_name and access_key of LambdaTest](https://accounts.lambdatest.com/detail/profile) is appended to the *concierge* command using the *--user* and *--key* command-line options. The CLI option *--config* is used for providing the custom Hypertest YAML file (e.g. robot_hypertest_matrix_sample.yaml). Run the following command on the terminal to trigger the tests in Robot files on the Hypertest grid.

```bash
./concierge --user "${ YOUR_LAMBDATEST_USERNAME()}" --key "${ YOUR_LAMBDATEST_ACCESS_KEY()}" --config robot_hypertest_matrix_sample.yaml --verbose
```

Visit [Hypertest Automation Dashboard](https://automation.lambdatest.com/hypertest) to check the status of execution

## Running tests in Robot using the Auto-Split strategy

Auto-Split YAML file (robot_hypertest_autosplit_sample.yaml) in the repo contains the following configuration:

```yaml
globalTimeout: 90
testSuiteTimeout: 90
testSuiteStep: 90
```

Global timeout, testsuite timeout, and suite step timeout are each set to 90 minutes.
 
The *runson* key determines the platform (or operating system) on which the tests would be executed. Here we have set the target OS as macOS.

```yaml
 runson: mac
```

Auto-split is set to true in the YAML file. Retry on failure (*retryOnFailure*) is set to False. When set to true, failed test execution will be retried until the *maxRetries* are exhausted (or test execution is successful). Concurrency (i.e. number of parallel sessions) is set to 2.

```yaml
 autosplit: true
 retryOnFailure: false
 maxRetries: 5
 concurrency: 2
```

Environment variables *LT_USERNAME* and *LT_ACCESS_KEY* are added under *env* in the YAML file.

```yaml
env:
 LT_USERNAME: ${ YOUR_LAMBDATEST_USERNAME()}
 LT_ACCESS_KEY: ${ YOUR_LAMBDATEST_ACCESS_KEY()}
```

Content under the *pre* directive is the pre-condition that will be run before the tests are executed on Hypertest grid. In the reference code, we have used Poetry tool for handling dependency and packaging of the Python packages that are required in running the tests. Poetry, Robot framework (robotframework), and Robot Selenium library (robotframework-seleniumlibrary) are installed by triggering the *pip* command.

```yaml
 pip3 install poetry
 pip3 install robotframework
 pip3 install robotframework-seleniumlibrary
 # Rest of the packages can be installed in venv
 poetry install
```

All the required packages are also installed in this step using *pip3 install*. Packages mentioned in *pyprojet.toml* are installed by triggering *poetry install* as a part of the *pre* condition.

```yaml
 poetry install
```

The *testDiscoverer* contains the command that gives details of the tests that are a part of the project. Here, we are fetching the list of Robot files that would be further executed using the *value* passed in the *testRunnerCommand*

```bash
grep 'test_macos' makefile | sed 's/\(.*\):/\1 /'
```

Running the above command on the terminal gives the list of *makefile* labels that match our requirement:

```
test_macos_10_chrome_latest 
test_macos_12_firefox_latest
```

The *testRunnerCommand* contains the command that is used for triggering the test. The output fetched from the *testDiscoverer* command acts as an input to the *testRunner* command.

```
make $test
```
Run the following command on the terminal to trigger the tests in Robot files on the Hypertest grid.

```bash
./concierge --user "${ YOUR_LAMBDATEST_USERNAME()}" --key "${ YOUR_LAMBDATEST_ACCESS_KEY()}" --config robot_hypertest_autosplit_sample.yaml --verbose
``` 

Visit [Hypertest Automation Dashboard](https://automation.lambdatest.com/hypertest) to check the status of execution