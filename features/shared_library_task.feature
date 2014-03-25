Feature: PaperHouse::SharedLibraryTask

  PaperHouse provides a rake task called
  `PaperHouse::SharedLibraryTask` to build a shared library from *.c
  and *.h files. These source files can be located in multiple
  subdirectories.

  @linux
  Scenario: Build a shared library from one *.c and *.h file
    Given the current project directory is "examples/shared_library"
    When I run rake "hello"
    Then a file named "libhello.so.0.1.0" should exist
    And a file named "hello" should exist
    And I successfully run `sh hello.sh`
    And the output should contain "Hello, PaperHouse!"

  @mac
  Scenario: Build a shared library from one *.c and *.h file
    Given the current project directory is "examples/shared_library"
    When I run rake "hello"
    Then a file named "libhello.so.0.1.0" should exist
    And a file named "hello" should exist
    And I successfully run `sh hello.sh`
    And the output should contain "Hello, PaperHouse!"

  @linux
  Scenario: Build a shared library from one *.c and *.h file using llvm-gcc by specifying `CC=` option
    Given the current project directory is "examples/shared_library"
    When I run rake "hello CC=llvm-gcc"
    Then a file named "libhello.so.0.1.0" should exist
    And a file named "hello" should exist
    And I successfully run `sh hello.sh`
    And the output should contain "Hello, PaperHouse!"

  @mac
  Scenario: Build a shared library from one *.c and *.h file using llvm-gcc by specifying `CC=` option
    Given the current project directory is "examples/shared_library"
    When I run rake "hello CC=llvm-gcc"
    Then a file named "libhello.so.0.1.0" should exist
    And a file named "hello" should exist
    And I successfully run `sh hello.sh`
    And the output should contain "Hello, PaperHouse!"

  @linux
  Scenario: Build a shared library from multiple *.c and *.h files in subcirectories
    Given the current project directory is "examples/shared_library_subdirs"
    When I run rake "hello"
    Then a file named "objects/libhello.so.0.1.0" should exist
    And a file named "hello" should exist
    And I successfully run `sh hello.sh`
    And the output should contain "Hello, PaperHouse!"

  @mac
  Scenario: Build a shared library from multiple *.c and *.h files in subcirectories
    Given the current project directory is "examples/shared_library_subdirs"
    When I run rake "hello"
    Then a file named "objects/libhello.so.0.1.0" should exist
    And a file named "hello" should exist
    And I successfully run `sh hello.sh`
    And the output should contain "Hello, PaperHouse!"

  Scenario: Automatically rebuild an executable when dependent library is updated
    Given the current project directory is "examples/shared_library"
    And I successfully run `rake hello`
    And I successfully run `sleep 1`
    And I successfully run `touch libhello.so.0`
    When I successfully run `rake hello`
    Then the output should contain "gcc"

  Scenario: Clean
    Given the current project directory is "examples/shared_library"
    When I successfully run `rake hello`
    When I successfully run `rake clean`
    Then a file named "hello.o" should not exist
    And a file named "main.o" should not exist
    And a file named ".libhello.depends" should exist
    And a file named ".hello.depends" should exist
    And a file named "libhello.so.0.1.0" should exist
    And a file named "hello" should exist

  Scenario: Clobber
    Given the current project directory is "examples/shared_library"
    When I successfully run `rake hello`
    When I successfully run `rake clobber`
    Then a file named "hello.o" should not exist
    And a file named "main.o" should not exist
    And a file named ".libhello.depends" should not exist
    And a file named ".hello.depends" should not exist
    And a file named "libhello.so.0.1.0" should not exist
    And a file named "hello" should not exist
