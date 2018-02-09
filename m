From: Wol's lists <antlists@youngman.org.uk>
Subject: Re: RFC - de-clustered raid 60 or 61 algorithm
Date: Fri, 9 Feb 2018 23:12:37 +0000
Message-ID: <a671c59c-fd2b-8443-3d02-d4c944ab12e9@youngman.org.uk>
References: <9f9e737c-d6d1-5cce-8190-14d970320265@youngman.org.uk>
 <876078maui.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <876078maui.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/02/18 03:14, NeilBrown wrote:
> I think that ends up being much the same result as a current raid10
> where the number of copies doesn't divide the number of devices.
> Reconstruction reads come from 2 different devices, and half the reads
> that would go to them now go elsewhere.

Thing is, it's no worse ... :-)
> 
> I think that if you take your solution and a selection of different
> "prime" number and rotate through the primes from stripe to stripe, you
> can expect a more even distribution of load.
> 
Tried it. Doesn't seem to work :-(

> You hint at this below when you suggest that adding the "*prime" doesn't
> add much.  I think it adds a lot more when you start rotating the primes
> across the stripes.

Dunno how well this will work, but my big problem when I've been playing 
with this is pathological outcomes. It seems to work and then one disk 
is pathological. Typically it stores the two mirrors on the same disk - 
oops!

My new test program has three different algorithms. Algorithms 1 & 2 
seem near enough identical. And as has been commented, they offer 
nothing over the raid-10 algorithm. Thing is, the maths is pretty easy 
to prove the behaviour is not pathological.

Algorithm 3 does exactly what we want BUT. If the number of drives is 
not greater than two logical stripes, then it's pretty much guaranteed 
to be pathological. However, provided that it's greater than that, I 
think we can prove that it's not.

The other thing to watch out for is if our prime(s) are a factor of the 
number of disks, then the algorithm is seriously pathological, but 
seeing as we should generate the primes on the fly, we can easily handle 
that.

So I think we have to have a slightly complicated algorithm that says 
"if the number of drives is 2 times logical drives times mirrors, or 
less, then use the raid-10 algorithm and accept the poor mirror 
distribution, otherwise use algorithm 3".

So it won't be a particularly good algorithm for just a few (relatively 
speaking) physical drives, but if there are a lot of drives it'll work well.

I've been testing the algorithm with 4 logical drives by two mirrors, 
and using 12, 17 or 18 physical drives. Unfortunately it seems like a 
prime number of drives is best, but of course you won't get a big drive 
cabinet designed to take that number of drives :-(

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void main()
{
     int disks, logdisks, mirrors, prime, algorithm;

     printf( "%s", "Enter the number of disks ");
     scanf( "%d", &disks);
     printf( "%s", "Enter the number of logical disks ");
     scanf( "%d", &logdisks);
     printf( "%s", "Enter the number of mirrors ");
     scanf( "%d", &mirrors);
     printf( "%s", "Enter the prime ");
     scanf( "%d", &prime);
     printf( "%s", "Enter the algorithm ");
     scanf( "%d", &algorithm);

     int blocks, *array;

     blocks = logdisks * mirrors * disks;
     array = (int *) malloc( sizeof(int) * blocks );
     memset( array, '\0', sizeof(int) * blocks );

     int i;

     int primes[] = { 5,11,19,23,31,37,41,43,47 };
     switch (algorithm) {
         case 1:
         /* initial simple version */
         for (i=0; i < blocks; i++) {
             array[i] = (i * prime) % blocks;
         }
         break;

         case 2:
         /* simple version 2 */
         for (i=0; i < blocks; i++) {
             int posn;
             posn = (i * prime) % blocks;
             array[posn] = i;
         }
         break;

         case 3:
         /* second attempt rotate a stripe */
         for (i=0; i < blocks; i++) {
             int stripe, column;
             stripe = i / disks;
             column = ( stripe + i * primes[stripe] ) % disks ;
             array[ stripe * disks + column ] = i;
         }
         break;

     }

     int logstripe, logdisk;

     for (i=0; i < blocks; i++) {
         if ( (i % disks) == 0) {
             printf( "\n");
         }

         // printf( "%4d", array[i]);

         logstripe = array[i] / (mirrors * logdisks);
         logdisk = array[i] % logdisks;
         printf( "  %02d%c", logstripe, (char) logdisk+65);

     }
     printf( "\n");
}
