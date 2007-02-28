From: jahammonds prost <gmitch64@yahoo.com>
Subject: Re: trouble creating array
Date: Tue, 27 Feb 2007 19:10:36 -0600 (CST)
Message-ID: <745810.19299.qm@web55812.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just an update for everyone on this (and for the archives), Did some digging, and had a look at the device mapper config

# dmsetup -C info

Name             Maj Min Stat Open Targ Event  UUID
mpath0           253   0 L--w    1    1      0 
VolGroup00-LogVol01 253   3 L--w    1    1      0 LVM-2sahQifzg9s9k0xSkpnzpGCYd7JNVXzUof6XmQ0fhzJ6jIbQLciAbm6lJLwK0Aex
VolGroup00-LogVol00 253   2 L--w    1    1      0 LVM-2sahQifzg9s9k0xSkpnzpGCYd7JNVXzUt3sJ3nwvJF8cr6ebv5AdnY0j4Ajl6U0I
mpath0p1         253   1 L--w    0    1      0 


Those 2 multipath devices shouldn't have been there, and indeed mpath0p1 were my 2 recalcitrant disks.

# dmsetup -C remove mpath0p1
# dmsetup -C remove mpath0

And they were both gone (you need to start at the bottom of the tree when removing them).

A quick fdisk of my disks to create sdb1 and sdc1 partitions, and my array will be synched in 204 mins...:)

Thanks to everyones help for pointing me in the right direction.. It was a trip I would have preferred not to have made, but like all trips like that, it's been illuminating.

Thanks again.


Graham



----- Original Message ----
From: Neil Brown <neilb@suse.de>
To: jahammonds prost <gmitch64@yahoo.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>; linux-raid@vger.kernel.org
Sent: Sunday, 25 February, 2007 11:40:26 PM
Subject: Re: trouble creating array


On Sunday February 25, gmitch64@yahoo.com wrote:
> 
> 
> Any ideas how to find out what has it open? I can happily write all over the disk with dd... I can create and delete the partition, and it's all good... I will try deleting the sd{b,c}1 partitions, reboot, and see what happens.
> 

ls -l /sys/block/*/holders/* ??

NeilBrown


	
	
		
___________________________________________________________ 
New Yahoo! Mail is the ultimate force in competitive emailing. Find out more at the Yahoo! Mail Championships. Plus: play games and win prizes. 
http://uk.rd.yahoo.com/evt=44106/*http://mail.yahoo.net/uk 
