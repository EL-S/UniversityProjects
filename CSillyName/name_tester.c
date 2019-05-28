#include <stdio.h>
#include <string.h>
#include "terminal_user_input.h"

#define LOOP_COUNT 60

void print_silly_name(my_string name)
{
	
	int index;
	printf("%s is a ", name.str);

	// Move the following code into a procedure
	// ie:  void print_silly_name(char* name)

	for(index=0;index<LOOP_COUNT;index++) {

		printf("silly ");

	}
	printf("name!");
}

int main()
{
	my_string name;

	name = read_string("What is your name? ");
	if (strcmp(name.str, "Md Hossain") == 0)
	{
		printf("%s is an AWESOME name!", name.str);
	} else {
		print_silly_name(name);
	}
	return 0;
}