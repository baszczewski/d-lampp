baszczewski-lampp
==================

Usage
-----

To create the image `baszczewski/lampp`, execute the following command on the folder:

	docker build -t baszczewski/lampp .

Running
------------------------------
```bash
docker run -d --link mariadb:database -p 8080:80 -v /home/user/www:/www:Z --name lampp baszczewski/lampp
```
