From: Wol's lists <antlists@youngman.org.uk>
Subject: [OT] C programming problem
Date: Wed, 7 Feb 2018 19:46:13 +0000
Message-ID: <2a2e28ad-20bd-d369-d65f-19d79f1871fb@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

It is for raid, honest :-)

My C is so rusty it's jammed solid :-) but I'm trying to prototype a 
simple algorithm for "de-clustering" a raid-60/61 array.

Googling for my error -

main.c:20:5: warning: incompatible implicit declaration of built-in 
function ‘memset’ [enabled by default]
      memset( &array, 0, blocks * sizeof(int) );

says "you need to include stdlib.h" - but I have!

(I'm getting the same error on the malloc ...)

#include <stdio.h>
#include <stdlib.h>

void main()
{
     int disks, logdisks, mirrors, prime;

     printf( "%s", "Enter the number of disks ");
     scanf( "%d", &disks);
     printf( "%s", "Enter the number of logical disks ");
     scanf( "%d", &logdisks);
     printf( "%s", "Enter the number of mirrors ");
     scanf( "%d", &mirrors);
     printf( "%s", "Enter the prime ");
     scanf( "%d", &prime);

     int blocks, *array;

     blocks = logdisks * mirrors * disks;
     array = (int *) malloc( sizeof(int) * blocks );
     memset( &array, 0, blocks * sizeof(int) );

     int i;

     for (i=0; i < blocks; i++) {
         array[i] = (i * prime) % blocks;
     }

     for (i=0; i < blocks; i++) {
         if ( (i % disks) == 0)
             printf( "\n");
         printf( "%4d", array[i]);
     }
}
