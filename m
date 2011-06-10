From: Bill Davidsen <davidsen@tmr.com>
Subject: Disk upgrade
Date: Fri, 10 Jun 2011 10:09:11 -0400
Message-ID: <4DF22587.60509@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm running out of room in a box to add drives, so I want to go to 
larger drives. Unfortunately I have but one bay left. What I would like 
to do is put in a single drive, create a raid-10f2 array with a missing 
device, and copying all of the data off the existing arrays onto the 
raid-10 array, then diddling the boot so I can get up off the new drive, 
removing the old drives, adding another new drive and adding that to the 
array, along with a spare, perhaps.

Any particular problems with that plan? It leaves the existing drives 
intact, and critical data is backup via rsync on both a removable device 
and to network storage.


-- 
Bill Davidsen<davidsen@tmr.com>
   We are not out of the woods yet, but we know the direction and have
taken the first step. The steps are many, but finite in number, and if
we persevere we will reach our destination.  -me, 2010



