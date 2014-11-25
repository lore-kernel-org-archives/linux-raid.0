From: Jonathan Molyneux <jonathan@infinitedepth.com.au>
Subject: raid10 - won't rebuild - assigns all added disks as spares
Date: Tue, 25 Nov 2014 12:49:12 +1100
Message-ID: <5473E018.3020507@infinitedepth.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Everyone,

Have a strange situation that hasn't happened before.
Running Debian 7.7 with kernel version 3.2.63-2+deb7u1.
Have a raid10 that runs the server (boot's off a raid1) that after 
replacing a failed disk, just won't rebuild.

This is what it looks like without the disk (failed & removed):
md1 : active raid10 sda2[6] sdc2[4] sdb2[1]
       1952987136 blocks super 1.2 512K chunks 2 far-copies [4/3] [UUU_]
       bitmap: 8/15 pages [32KB], 65536KB chunk

Then when the disk is added:
md1 : active raid10 sdd2[5](S) sda2[6] sdc2[4] sdb2[1]
       1952987136 blocks super 1.2 512K chunks 2 far-copies [4/3] [UUU_]
       bitmap: 8/15 pages [32KB], 65536KB chunk

Nothing unusual is being spat out in dmesg.
When removing the disk:
[313434.073997] md: unbind<sdd2>
[313434.138307] md: export_rdev(sdd2)
When adding the disk:
[313468.056484] md: bind<sdd2>

This is a strange one that I haven't had before.
Any thoughts on how to kick the rebuild off without needing a reboot ?

PS

Rebooting the server is an option, just would require some scheduling.
