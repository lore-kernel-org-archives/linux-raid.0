From: Wol's lists <antlists@youngman.org.uk>
Subject: RFC - de-clustered raid 60 or 61 algorithm
Date: Thu, 8 Feb 2018 00:46:18 +0000
Message-ID: <9f9e737c-d6d1-5cce-8190-14d970320265@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
Cc: NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

After the de-clustered thread, Neil said it would probably only take a 
small amount of coding to do something like that. It was also discussed 
about spreading the load over disks on a reconstruction if there were a 
lot of disks in an array. I've been trying to get my head round a simple 
algorithm to smear data over the disks along the lines of raid-10.

Basically, the idea is to define a logical stripe which is a multiple of 
both the number of physical disks, and of the number of logical disks. 
Within this logical stripe the blocks are shuffled using prime numbers 
to make sure we don't get a pathological shuffle.

At present, I've defined the logical stripe to be simply the product of 
the number of logical disks times the number of mirrors times the number 
of physical disks. We could shrink this by removing common factors, but 
we don't need to.

Given a logical block within this stripe, its physical position is 
calculated by the simple equation "logical block * prime mod logical 
stripe size". So long as the "prime" does not share any factors with the 
logical stripe size, then (with one exception) you're not going to get 
hash collisions, and you're not going to get more than one block per 
stripe stored on each drive. The exception, of course, is if physical 
disks is not greater than logical disks. Having the two identical is 
especially dangerous as users will not expect the pathological behaviour 
they will get - multiple blocks per stripe stored on the same disk. 
mdadm will need to detect and reject this layout. I think the best 
behaviour will be found where logical disks, mirrors, and physical disks 
don't share any prime factors.

I've been playing with a mirror setup, and if we have two mirrors, we 
can rebuild any failed disk by coping from two other drives. I think 
also (I haven't looked at it) that you could do a fast rebuild without 
impacting other users of the system too much provided you don't swamp 
i/o bandwidth, as half of the requests for data on the three drives 
being used for rebuilding could actually be satisfied from other drives.

Rebuilding a striped raid such as a raid-60 also looks like it would 
spread the load.

The one thing that bothers me is that I don't know whether the "* prime 
mod" logic actually adds very much - whether we can just stripe stuff 
across like we do with raid-10. Where it will score is in a storage 
assembly that is a cluster of a cluster of disks. Say you have a 
controller with ten disks, and ten controllers in a rack, a suitable 
choice of prime and logical stripe could ensure the rack would survive 
losing a controller. And given that dealing with massive arrays is what 
this algorithm is about, that seems worthwhile.

Anyways, here's my simple code that demonstrates the algorithm and 
prints out how the blocks will be laid out. Is it a good idea? I'd like 
to think so ...

Cheers,
Wol

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
     memset( array, '\0', sizeof(int) * blocks );

     int i;

     for (i=0; i < blocks; i++) {
         array[i] = (i * prime) % blocks;
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
