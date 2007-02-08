From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm RAID5 array failure
Date: Thu, 8 Feb 2007 14:57:47 +1100
Message-ID: <17866.40891.652153.345571@notabene.brown>
References: <24264.46597.qm@web55801.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from jahammonds prost on Thursday February 8
Sender: linux-raid-owner@vger.kernel.org
To: jahammonds prost <gmitch64@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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
