# -- AsyncAPIをもとにwebsoketmockサーバーを立てる
mock-init:
	# mock-serverディレクトリが存在しない場合にのみ実施
	mkdir ./mock-server
	docker build -t asyncapi-generator ./ && \
	docker run --name asyncapi-generator-container asyncapi-generator && \
	docker cp asyncapi-generator-container:/mock-server ./ ; \
	docker rm asyncapi-generator-container ; \
	docker rmi asyncapi-generator

# mock-serverのコンテナを作成し、8080ポートで起動
mock-start:
	# imageは都度削除される
	docker build -t mock-server-image ./mock-server
	docker run --rm --name mock-server -p 8080:80 mock-server-image

mock-clean:
	rm -rf ./mock-server

PHONY:nock-init mock-start
