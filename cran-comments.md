## Test environments
* Windows 11 x64, R 4.4.2

## R CMD check results
Local check result:
* 0 errors | 0 warnings | 2 notes

Notes:
* This is a resubmission.
* The local Windows check reported "unable to verify current time".

## Resubmission

This is a resubmission. In this version I have:

* Expanded the Description field to describe the package functionality and why it may be useful.
* Replaced the interactive Shiny app example's \dontrun{} wrapper with if (interactive()).
* Did not add method references because the package implements dictionary lookup
  and approximate string matching helpers rather than a published statistical
  method.

## Downstream dependencies

There are currently no downstream dependencies for this package
