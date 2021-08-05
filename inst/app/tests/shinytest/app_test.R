app <- ShinyDriver$new("../../")
app$snapshotInit("app_test")

app$uploadFile(file1 = "gender_test.csv")
app$snapshot()
app$setInputs(dictionary = "narrow_en")
app$snapshot()
app$snapshot()
