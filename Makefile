MONGO_CONF=./mongod-rs0.conf
MONGO_PID=.mongodb/data/rs0/mongod.pid
REPLSET=rs0

.PHONY: mongo-start mongo-stop mongo-status

mongo-start:
	@echo "Starting MongoDB (replica set: $(REPLSET))..."
	@[ -f $(MONGO_PID) ] && echo "MongoDB is already running (PID: $$(cat $(MONGO_PID)))" || \
	(nohup mongod --config $(MONGO_CONF) > .mongodb/data/rs0/mongod.log 2>&1 & echo $$! > $(MONGO_PID) && \
	 echo "MongoDB started in background (PID: $$(cat $(MONGO_PID))).")

mongo-stop:
	@echo "Stopping MongoDB..."
	@[ -f $(MONGO_PID) ] && kill -2 $$(cat $(MONGO_PID)) && rm -f $(MONGO_PID) && echo "MongoDB stopped." || \
	 echo "MongoDB is not running."

mongo-status:
	@[ -f $(MONGO_PID) ] && ps -p $$(cat $(MONGO_PID)) -o pid,comm= || echo "MongoDB not running."

