From: Michael Welsh Duggan <mwd@cert.org>
Subject: Re: RAID reconstruction problems
Date: Tue, 02 Sep 2003 21:51:39 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <tntn0dmwses.fsf@spenser.yellow.cert.org>
References: <87wucrnb63.fsf@cs.cmu.edu>
Reply-To: mwd@sei.cmu.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry about putting the wrong email address on my initial email.  

In reply to Donghui Wen, Yes, it was partitioned correctly.

In reply to Bernd Schubert, I have installed mdadm, and am looking
around for some pointers.  I am unsure what is going on still.  mdadm
reports the follownig for /dev/md1:

/dev/md1:
        Version : 00.90.00
  Creation Time : Sun Mar 16 21:42:44 2003
     Raid Level : raid1
     Array Size : 6144704 (5.86 GiB 6.29 GB)
    Device Size : 6144704 (5.86 GiB 6.29 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Mon Sep  1 19:48:11 2003
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0       3       65        0      active sync       /dev/ide/host0/bus0/target1/lun0/part1
       1       0        0        0      sync
       2      22        1        2      active       /dev/ide/host0/bus1/target0/lun0/part1
           UUID : 0e953226:03c91d46:cd00d52f:83a1334e
         Events : 0.413


/proc/mdstat reports the following:

md1 : active raid1 ide/host0/bus1/target0/lun0/part1[2]
ide/host0/bus0/target1/lun0/part1[0]
      6144704 blocks [2/2] [U_]

I'll play around with it some more, but it anyone recognizes these
symptoms, please reply.

-- 
Michael Welsh Duggan
(mwd@cert.org)
