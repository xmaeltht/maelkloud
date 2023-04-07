# This is Custom Python WebApp

**Note**: This App will be listening from port 90

Example: <https://localhost:90/>

## Here ate the steps need it to build this App and have it running

* docker image build -t <image_name> .   #This will build the image.
* docker container run -d -p 90:90 <image_name>
* go to your browser and try to acces the webpage `localhost:90`
