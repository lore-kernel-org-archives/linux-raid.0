From: Christopher White <linux@pulseforce.com>
Subject: mdadm does not create partition devices whatsoever, "partitionable"
 functionality broken
Date: Fri, 13 May 2011 17:13:07 +0200
Message-ID: <4DCD4A83.8060202@pulseforce.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings.

I have spent TEN hours trying everything other than regressing to a 
REALLY old version. I started out on 3.1.4 and have also tried manually 
upgrading to 3.2.1, but the bug still exists.

Somewhere along the way, the "auto" partitionable flag has broken.

sudo mdadm --create --level=raid5 --auto=part2 /dev/md1 --metadata=1.2 
--raid-devices=4 /dev/sda2 /dev/sdb2 /dev/sdc2 /dev/sdd2

This only creates /dev/md1. It is of course possible to create one big 
partition as /dev/md1p1 with any partitioning program, but FORGET about 
trying to create /dev/md1p2.

The problem is that the RAID array is NOT created in partitionable mode, 
and only supports one large partition, despite ALL attempts at EVERY 
format of the --auto option, you name it, -a part2, --auto=mdp2, 
--auto=part2, --auto=p2, --auto=mdp, --auto=part, --auto=p, --auto=p4, 
you name it and I've tried it!

My guess is the functionality of creating partitionable arrays literally 
DID break somewhere prior to/at version 3.1.4 which is the earliest 
version I tried.

I'm giving up and creating physical n-1 sized partitions on the source 
disks and creating two RAID 5 arrays from those partitions instead, but 
decided I really MUST report this bug so that other people don't bang 
their head against the wall for ten hours of their life as well. ;-)


Christopher

