From: Loris <loris@sat.epfl.ch>
Subject: raid5 algorithm
Date: Thu, 25 Sep 2003 01:44:28 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <09572E94-EEE9-11D7-AD04-000502DEFA47@sat.epfl.ch>
Mime-Version: 1.0 (Apple Message framework v552)
Content-Type: multipart/alternative; boundary=Apple-Mail-4-240522342
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Apple-Mail-4-240522342
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed

Hello,

I have some problems and I need to be sure of what to do?

I'm not sure if I have understood everything about chunks, superblocks 
and other disk structure of raid level 5.
I will try to write what I think to understand and I'd like to be 
corrected if I made any error in following, please.

Lets take an exemple:
If the information I have is:
0100 1011 0101 0100 0101 0100 1011 1011 0111 0101 0111 0101
If I use 1 byte chunks, my chunks will be:
0100 1011 0101 0100 0101 0100 1011 1011 0111 0101 0111 0101
\-------/ \-------/ \-------/ \-------/ \-------/ \-------/
so:
chunk0: 0100 1011
chunk1: 0101 0100
chunk2: 0101 0100
chunk3: 1011 1011
chunk4: 0111 0101
chunk5: 0111 0101
A question now: is the chunk splited on the different disks or not?
I mean is it like that:
|     disk0     |     disk1     |     disk2     |
+---------------+---------------+---------------+
|    chunk0     |    chunk1     | chunk0^chunk1 |
|    chunk2     | chunk2^chunk3 |    chunk3     |
| chunk4^chunk5 |    chunk4     |    chunk5     |
|    chunk6     |    chunk7     | chunk6^chunk7 |
|    chunk8     | chunk8^chunk9 |    chunk9     |
etc. with ^ the bitwise xor (^=circumflexe (in case on mistransmission))

Are the chunk splited in (n-1) parts distributed on the (n-1) disks?

Are "parity chunks" first on disk2 then on disk1 next on disk0 next on 
disk2 next on disk1 next on disk0... or order is another?

In this case, I understood everything right until now, the disks should 
like that:
|   disk0   |   disk1   |   disk2   |
+-----------+-----------+-----------+
| 0100 1011 | 0101 0100 | 0001 1111 |
| 0101 0100 | 1110 1111 | 1011 1011 |
| 0000 0000 | 0111 0101 | 0111 0101 |
without XORed chunk you should read information "horizontally"?
|   disk0   |   disk1   |   disk2   |
+-----------+-----------+-----------+
| 0100 1011 | 0101 0100 |           |
| 0101 0100 |           | 1011 1011 |
|           | 0111 0101 | 0111 0101 |

Here come my real problem: I must move the disks in another computer 
after processor burning. I'm not sure on disk order (cause of 
master,slave,cable select). But if what I said before is correct, even 
if I now move the disks let's say:
|   disk2   |   disk1   |   disk0   |
+-----------+-----------+-----------+
| 0001 1111 | 0101 0100 | 0100 1011 |
| 1011 1011 | 1110 1111 | 0101 0100 |
| 0111 0101 | 0111 0101 | 0000 0000 |

for resyncing you only do the same because xor is commutative and so:
disk0 = disk2^disk1
|   disk2   |   disk1   |   disk0   |
+-----------+-----------+-----------+
| 0001 1111 | 0101 0100 |           |
| 1011 1011 | 1110 1111 |           |
| 0111 0101 | 0111 0101 |           |
be resynced as:
|   disk2   |   disk1   |   disk0   |
+-----------+-----------+-----------+
| 0001 1111 | 0101 0100 | 0100 1011 |
| 1011 1011 | 1110 1111 | 0101 0100 |
| 0111 0101 | 0111 0101 | 0000 0000 |

If everything is correct until now this should be non destructive? (is 
that not the goal of raid5?)

I think that is all about real data part of the disk?

Now other questions about structure of the disk:
(I tried to read sources of the kernel but I didn't understand 
everything...)
what is inside the raid5 partition?
What I think to understand is:
+-------partition------------------------------------------------
| offset 0     +-------usable part-------------------------------
| offset 1     | informations accessible after /dev/mdX mounting
| offset 2     | a little scrambled...
| ...          |
| offset sb-1  +---end of usable part----------------------------
| offset sb    +--suberblock-------------------------------------
| offset sb+1  |
| offset sb+2  |
| ...          |
| offset end   +---end of sb-------------------------------------
+-----end of partition-------------------------------------------
Is there other parts?
Does the "usable part" begins at the beginning of the partition?
Where begins the superblock? Is that the end of the "usable part"? (In 
case I need to "manually" reconstruct the informations)
Is the end of the superblock the end of the partition?
Does the resync only resync the usable part?

If:
-disks are physically good (I think) and
-resyncing bad ordered disks don't corrupts data and
-the resync only resync the usable part and
-superblock were crush (by bad advises on moving disks found on web)
I can try to mount read-only without corrupting data?

This is the end, my friend...

Thanks for helping,

Loris
--Apple-Mail-4-240522342
Content-Transfer-Encoding: 7bit
Content-Type: text/enriched;
	charset=US-ASCII

<fontfamily><param>Courier</param>Hello,


I have some problems and I need to be sure of what to do?


I'm not sure if I have understood everything about chunks, superblocks
and other disk structure of raid level 5.

I will try to write what I think to understand and I'd like to be
corrected if I made any error in following, please.


Lets take an exemple:

If the information I have is:

0100 1011 0101 0100 0101 0100 1011 1011 0111 0101 0111 0101

If I use 1 byte chunks, my chunks will be:

0100 1011 0101 0100 0101 0100 1011 1011 0111 0101 0111 0101

\-------/ \-------/ \-------/ \-------/ \-------/ \-------/

so:

chunk0: 0100 1011

chunk1: 0101 0100

chunk2: 0101 0100

chunk3: 1011 1011

chunk4: 0111 0101

chunk5: 0111 0101

A question now: is the chunk splited on the different disks or not?

I mean is it like that:

|     disk0     |     disk1     |     disk2     |

+---------------+---------------+---------------+

|    chunk0     |    chunk1     | chunk0^chunk1 |

|    chunk2     | chunk2^chunk3 |    chunk3     |

| chunk4^chunk5 |    chunk4     |    chunk5     |

|    chunk6     |    chunk7     | chunk6^chunk7 |

|    chunk8     | chunk8^chunk9 |    chunk9     |

etc. with ^ the bitwise xor (^=circumflexe (in case on
mistransmission))


Are the chunk splited in (n-1) parts distributed on the (n-1) disks?


Are "parity chunks" first on disk2 then on disk1 next on disk0 next on
disk2 next on disk1 next on disk0... or order is another?


In this case, I understood everything right until now, the disks
should like that:

|   disk0   |   disk1   |   disk2   |

+-----------+-----------+-----------+

| 0100 1011 | 0101 0100 | 0001 1111 |

| 0101 0100 | 1110 1111 | 1011 1011 |

| 0000 0000 | 0111 0101 | 0111 0101 |

without XORed chunk you should read information "horizontally"?

|   disk0   |   disk1   |   disk2   |

+-----------+-----------+-----------+

| 0100 1011 | 0101 0100 |           |

| 0101 0100 |           | 1011 1011 |

|           | 0111 0101 | 0111 0101 |


Here come my real problem: I must move the disks in another computer
after processor burning. I'm not sure on disk order (cause of
master,slave,cable select). But if what I said before is correct, even
if I now move the disks let's say:

|   disk2   |   disk1   |   disk0   |

+-----------+-----------+-----------+

| 0001 1111 | 0101 0100 | 0100 1011 |

| 1011 1011 | 1110 1111 | 0101 0100 |

| 0111 0101 | 0111 0101 | 0000 0000 |


for resyncing you only do the same because xor is commutative and so:

disk0 = disk2^disk1

|   disk2   |   disk1   |   disk0   |

+-----------+-----------+-----------+

| 0001 1111 | 0101 0100 |           |

| 1011 1011 | 1110 1111 |           |

| 0111 0101 | 0111 0101 |           |

be resynced as:

|   disk2   |   disk1   |   disk0   |

+-----------+-----------+-----------+

| 0001 1111 | 0101 0100 | 0100 1011 |

| 1011 1011 | 1110 1111 | 0101 0100 |

| 0111 0101 | 0111 0101 | 0000 0000 |


If everything is correct until now this should be non destructive? (is
that not the goal of raid5?)


I think that is all about real data part of the disk?


Now other questions about structure of the disk:

(I tried to read sources of the kernel but I didn't understand
everything...)

what is inside the raid5 partition?

What I think to understand is:

+-------partition------------------------------------------------

| offset 0     +-------usable part-------------------------------

| offset 1     | informations accessible after /dev/mdX mounting

| offset 2     | a little scrambled...

| ...          |

| offset sb-1  +---end of usable part----------------------------

| offset sb    +--suberblock-------------------------------------

| offset sb+1  |

| offset sb+2  |

| ...          |

| offset end   +---end of sb-------------------------------------

+-----end of partition-------------------------------------------

Is there other parts?

Does the "usable part" begins at the beginning of the partition?

Where begins the superblock? Is that the end of the "usable part"? (In
case I need to "manually" reconstruct the informations)

Is the end of the superblock the end of the partition?

Does the resync only resync the usable part?


If:

-disks are physically good (I think) and

-resyncing bad ordered disks don't corrupts data and

-the resync only resync the usable part and

-superblock were crush (by bad advises on moving disks found on web)

I can try to mount read-only without corrupting data?


This is the end, my friend...


Thanks for helping,


Loris</fontfamily>
--Apple-Mail-4-240522342--

