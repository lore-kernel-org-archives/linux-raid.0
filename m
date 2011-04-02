From: Marcus <nexuslite@gmail.com>
Subject: Raid 5 Array
Date: Sat, 2 Apr 2011 11:51:58 -0700
Message-ID: <BANLkTim8620MUckc+EVCWo9FCTs=65_p8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a raid array this is the second time an upgrade seems to have
corrupted the array.

I get the following message from dmesg when trying to mount the array
[  372.822199] RAID5 conf printout:
[  372.822202]  --- rd:3 wd:3
[  372.822208]  disk 0, o:1, dev:md0
[  372.822212]  disk 1, o:1, dev:sdb1
[  372.822216]  disk 2, o:1, dev:sdc1
[  372.822305] md2: detected capacity change from 0 to 1000210300928
[  372.823206]  md2: p1
[  410.783871] EXT4-fs (md2): Couldn't mount because of unsupported
optional features (3d1fc20)
[  412.401534] EXT4-fs (md2): Couldn't mount because of unsupported
optional features (3d1fc20)

I originally had a raid0 md0 with two 160GB drives, a raid0 md1 with
250GB and md0, a raid 5 with a 1.0TB, 500GB, and md1

I swapped out md1 with a new 1TB drive which worked. then i dropped
the 500GB and combined it with the 250GB drive to make a 750GB drive

The error seems to come when you reintroduce drives that were
previously in a raid array into a new raid array. This is the second
time I have ended up with the same problem.

Any suggestions on how to recover from this or is my only option to
reformat everything and start again?
