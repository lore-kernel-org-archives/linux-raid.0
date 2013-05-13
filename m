From: Chris Finley <debenbain@gmail.com>
Subject: Raid5 double failure recovery
Date: Sun, 12 May 2013 17:01:57 -0700
Message-ID: <CAGXrYFTxx_2Avk5cCm9omm2hE_O12uF0qdFSttrFVfEpz64Yag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I could really use some experienced guidance before proceeding. This 4
disk raid 5 (md0) holds media for MythTV and represents a great deal
of work ripping my own DVDs. The system is on another drive, so most
of the raid content is large-file and contiguous.

System:  /dev/sda
Raid:   /dev/sd[cdef]1

From what I can tell, about a week ago, sde dropped out of the array.
Ironically, Disk Utility says this drive is "healthy". With new disk
in hand, I went to repair it a few days ago and found sdd dropped from
the array as well.  I ran bad-blocks -v on sdd which found more bad
sectors. I have NOT tried to force assembly or recreation of the
array.
The mdadm -E results are at
http://pastebin.com/7ng1bmyZ.

The event counts:
sdc : 42810
sdd : 42785
sde : 35760
sdf : 42810

I was thinking of doing a force assembly and then adding the new drive
as a fourth.
mdadm --assemble --force /dev/sd[cdf]1
Since these three are the closest event counts.

Questions:
1. Would including sde (with the week-old data) in the forced assembly
provide any additional information for the re-build? Is it better to
start with a failed 3 drive array using the drive last in the array?

2. I read in the archives about ddrescue. Should I use it to copy
some/all of the drives to new drives first? I am concerned the failed
drive would not survive a consistency check and raid rebuild. Which
drives? Even sdc has a non-zero read error rate, but is still
considered "healthy".

3. How likely is the smartmontools firmware-bug the cause of these
errors? These are all Samsung HD204UI drives. The raid has been
running for about 2 years; although, I just recently updated to Ubuntu
12.04.
Smartmontools was installed yesterday to produce the smart_all output:
http://pastebin.com/bP1EruEK

Much thanks for your expertise and time,

Chris
