From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: raidreconf won't resize a RAID 5 array. Can it be done with mkraid -f ?
Date: Mon, 17 May 2004 16:28:42 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200405172028.i4HKSkB08658@www.watkins-home.com>
References: <000901c43c20$df38fb10$0201a8c0@windows>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000901c43c20$df38fb10$0201a8c0@windows>
To: 'TJ Harrell' <systemloc@earthlink.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I don't understand the size of your array!
If you have 3 disks about 200G each, your RAID5 array should be about 400G.
But your array is 1171815940 blocks!  That's 1171G, about 3 times larger
than it should be.

Just to verify the size of the disks and the array, do these commands:
fdisk -l /dev/hdg
fdisk -l /dev/hdc
fdisk -l /dev/hdk
fdisk -l /dev/hdi
fdisk -l /dev/hda
cat /proc/mdstat
mdadm -D /dev/md0
mdadm -D /dev/md1

Guy


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of TJ Harrell
Sent: Monday, May 17, 2004 11:09 AM
To: linux-raid@vger.kernel.org
Subject: raidreconf won't resize a RAID 5 array. Can it be done with mkraid
-f ?

I have a raid 5 array consisting of 3 disks. The smallest disk is 195191168
blocks. The array only uses 172551296 blocks from each device. Numbers ar
from output of mdadm. I would like to grow the array to the largest
posssible size. I tried doing a raidreconf using identical settings in
raidtab.old and raidtab.new, and it said the size would remain unchanged
when it asked for confirmation. Is there a way to tweak it to do what I
want, or could I just mkraid -f the existing array? I'm afraid if I just do
a mkraid -f it will fubar the old array by laying out parity info
differently or something since the size of the array will be different.

Raidtab:
raiddev /dev/md0
   raid-level      linear
   nr-raid-disks      3
   persistent-superblock   1
   chunk-size      128

device      /dev/hdk1
raid-disk   0
device      /dev/hdi1
raid-disk   1
device      /dev/hda3
raid-disk   2

raiddev /dev/md1
   raid-level      5
   nr-raid-disks      3
   persistent-superblock   1
   chunk-size      64

device      /dev/hdg1
raid-disk   0
device      /dev/md0
failed-disk 1
device      /dev/hdc1
raid-disk   2


Output of "raidreconf -o /etc/raidtab -n /etc/raidtab.new -m /dev/md1"

Working with device /dev/md1
Parsing /etc/raidtab
Parsing /etc/raidtab.new
Size of old array: 1171815940 blocks,  Size of new array: 1171815940 blocks
Old raid-disk 0 has 3052474 chunks, 195358336 blocks
Old raid-disk 1 has 3049861 chunks, 195191104 blocks
Old raid-disk 2 has 3052474 chunks, 195358336 blocks
New raid-disk 0 has 3052474 chunks, 195358336 blocks
New raid-disk 1 has 3049861 chunks, 195191104 blocks
New raid-disk 2 has 3052474 chunks, 195358336 blocks
Using 64 Kbyte blocks to move from 64 Kbyte chunks to 64 Kbyte chunks.
Detected 418432 KB of physical memory in system
A maximum of 1394 outstanding requests is allowed
---------------------------------------------------
I will convert your old device /dev/md1 of 6102335 blocks
to a new device /dev/md1 of same size
using a block-size of 64 KB
Is this what you want? (yes/no): no


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


