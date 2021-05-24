app <- ShinyDriver$new("../../")
app$snapshotInit("mytest")

app$setInputs(dictionary = "narrow")
app$setInputs(dlformat = ".sav")
app$setInputs(dlformat = ".dta")
app$setInputs(sidebarCollapsed = TRUE)
app$setInputs(sidebarCollapsed = FALSE)
app$snapshot()
