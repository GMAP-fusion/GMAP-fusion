
all:
	@echo
	@echo Nothing to compile.
	@echo Optionally, run
	@echo '     make pull_tutorial_data'
	@echo to pull the tutorial data
	@echo


pull_tutorial_data:
	git clone git@github.com:DISCASM/DISCASM-Tutorial.git Tutorial


