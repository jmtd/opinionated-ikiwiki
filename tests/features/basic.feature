@opinionated-ikiwiki
Feature: Miscellaneous unit tests

  Scenario: Check that the running user is ikiwiki
    When container is started with args
    | arg     | value   |
    | command | whoami  | 
    Then available container log should contain ikiwiki

  Scenario: Check the image has the right locale set
    Given image is built
    Then the image should contain environment variable LANG with value C.UTF-8
     And the image should contain environment variable USER with value ikiwiki
