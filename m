From: Alexander Shenkin <al@shenkin.org>
Subject: raid1 + raid6 setup recommendations
Date: Sun, 19 Apr 2020 08:03:22 +0100
Message-ID: <f81b931b-2599-6ae1-bc4a-11eb0daea339@shenkin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

I recently recovered my raid6 that had a problem during a reshape.  My
system no longer boots, so I'm taking the opportunity to install a new,
clean OS.  I have 7 disks with /boot mounted on a ~1.5 GB raid1 spread
across partitions on all disks, and / mounted on a 15TB raid6 with
partitions across all disks (~3 TB / disk).  11TB of that 15TB raid6 is
filled with data I'd prefer not to lose.  I was going to use the same
layout to install ubuntu server 18, but partman is not able to mount the
raid6 for some reason (it thinks it's ext2, when it's ext4).

I've gotten some feedback saying that it's not wise to use a huge raid
to mount at /, and that it might be better to mount the principal OS on
a separate mount point so that it can be formatted.  I don't know if I'm
able to use LVM at this point, given that I have data I don't want to
lose on the raid6.  It would be convenient to create another device at
this point so that I could format it and presumably get around partman's
inability to mount my raid6 at /...

So, the question is, do you agree that it's better to separate out the
OS in another raid array or mount point?  If so, is LVM an option at
this point, or should I somehow shrink the raid6 to make room for
another partition across all disks for another raid for the OS? 
Finally, if so, (and perhaps this is beyond the scope of this list),
which root directories would you put where?

Many thanks,

Allie
