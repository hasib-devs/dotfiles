MONGO_CONF=./mongod-rs0.conf
MONGO_PID=.mongodb/data/rs0/mongod.pid
REPLSET=rs0

.PHONY: mongo-start mongo-stop mongo-status

mongo-start:
	@echo "Starting MongoDB (replica set: $(REPLSET))..."
	@if [ -f $(MONGO_PID) ] && ps -p $$(cat $(MONGO_PID)) > /dev/null 2>&1; then \
		echo "MongoDB is already running (PID: $$(cat $(MONGO_PID)))."; \
	else \
		nohup mongod --config $(MONGO_CONF) > .mongodb/data/rs0/mongod.log 2>&1 & echo $$! > $(MONGO_PID); \
		echo "MongoDB started in background (PID: $$(cat $(MONGO_PID)))."; \
	fi

mongo-stop:
	@echo "Stopping MongoDB..."
	@if [ -f $(MONGO_PID) ] && ps -p $$(cat $(MONGO_PID)) > /dev/null 2>&1; then \
		kill -2 $$(cat $(MONGO_PID)); \
		rm -f $(MONGO_PID); \
		echo "MongoDB stopped."; \
	else \
		rm -f $(MONGO_PID); \
		echo "MongoDB is not running."; \
	fi

mongo-status:
	@if [ -f $(MONGO_PID) ] && ps -p $$(cat $(MONGO_PID)) > /dev/null 2>&1; then \
		ps -p $$(cat $(MONGO_PID)) -o pid,comm=; \
	else \
		echo "MongoDB not running."; \
	fi

