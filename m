From: Christian Kivalo <valo@valo.at>
Subject: strange nr. of devices in array
Date: Fri, 20 Feb 2004 21:48:11 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040220214811.0000192c@valo.lan.valo.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi everybody!

i found out, that the superblock of my raid5 array says it's built out
of 7 disks, but i created it with only 6 disk. the mdadm call used to
create the array was:

mdadm --create /dev/md6 -c 64 -l raid5 -p ls -n 6 --spare-disks=0 \
/dev/hde1 /dev/hdg1 /dev/hdi1 /dev/hdk1 /dev/hdm1 /dev/hdo1

i grep'ed through my .bash_history and that was the only line showing
mdadm --create.

i'm using mdadm version 0.7.2, i think that is pretty old. i will
upgrade to a more recent version and recreate the array.

still i would like to know if i encountered a bug or if thats some other
problem. this mdadm version is the one from debian woody (stable).

output of mdadm --detail /dev/md6

/dev/md6:
        Version : 00.90.00
  Creation Time : Mon Feb  9 00:55:34 2004
     Raid Level : raid5
     Array Size : 781240320 (745.04 GiB 799.99 GB)
    Device Size : 156248064 (149.00 GiB 159.99 GB)
     Raid Disks : 6
    Total Disks : 7
Preferred Minor : 6
    Persistance : Superblock is persistant

    Update Time : Tue Feb 17 20:53:02 2004
          State : dirty, no-errors
  Active Drives : 6
 Working Drives : 6
  Failed Drives : 1
   Spare Drives : 0

         Layout : left-symmetric
     Chunk Size : 64K

    Number   Major   Minor   RaidDisk   State
       0      33        1        0      active sync   /dev/hde1
       1      34        1        1      active sync   /dev/hdg1
       2      56        1        2      active sync   /dev/hdi1
       3      57        1        3      active sync   /dev/hdk1
       4      88        1        4      active sync   /dev/hdm1
       5      89        1        5      active sync   /dev/hdo1
           UUID : 7b22b692:7564eab7:02145e27:9bfc02a2

it seems there are no errors but i don't want to encounter a drive
failure and beeing stuck with a 2 drive failure (i know there are ways
to get a 2 drive failure array back up and working)

thanks in advance
christian
