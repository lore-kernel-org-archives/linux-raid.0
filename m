From: Bill Davidsen <davidsen@tmr.com>
Subject: Completely discontinuing an array
Date: Thu, 21 Dec 2006 14:06:29 -0500
Message-ID: <458ADB35.3030308@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Since I have been doing a lot of array creation related to the RAID-5 
performance thread, I want to make the array "go away" so nothing tries 
to start, stop, or otherwise use the array. I tried setting the 
superblock to zero, but that results in boot warnings for every 
partition. I can change the partition type to something other than RAID, 
but that rapidly gets ugly since I really want some partitions around 
for ad-hoc testing.

Is there something which will stop an array and dismember it? Like:
  mdadm -S --nuke /dev/md5
or similar, to stop the array and mark it as not in use so boot won't 
try doing anything with it.

If there isn't such a feature, or an easy way to get the desired end 
result, could you consider that a minor feature request? Preferably an 
option to stopping the array, perhaps a magic superblock other than 
zero, to tell the boot "I know it's dead, deal with it."

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

