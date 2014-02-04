From: Wilson Jonathan <piercing_male@hotmail.com>
Subject: mdadm, raid 6 best options if any?
Date: Tue, 4 Feb 2014 22:26:33 +0000
Message-ID: <BLU0-SMTP462E6C9C5DF0FE45B7116D798AA0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I am currently creating a raid 6 array, normally I would just let the
defaults do the job and be done with it but I'm having to do a limited
create and then add disks.

From what I can recall a raid six can have differing layouts, the
"checksum" data can be interspersed across the disks or put on 2
"parity" disks and the data contained on the other set of drives.

My first question is, does this still hold true and if so do I need to
do anything to get the parity spread over the disks, is there a layout
recommended or is the "if not specified it will do this" route possible.

My second question is, due to my situation I am going to have to create
a 4 drive raid 6 array with just 2 disks initially. The reason for this
is a lack of sata ports/disks (I have the 4 drives, but... the end
partition of 2 of the drives is needed to keep a raid 6 6 disk set up
running, I will drop 2 drives/partitions from the 6, extend the lower
portion of the 2 drives (new raid 6), then copy from the degraded 6
drive to the new degraded 4 drive, then delete partitions/disks from the
6 drive and extend the last 2 drives, of the 4 drives, and add them
in.... 

Now my thinking is that all I need to do is, fail/remove "drive
b/partition6 from the six drive, then drive c/partition6... I now have a
degraded raid 6.

Then create MD51 /dev/sdb5 /dev/sdc5 missing missing.
Copy data to md51 (after file system creation)
add MD51 /dev/sdd5 /dev/sde5
and jobs a good un.

My issue, I may be over thinking this, is that the b5/c5/missing/missing
might force the d5/e5 to be parity only, when I would like the parity to
be across all drives... a nice clean stripe! Or perhaps it makes no
difference to performance/disk life/summat else.

Jon 


