From: Andreas Boman <aboman@midgaard.us>
Subject: Failed during rebuild (raid5)
Date: Fri, 03 May 2013 07:23:59 -0400
Message-ID: <51839E4F.7050102@midgaard.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have (had?) a raid 5 array, with 5 disks (1.5TB/EA), smartd warned one 
was getting bad, so I replaced it with an identical disk.

I issued mdadm --manage --add /dev/md127 /dev/sdX

The array seemed to be rebuilding, was at around 15% when I went to bed.

This morning I came up to see the array degraded with two missing 
drives, another failed during the rebuild.

I powered the system down, and since I have the disk smartd flagged as 
bad and tried to just plug that in and power up hoping to see the array 
come back up -no such luck (not enough disks).

I powered the system down again, and now I'm trying to evaluate my best 
options to recover. Hoping to have some good advice in my inbox when I 
get back from the office. I'll be able to boot the thing up and get log 
info this afternoon.

Thanks!
Andreas

(please cc me, not subscribed)
