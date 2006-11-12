From: Bill Davidsen <davidsen@tmr.com>
Subject: Recovering from default FC6 install
Date: Sun, 12 Nov 2006 01:00:13 -0500
Message-ID: <4556B86D.3030802@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I tried something new on a test system, using the install partitioning 
tools to partition the disk. I had three drives and went with RAID-1 for 
boot, and RAID-5+LVM for the rest. After the install was complete I 
noted that it was solid busy on the drives, and found that the base RAID 
appears to have been created (a) with no superblock and (b) with no 
bitmap. That last is an issue, as a test system it WILL be getting hung 
and rebooted, and recovering the 1.5TB took hours.

Is there an easy way to recover this? The LVM dropped on it has a lot of 
partitions, and there is a lot of data in them asfter several hours of 
feeding with GigE, so I can't readily back up and recreate by hand.

Suggestions?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

