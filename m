From: jahammonds prost <gmitch64@yahoo.com>
Subject: Re: mdadm RAID5 array failure
Date: Thu, 8 Feb 2007 19:15:57 -0800 (PST)
Message-ID: <798742.72217.qm@web55812.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> mdadm -Af /dev/md0 should get it back for you. 

It did indeed... Thank you.

> But you really want to find out why it died.

Well, it looks like I have a bad section on hde, which got tickled as I was copying files onto it... As the rebuild progressed, and hit around 6%, it hit the same spot on the disk again, and locked the box up solid. I ended up setting speed_limit_min and speed_limit_max to 0 so that the rebuild didn't happen, activated my LVM volume groups, and mounted the first of the logical volumes. I've just copied off all the files on that LV, and tomorrow I'll get the other 2 done. I do have a spare drive in the array... any idea why it wasn't being activated when hde went offline?

> What kernel version are you running?

Kernel is 2.6.17-1.2142.FC4, and mdadm is V1.11.0 11 April 2005

I am assuming that the underlying RAID doesn't do any bad block handling?


Once again, thank you for your help.


Graham

----- Original Message ----
From: Neil Brown <neilb@suse.de>
To: jahammonds prost <gmitch64@yahoo.com>
Cc: linux-raid@vger.kernel.org
Sent: Wednesday, 7 February, 2007 10:57:47 PM
Subject: Re: mdadm RAID5 array failure


On Thursday February 8, gmitch64@yahoo.com wrote:

> I'm running an FC4 system. I was copying some files on to the server
> this weekend, and the server locked up hard, and I had to power
> off. I rebooted the server, and the array came up fine, but when I
> tried to fsck the filesystem, fsck just locked up at about 40%. I
> left it sitting there for 12 hours, hoping it was going to come
> back, but I had to power off the server again. When I now reboot the
> server, it is failing to mount my raid5 array.. 
>  
>       mdadm: /dev/md0 assembled from 3 drives and 1 spare - not enough to start the array.

mdadm -Af /dev/md0
should get it back for you.  But you really want to find out why it
died.
Where there any kernel messages at the time of the first failure?
What kernel version are you running?

>  
> I've added the output from the various files/commands at the bottom...
> I am a little confused at the output.. According to /dev/hd[cgh],
> there is only 1 failed disk in the array, so why does it think that
> there are 3 failed disks in the array? 

You need to look at the 'Event' count.  md will look for the device
with the highest event count and reject anything with an event count 2
or more less than that.

NeilBrown


		
___________________________________________________________ 
What kind of emailer are you? Find out today - get a free analysis of your email personality. Take the quiz at the Yahoo! Mail Championship. 
http://uk.rd.yahoo.com/evt=44106/*http://mail.yahoo.net/uk 
