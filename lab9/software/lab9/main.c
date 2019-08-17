/************************************************************************
Lab 9 Nios Software

Dong Kai Wang, Fall 2017
Christine Chen, Fall 2013

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "aes.h"

void ShiftRows(unsigned char *);
void encrypt(unsigned char *, unsigned char *, unsigned int *, unsigned int *);
void SubBytes(unsigned char *);
void MixColumns(unsigned char *);
void KeyExpansion(unsigned char *, unsigned int *, int Nk);
unsigned int RotWord(unsigned int);
unsigned int SubWord(unsigned int);
void AddRoundKey(unsigned char *, unsigned int *, int);
void decrypt(unsigned int *, unsigned int *, unsigned int *);

// Pointer to base address of AES module, make sure it matches Qsys
volatile unsigned int * AES_PTR = (unsigned int *) 0x10001000;

// Execution mode: 0 for testing, 1 for benchmarking
int run_mode = 0;

/** charToHex
 *  Convert a single character to the 4-bit value it represents.
 *
 *  Input: a character c (e.g. 'A')
 *  Output: converted 4-bit value (e.g. 0xA)
 */
char charToHex(char c)
{
	char hex = c;

	if (hex >= '0' && hex <= '9')
		hex -= '0';
	else if (hex >= 'A' && hex <= 'F')
	{
		hex -= 'A';
		hex += 10;
	}
	else if (hex >= 'a' && hex <= 'f')
	{
		hex -= 'a';
		hex += 10;
	}
	return hex;
}

/** charsToHex
 *  Convert two characters to byte value it represents.
 *  Inputs must be 0-9, A-F, or a-f.
 *
 *  Input: two characters c1 and c2 (e.g. 'A' and '7')
 *  Output: converted byte value (e.g. 0xA7)
 */
char charsToHex(char c1, char c2)
{
	char hex1 = charToHex(c1);
	char hex2 = charToHex(c2);
	return (hex1 << 4) + hex2;
}

/** encrypt
 *  Perform AES encryption in software.
 *
 *  Input: msg_ascii - Pointer to 32x 8-bit char array that contains the input message in ASCII format
 *         key_ascii - Pointer to 32x 8-bit char array that contains the input key in ASCII format
 *  Output:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *               key - Pointer to 4x 32-bit int array that contains the input key
 */

//WEEK 1
void encrypt(unsigned char * msg_ascii, unsigned char * key_ascii, unsigned int * msg_enc, unsigned int * key)
{
	//ascii character = 8 bits = 1 byte
	//msg_ascii = 256 bits = 32 bytes
	//Nr = 10, Nb = 4;

	unsigned char state[16];
	unsigned char word_key[16];
	unsigned int word[44];
	for(int i = 0; i < 16; i++)
	{
		state[i] = charsToHex(msg_ascii[2*i], msg_ascii[(2*i)+1]);
		word_key[i] = charsToHex(key_ascii[2*i], key_ascii[(2*i)+1]);
	}

	KeyExpansion(word_key, word, 4);

	unsigned int firstChunk[4] = {word[0], word[1], word[2], word[3]};
	AddRoundKey(state, firstChunk, 0);

	//Encryption Round
	for (int round = 1; round <= 9; round++) {
		 SubBytes(state);
		 ShiftRows(state);
		 MixColumns(state);

		 unsigned int chunk[4] = {word[round*4], word[round*4 + 1], word[round*4 + 2], word[round*4+3]};
		 AddRoundKey(state, chunk, round);
	}

	//Last Round
	SubBytes(state);
	ShiftRows(state);
	unsigned int lastChunk[4] = {word[40], word[41], word[42], word[43]};
	AddRoundKey(state, lastChunk, 10);

	//Set outputs
	int key0 = word_key[0] << 24 | word_key[1] << 16 | word_key[2] << 8 | word_key[3];
	int key1 = word_key[4] << 24 | word_key[5] << 16 | word_key[6] << 8 | word_key[7];
	int key2 = word_key[8] << 24 | word_key[9] << 16 | word_key[10] << 8 | word_key[11];
	int key3 = word_key[12] << 24 | word_key[13] << 16 | word_key[14] << 8 | word_key[15];
	key[0] = key0;
	key[1] = key1;
	key[2] = key2;
	key[3] = key3;

	int word0 = state[0] << 24 | state[1] << 16 | state[2] << 8 | state[3];
	int word1 = state[4] << 24 | state[5] << 16 | state[6] << 8 | state[7];
	int word2 = state[8] << 24 | state[9] << 16 | state[10] << 8 | state[11];
	int word3 = state[12] << 24 | state[13] << 16 | state[14] << 8 | state[15];
	msg_enc[0] = word0;
	msg_enc[1] = word1;
	msg_enc[2] = word2;
	msg_enc[3] = word3;
}
void SubBytes(unsigned char * state){
//one byte is 8 bits
	for (int x = 0; x < 16; x++){
			state[x] = aes_sbox[(state[x] >> 4)*16 + (state[x] & 0x0F)];
	}
}
void ShiftRows(unsigned char * state){
//row n is left-circularly shifted by n-1 Bytes

unsigned char state1[16];
for (int i = 0; i < 16; i++)
	state1[i] = state[i];

state[1] = state1[5];
state[5] = state1[9];
state[9] = state1[13];
state[13] = state1[1];
state[2] = state1[10];
state[6] = state1[14];
state[10] = state1[2];
state[14] = state1[6];
state[3] = state1[15];
state[7] = state1[3];
state[11] = state1[7];
state[15] = state1[11];

}
void MixColumns(unsigned char * state){
	//using the look-up table and equations from slide 12

	unsigned int a_0, a_1, a_2, a_3;
	for(int i = 0; i < 4; i++)
	{
		a_0 = state[4*i];
	    a_1 = state[4*i + 1];
		a_2 = state[4*i + 2];
		a_3 = state[4*i + 3];

		state[4*i] = gf_mul[a_0][0] ^ gf_mul[a_1][1] ^ (a_2) ^ (a_3);
		state[(4*i)+1] = (a_0) ^ gf_mul[a_1][0] ^ gf_mul[a_2][1] ^ (a_3);
		state[(4*i)+2] = (a_0) ^ (a_1) ^ gf_mul[a_2][0] ^ gf_mul[a_3][1];
		state[(4*i)+3] = gf_mul[a_0][1] ^ (a_1) ^ (a_2) ^ gf_mul[a_3][0];
	}

}
void KeyExpansion(unsigned char * key, unsigned int * w, int Nk){
//produces the round keys
	int i = 0;
	while (i < Nk){
		//bitshifting to combine in to 32 bits
		w[i] = (key[4*i] << 24) | (key[4*i+1] << 16) | (key[4*i+2] << 8) | key[4*i+3];
		i++;
	}

	i = Nk;

	unsigned int temp;
	while (i < 44){
		temp = w[i-1];

		if (i % Nk == 0)
			temp = SubWord(RotWord(temp)) ^ Rcon[i/Nk];

		w[i] = w[i-Nk] ^ temp;
		i++;
	}

}
unsigned int RotWord(unsigned int w){
	return (w << 8 | w >> 24);
}
unsigned int SubWord(unsigned int word){

	//obtain each key from the word
	unsigned char keys[4];
	keys[0] = word & 0xFF;
	keys[1]= (word >> 8) & 0xFF;
	keys[2] = (word >> 16) & 0xFF;
	keys[3] = word >> 24;

	unsigned int result = 0;
	for(int i = 0; i < 4; i++)
	{
		//word is 32 bits -- below modified from SubBytes
		unsigned int result1 = aes_sbox[((keys[i]) >> 4)*16 + (keys[i] & 0x0F)];
		//combine all results into one int, beginning from right
		result = result1 << 8*i | result;
	}
	return result;
}
void AddRoundKey(unsigned char * state, unsigned int * key, int round){

	//key[] size 4
	for(int i = 0; i < 4; i++)
	{
		state[4*i] = state[4*i] ^ (key[i] >> 24);
		state[4*i + 1] = state[4*i + 1] ^ (key[i] >> 16);
	    state[4*i + 2] = state[4*i + 2] ^ (key[i] >> 8);
		state[4*i + 3] = state[4*i + 3] ^ (key[i]);
	}

}

/** decrypt
 *  Perform AES decryption in hardware.
 *
 *  Input:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *              key - Pointer to 4x 32-bit int array that contains the input key
 *  Output: msg_dec - Pointer to 4x 32-bit int array that contains the decrypted message
 */

 //WEEK 2
void decrypt(unsigned int * msg_enc, unsigned int * msg_dec, unsigned int * key)
{
	//fill partial regfile -- key and enc
	AES_PTR[0] = key[0];
	AES_PTR[1] = key[1];
	AES_PTR[2] = key[2];
	AES_PTR[3] = key[3];
	AES_PTR[4] = msg_enc[0];
	AES_PTR[5] = msg_enc[1];
	AES_PTR[6] = msg_enc[2];
	AES_PTR[7] = msg_enc[3];

	//tell hardware that we're ready
	AES_PTR[14] = 1;
	AES_PTR[14] = 0;

	//wait until hardware is done
	while (AES_PTR[15] == 0) {}

	//write dec from regfile
	msg_dec[0] = AES_PTR[8];
	msg_dec[1] = AES_PTR[9];
	msg_dec[2] = AES_PTR[10];
	msg_dec[3] = AES_PTR[11];
}

/** main
 *  Allows the user to enter the message, key, and select execution mode
 *
 */
int main()
{
	// Input Message and Key as 32x 8-bit ASCII Characters ([33] is for NULL terminator)
	unsigned char msg_ascii[33];
	unsigned char key_ascii[33];
	// Key, Encrypted Message, and Decrypted Message in 4x 32-bit Format to facilitate Read/Write to Hardware
	unsigned int key[4];
	unsigned int msg_enc[4];
	unsigned int msg_dec[4];

	printf("Select execution mode: 0 for testing, 1 for benchmarking:  ");
	scanf("%d", &run_mode);

	//keep zeros
	AES_PTR[8] = 0;
	AES_PTR[9] = 0;
	AES_PTR[10] = 0;
	AES_PTR[11] = 0;

	if (run_mode == 0) {
		// Continuously Perform Encryption and Decryption
		while (1) {
			int i = 0;
			printf("\nEnter Message:\n");
			scanf("%s", msg_ascii);
			printf("\n");
			printf("\nEnter Key:\n");
			scanf("%s", key_ascii);
			printf("\n");
			encrypt(msg_ascii, key_ascii, msg_enc, key);

			printf("\nEncrypted message is: \n");

			for(i = 0; i < 4; i++){
				printf("%08x", msg_enc[i]);
			}
			printf("\n");

			decrypt(msg_enc, msg_dec, key);
			printf("\nDecrypted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_dec[i]);
			}
			printf("\n");
		}
	}
	else {
		// Run the Benchmark
		int i = 0;
		int size_KB = 2;
		// Choose a random Plaintext and Key
		for (i = 0; i < 32; i++) {
			msg_ascii[i] = 'a';
			key_ascii[i] = 'b';
		}
		// Run Encryption
		clock_t begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			encrypt(msg_ascii, key_ascii, msg_enc, key);
		clock_t end = clock();
		double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		double speed = size_KB / time_spent;
		printf("Software Encryption Speed: %f KB/s \n", speed);

		// Run Decryption
		begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			decrypt(msg_enc, msg_dec, key);
		end = clock();
		time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		speed = size_KB / time_spent;
		printf("Hardware Decryption Speed: %f KB/s \n", speed);
	}
	return 0;
}
