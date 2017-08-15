From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Unable to remove write journal device
Date: Tue, 15 Aug 2017 11:41:06 -0400
Message-ID: <81af1a1e-ed4e-b080-ecbe-f2b0b8d0234b@nuclearwinter.com>
References: <60abb68c-790b-42a0-3fbd-967b4cf877e5@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <60abb68c-790b-42a0-3fbd-967b4cf877e5@nuclearwinter.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My understanding is that the current procedure to remove a write journal 
device is to first fail it then remove it. When I tried that mdadm 
hanged when I tried to remove the journal device. I'm running kernel 
4.12.5-300.fc26.x86_64 and mdadm - v4.0 - 2017-01-09.

My original objective was to test array reshaping with a journal device 
in use. My attempt to add a device failed so I decided to try removing 
the journal, doing a reshape, then re-adding the journal.

What is the correct procedure for removing a journal device?

Here's what I did...

[root@build ~]# mdadm --readonly /dev/md1
[root@build ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md1 : active (read-only) raid5 sdf1[5](S) sdb1[0] sdd1[3] sde1[4](J) sdc1[1]
       4190208 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]

unused devices: <none>
[root@build ~]# mdadm /dev/md1 --fail /dev/sde1
mdadm: set /dev/sde1 faulty in /dev/md1
[root@build ~]# mdadm /dev/md1 --remove /dev/sde1

...hangs here...

The journal device is now marked failed but it isn't removed.

[root@build ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md1 : active (read-only) raid5 sdf1[5](S) sdb1[0] sdd1[3] sde1[4](J)(F) 
sdc1[1]
       4190208 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]

unused devices: <none>

The following shows up in the logs:
[  393.707053] md/raid:md1: Disk failure on sde1, disabling device.
                md/raid:md1: Operation continuing on 3 devices.
[  393.714055] md/raid:md1: Disabling writeback cache for degraded array.

--Larkin

