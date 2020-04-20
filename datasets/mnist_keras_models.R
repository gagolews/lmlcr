# Part of the LMLCR book by M.Gagolewski
#
# This is less reproducible than letting knitr execute the code,
# but I was fed up with the long compilation times.
# Plus caching of intermediate objects yields the cache director of size 300+MB.

options(encoding="UTF-8")
set.seed(666)
options(width=64)
options(digits=7)
reticulate::use_python("/opt/anaconda3/bin/python")
library("keras")
options("keras.fit_verbose"=1)

one_hot_encode <- function(Y) {
    stopifnot(is.numeric(Y))
    c1 <- min(Y) # first class label
    cK <- max(Y) # last class label
    K <- cK-c1+1 # number of classes
    Y2 <- matrix(0, nrow=length(Y), ncol=K)
    Y2[cbind(1:length(Y), Y-c1+1)] <- 1
    Y2
}

mnist <- dataset_mnist()
X_train <- mnist$train$x
Y_train <- mnist$train$y
X_test  <- mnist$test$x
Y_test  <- mnist$test$y
X_train <- X_train/255
X_test  <- X_test/255
X_train2 <- matrix(X_train, ncol=28*28)
X_test2  <- matrix(X_test, ncol=28*28)
Y_train2 <- one_hot_encode(Y_train)
Y_test2 <- one_hot_encode(Y_test)


file_name <- "datasets/mnist_keras_model1.h5"
if (!file.exists(file_name)) {
    set.seed(123)
    # Start with an empty model
    model1 <- keras_model_sequential()
    # Add a single layer with 10 units and softmax activation
    layer_dense(model1, units=10, activation="softmax")
    # We will be minimising the cross-entropy,
    # sgd == stochastic gradient descent, see the next chapter
    compile(model1, optimizer="sgd",
            loss="categorical_crossentropy")
    # Fit the model (slooooow!)
    fit(model1, X_train2, Y_train2, epochs=10)
    # Save the model for future reference
    save_model_hdf5(model1, file_name)
} else {
    # File exists -> reload the model
    model1 <- load_model_hdf5(file_name)
}


file_name <- "datasets/mnist_keras_model2.h5"
if (!file.exists(file_name)) {
    set.seed(123)
    model2 <- keras_model_sequential()
    layer_dense(model2, units=800, activation="relu")
    layer_dense(model2, units=10,  activation="softmax")
    compile(model2, optimizer="sgd",
            loss="categorical_crossentropy")
    fit(model2, X_train2, Y_train2, epochs=10)
    save_model_hdf5(model2, file_name)
} else {
    model2 <- load_model_hdf5(file_name)
}



file_name <- "datasets/mnist_keras_model3.h5"
if (!file.exists(file_name)) {
    set.seed(123)
    model3 <- keras_model_sequential()
    layer_dense(model3, units=2500, activation="relu")
    layer_dense(model3, units=2000, activation="relu")
    layer_dense(model3, units=1500, activation="relu")
    layer_dense(model3, units=1000, activation="relu")
    layer_dense(model3, units=500,  activation="relu")
    layer_dense(model3, units=10,   activation="softmax")
    compile(model3, optimizer="sgd",
            loss="categorical_crossentropy")
    fit(model3, X_train2, Y_train2, epochs=10)
    save_model_hdf5(model3, file_name)
} else {
    model3 <- load_model_hdf5(file_name)
}





# Deskewing takes some time as well......

# See https://github.com/gagolews/Playground.R
source("~/R/Playground.R/deskew.R")

file_name <- "datasets/mnist_deskewed_train.rds"
if (!file.exists(file_name)) {
    Z_train <- X_train
    for (i in 1:dim(Z_train)[1]) {
        Z_train[i,,] <- deskew(Z_train[i,,])
    }
    Z_train2 <- matrix(Z_train, ncol=28*28)
    saveRDS(Z_train2, file_name)
} else {
    Z_train2 <- readRDS(file_name)
}

file_name <- "datasets/mnist_deskewed_test.rds"
if (!file.exists(file_name)) {
    Z_test <- X_test
    for (i in 1:dim(Z_test)[1]) {
        Z_test[i,,] <- deskew(Z_test[i,,])
    }
    Z_test2 <- matrix(Z_test, ncol=28*28)
    saveRDS(Z_test2, file_name)
} else {
    Z_test2 <- readRDS(file_name)
}






file_name <- "datasets/mnist_keras_model1d.h5"
if (!file.exists(file_name)) {
    set.seed(123)
    model1d <- keras_model_sequential()
    layer_dense(model1d, units=10, activation="softmax")
    compile(model1d, optimizer="sgd",
            loss="categorical_crossentropy")
    fit(model1d, Z_train2, Y_train2, epochs=10)
    save_model_hdf5(model1d, file_name)
} else {
    model1d <- load_model_hdf5(file_name)
}


file_name <- "datasets/mnist_keras_model2d.h5"
if (!file.exists(file_name)) {
    set.seed(123)
    model2d <- keras_model_sequential()
    layer_dense(model2d, units=800, activation="relu")
    layer_dense(model2d, units=10,  activation="softmax")
    compile(model2d, optimizer="sgd",
            loss="categorical_crossentropy")
    fit(model2d, Z_train2, Y_train2, epochs=10)
    save_model_hdf5(model2d, file_name)
} else {
    model2d <- load_model_hdf5(file_name)
}



file_name <- "datasets/mnist_keras_model3d.h5"
if (!file.exists(file_name)) {
    set.seed(123)
    model3d <- keras_model_sequential()
    layer_dense(model3d, units=2500, activation="relu")
    layer_dense(model3d, units=2000, activation="relu")
    layer_dense(model3d, units=1500, activation="relu")
    layer_dense(model3d, units=1000, activation="relu")
    layer_dense(model3d, units=500,  activation="relu")
    layer_dense(model3d, units=10,   activation="softmax")
    compile(model3d, optimizer="sgd",
            loss="categorical_crossentropy")
    fit(model3d, Z_train2, Y_train2, epochs=10)
    save_model_hdf5(model3d, file_name)
} else {
    model3d <- load_model_hdf5(file_name)
}




