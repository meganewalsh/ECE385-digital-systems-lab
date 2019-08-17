// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main()
{
	unsigned int accumulator = 0;
	volatile unsigned int *LED_PIO = (unsigned int*)0x80; //make a pointer to access the PIO block
	volatile unsigned int *SW_PIO = (unsigned int*)0x60;
	volatile unsigned int *BUTTON_PIO = (unsigned int*)0x50;
	*LED_PIO = 0; //clear all LEDs
	int i = 0;

	while ( (1+1) != 3) //infinite loop
	{
		//reset
		if (*BUTTON_PIO == 0x2)
			*LED_PIO = 0; //clear all LEDs

		//accumulate
		else if (*BUTTON_PIO == 0x1) {
			accumulator += *SW_PIO;
			//wrap around
			if (accumulator > 255)
				accumulator = accumulator - 256;

			for (i = 0; i < 100000; i++); //software delay
			*LED_PIO = accumulator; //set LSB

		}
	}
	return 1; //never gets here
}
