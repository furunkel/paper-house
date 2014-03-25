Feature: PaperHouse::StaticLibraryTask

  PaperHouse provides a rake task called
  `PaperHouse::StaticLibraryTask` to build a static library from *.c
  and *.h files. These source files can be located in multiple
  subdirectories.

  Scenario: Build a static library from one *.c and *.h file
    Given the current project directory is "examples/static_library"
    When I run rake "hello"
    Then a file named "libhello.a" should exist
    And a file named "hello" should exist
    And I successfully run `./hello`
    And the output should contain "Hello, PaperHouse!"

  Scenario: Build a static library from one *.c and *.h file using llvm-gcc by specifying `CC=` option
    Given the current project directory is "examples/static_library"
    When I run rake "hello CC=llvm-gcc"
    Then a file named "libhello.a" should exist
    And a file named "hello" should exist
    And I successfully run `./hello`
    And the output should contain "Hello, PaperHouse!"


  Scenario: Build a static library from multiple *.c and *.h files in subcirectories
    Given the current project directory is "examples/static_library_subdirs"
    When I run rake "hello"
    Then a file named "objects/libhello.a" should exist
    And a file named "hello" should exist
    And I successfully run `./hello`
    And the output should contain "Hello, PaperHouse!"

  Scenario: Automatically rebuild an executable when dependent library is updated
    Given the current project directory is "examples/static_library"
    And I successfully run `rake hello`
    And I successfully run `sleep 1`
    And I successfully run `touch libhello.a`
    When I successfully run `rake hello`
    Then the output should contain "gcc"

  Scenario: Clean
    Given the current project directory is "examples/static_library"
    And I successfully run `rake hello`
    When I successfully run `rake clean`
    Then a file named "hello.o" should not exist
    And a file named "main.o" should not exist
    And a file named ".libhello.depends" should exist
    And a file named ".hello.depends" should exist
    And a file named "libhello.a" should exist
    And a file named "hello" should exist

  Scenario: Clobber
    Given the current project directory is "examples/static_library"
    And I successfully run `rake hello`
    When I successfully run `rake clobber`
    Then a file named "hello.o" should not exist
    And a file named "main.o" should not exist
    And a file named ".libhello.depends" should not exist
    And a file named ".hello.depends" should not exist
    And a file named "libhello.a" should not exist
    And a file named "hello" should not exist
