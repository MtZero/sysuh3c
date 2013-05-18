CXXFLAG = -c -std=c++11 -Wall -O2

all: clih3c

clih3c: eapauth.o main.o
	$(CXX) $^ -o $@

eapauth.o: eapauth.cpp eapauth.h eapdef.h
	$(CXX) $(CXXFLAG) $< -o $@

main.o: main.cpp eapauth.h eapdef.h
	$(CXX) $(CXXFLAG) $< -o $@

clean:
	rm -f *.o
