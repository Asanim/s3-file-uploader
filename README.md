
Motivation: 
I recently had to handle multimedia upload in a purely c++ application. Greengrass

A similar project was done in python and can be found here as part of aws labs:
https://github.com/awslabs/aws-greengrass-labs-s3-file-uploader

Further examples using the AWS SDK can be found here:
https://github.com/awsdocs/aws-doc-sdk-examples/tree/main

In theory, after performing the key exchange it is possible to write any application using the AWS SDK as a Greengrass component, as long as the edge device is configured with the necessary IAM permissions

A simple commandline c++ application that uploads files from a directory to s3.



This repo should serve as guidance for anyone looking with a similar use case or looking to use the AWS SDK with AWS Greengrass.

Register your aws credentials with the aws cli:

Deploying locally: 

Deploying in the cloud: 



Goals:
create a s3 build system using c++ 

multi arch builds, point s3 to a directory and it will build for all archs

usage cmdline.
github pipelines 
Releases

- use gtest and glog for unit tests and logging and arguments

