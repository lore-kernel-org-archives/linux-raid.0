From: "Rolf Schatzmann" <rolf@mactherapy.com>
Subject: Adding more disks to existing Raid5 Array
Date: Sat, 15 May 2004 01:03:37 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <030f01c439d5$69099730$bc6a9aca@scorp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Hello,

I have found conflicting info on the internet and in the archives and
would like to clarify something.

I have a software raid 5 array created using raidtools2 on a 2.4.2x
kernel on  debain stable, currently the array consists of 3 active 120GB
IDE drives and one spare drive, so my raidtab file appears like this:

raiddev /dev/md0
        raid-level      5
        persistent-superblock   1
        chunk-size      256
        nr-raid-disks   3
        nr-spare-disks  1
        device  /dev/hde1
                raid-disk       0
        device  /dev/hdg1
                raid-disk       1
        device  /dev/hdi1
                raid-disk       2
        device  /dev/hdk1
                spare-disk      0

I need to increase the size of the array, can I just change hdk1 to
raid-disk  3  and then run 
Raidhotadd /dev/hdk1  /dev/md0

On one web site I found it says that this works as it re-builds the data
across all available drives stripping the data and parity across the
entire available array in the same way that it would if I was re-adding
a drive that had been marked as failed and kicked out of the array. This
would see logical to me as surely all the required data & parity must be
there to allow it to rebuild the array when you do add a failed drive
back in normally.

But elsewhere in this lists archives I found a post that said that at
creation time the raid 5 array is fixed to a set size and number of
disks and that trying to add to this will result in the destruction of
the array.

What is true?  Is there a tool to add drives to the array, or do I have
to copy everything off, make a new array and then copy it all back?

Help appreciated as always.

Rolf


