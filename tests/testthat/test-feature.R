context("list features")

test_that("features and feature codes can be listed", {
  exp_ids <- list_experiment_ids(tok)
  plates <- list_plates(tok, exp_ids[[1]])
  refs <- list_references(tok, plates[[1]], type = "feature")

  feat_1 <- list_features(tok, refs[[1]])
  expect_is(feat_1, "FeatureInformation")
  expect_is(feat_1, "json_vec")
  expect_identical(get_subclass(feat_1), "FeatureInformation")
  expect_true(all(sapply(feat_1, has_subclass, "FeatureInformation")))
  expect_gte(length(feat_1), 1L)

  feat_2 <- list_features(tok, refs[1:2])
  expect_is(feat_2, "FeatureInformation")
  expect_is(feat_2, "json_vec")
  expect_identical(get_subclass(feat_2), "FeatureInformation")
  expect_true(all(sapply(feat_2, has_subclass, "FeatureInformation")))
  expect_gte(length(feat_2), length(feat_1))

  expect_identical(list_feature_codes(tok, refs[[1]]),
                   lapply(feat_1, `[[`, "code"))
  expect_identical(list_feature_codes(tok, refs[1:2]),
                   lapply(feat_2, `[[`, "code"))
})

test_that("features can be fetched", {
  exp_ids <- list_experiment_ids(tok)
  plates <- list_plates(tok, exp_ids[[1]])
  refs <- list_references(tok, plates[[1]], type = "feature")
  feats <- list_features(tok, refs[[1]])

  codes <- sapply(feats, `[[`, "code")

  feat_data_11 <- fetch_features(tok, refs[[1]], codes[1])
  expect_is(feat_data_11, "FeatureVectorDataset")
  expect_is(feat_data_11, "json_vec")
  expect_identical(get_subclass(feat_data_11), "FeatureVectorDataset")
  expect_true(all(sapply(feat_data_11, has_subclass, "FeatureVectorDataset")))
  expect_equal(length(feat_data_11), 1L)
  expect_true(has_fields(feat_data_11, "featureVectors"))
  expect_equal(length(feat_data_11[[1]][["featureVectors"]]), 384L)
  expect_true(all(sapply(feat_data_11[[1]][["featureVectors"]], has_subclass,
                         "FeatureVector")))
  expect_true(all(sapply(feat_data_11[[1]][["featureVectors"]], has_fields,
                         "values")))
  expect_true(all(sapply(lapply(feat_data_11[[1]][["featureVectors"]], `[[`,
                                "values"), length) == 1L))

  feat_data_12 <- fetch_features(tok, refs[[1]], codes[1:2])
  expect_is(feat_data_12, "FeatureVectorDataset")
  expect_is(feat_data_12, "json_vec")
  expect_identical(get_subclass(feat_data_12), "FeatureVectorDataset")
  expect_true(all(sapply(feat_data_12, has_subclass, "FeatureVectorDataset")))
  expect_equal(length(feat_data_12), 1L)
  expect_true(has_fields(feat_data_12, "featureVectors"))
  expect_equal(length(feat_data_12[[1]][["featureVectors"]]), 384L)
  expect_true(all(sapply(feat_data_12[[1]][["featureVectors"]], has_subclass,
                         "FeatureVector")))
  expect_true(all(sapply(feat_data_12[[1]][["featureVectors"]], has_fields,
                         "values")))
  expect_true(all(sapply(lapply(feat_data_12[[1]][["featureVectors"]], `[[`,
                                "values"), length) == 2L))

  feat_data_1 <- fetch_features(tok, refs[[1]])
  expect_is(feat_data_1, "FeatureVectorDataset")
  expect_is(feat_data_1, "json_vec")
  expect_identical(get_subclass(feat_data_1), "FeatureVectorDataset")
  expect_true(all(sapply(feat_data_1, has_subclass, "FeatureVectorDataset")))
  expect_equal(length(feat_data_1), 1L)
  expect_true(has_fields(feat_data_1, "featureVectors"))
  expect_equal(length(feat_data_1[[1]][["featureVectors"]]), 384L)
  expect_true(all(sapply(feat_data_1[[1]][["featureVectors"]], has_subclass,
                         "FeatureVector")))
  expect_true(all(sapply(feat_data_1[[1]][["featureVectors"]], has_fields,
                         "values")))
  expect_true(all(sapply(lapply(feat_data_1[[1]][["featureVectors"]], `[[`,
                                "values"), length) == length(codes)))

  well_pos <- lapply(feat_data_11[[1]][["featureVectors"]], `[[`,
                     "wellPosition")
  refs_well <- json_vec(
    json_class(datasetCode = refs[[1]][["datasetCode"]],
               datastoreServerUrl = refs[[1]][["datastoreServerUrl"]],
               plate = refs[[1]][["plate"]],
               experimentIdentifier = refs[[1]][["experimentIdentifier"]],
               plateGeometry = refs[[1]][["plateGeometry"]],
               registrationDate = refs[[1]][["registrationDate"]],
               properties = refs[[1]][["properties"]],
               wellPosition = well_pos[[1]],
               class = "FeatureVectorDatasetWellReference"),
    json_class(datasetCode = refs[[1]][["datasetCode"]],
               datastoreServerUrl = refs[[1]][["datastoreServerUrl"]],
               plate = refs[[1]][["plate"]],
               experimentIdentifier = refs[[1]][["experimentIdentifier"]],
               plateGeometry = refs[[1]][["plateGeometry"]],
               registrationDate = refs[[1]][["registrationDate"]],
               properties = refs[[1]][["properties"]],
               wellPosition = well_pos[[2]],
               class = "FeatureVectorDatasetWellReference"))

  feat_data_11 <- fetch_features(tok, refs_well[[1]], codes[1])
  expect_is(feat_data_11, "FeatureVectorWithDescription")
  expect_is(feat_data_11, "json_vec")
  expect_identical(get_subclass(feat_data_11), "FeatureVectorWithDescription")
  expect_true(all(sapply(feat_data_11, has_subclass,
                         "FeatureVectorWithDescription")))
  expect_equal(length(feat_data_11), 1L)
  expect_true(has_fields(feat_data_11[[1]], "values"))
  expect_equal(length(feat_data_11[[1]][["values"]]), 1L)

  feat_data_21 <- fetch_features(tok, refs_well, codes[1])
  expect_is(feat_data_21, "FeatureVectorWithDescription")
  expect_is(feat_data_21, "json_vec")
  expect_identical(get_subclass(feat_data_21), "FeatureVectorWithDescription")
  expect_true(all(sapply(feat_data_21, has_subclass,
                         "FeatureVectorWithDescription")))
  expect_equal(length(feat_data_21), 2L)
  expect_true(all(sapply(feat_data_21, has_fields, "values")))
  expect_true(all(sapply(lapply(feat_data_21, `[[`, "values"), length) == 1L))

  feat_data_12 <- fetch_features(tok, refs_well[[1]], codes[1:2])
  expect_is(feat_data_12, "FeatureVectorWithDescription")
  expect_is(feat_data_12, "json_vec")
  expect_identical(get_subclass(feat_data_12), "FeatureVectorWithDescription")
  expect_true(all(sapply(feat_data_12, has_subclass,
                         "FeatureVectorWithDescription")))
  expect_equal(length(feat_data_12), 1L)
  expect_true(has_fields(feat_data_12[[1]], "values"))
  expect_equal(length(feat_data_12[[1]][["values"]]), 2L)

  feat_data_22 <- fetch_features(tok, refs_well, codes[1:2])
  expect_is(feat_data_22, "FeatureVectorWithDescription")
  expect_is(feat_data_22, "json_vec")
  expect_identical(get_subclass(feat_data_22), "FeatureVectorWithDescription")
  expect_true(all(sapply(feat_data_22, has_subclass,
                         "FeatureVectorWithDescription")))
  expect_equal(length(feat_data_22), 2L)
  expect_true(all(sapply(feat_data_22, has_fields, "values")))
  expect_true(all(sapply(lapply(feat_data_22, `[[`, "values"), length) == 2L))
})