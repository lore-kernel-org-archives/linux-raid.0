From: Neil Brown <nfbrown@novell.com>
Subject: Re: raid1 performance
Date: Mon, 26 Jul 2010 21:03:24 +1000
Message-ID: <20100726210324.6a4077e6@notabene>
References: <443220.14357.qm@web28508.mail.ukl.yahoo.com>
	<20100725211926.7547c12e@natsu>
	<23123.42111.qm@web28503.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <23123.42111.qm@web28503.mail.ukl.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marco <jjletho67-diar@yahoo.it>
Cc: Roman Mamedov <roman@rm.pp.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 26 Jul 2010 09:37:20 +0000 (GMT)
Marco <jjletho67-diar@yahoo.it> wrote:

> 
> 
> >> doing a simple performance tests i obtained some very unexpected results: if
> >> i issue hdparm -t /dev/md2 i obtain 61 - 65 MB/s while issuing the same test 
> >> directly on the partitions which compose md2 (/dev/sda3 and /dev/sdb3) i
> >> obtain 84 - 87 MB/s. I didn't expect a so big difference between md2 and one
> >> of its member. What can cause  this difference ? 
> >
> >Maybe their read-ahead settings are different?
> >Check out "blockdev --getra /dev/md2", and compare that with the same
> >setting of the member disks. You can experiment with changing it by using
> >"--setra" as well.
> 
> Hi Roman,
> thank you for your hint, I verified the read-ahead settings and they are the 
> same for all the block devices involved in the test: the value is 256 for all 
> /dev/sd?? and for all /dev/md?
> there should be something else which is influencing  raid 1 performance.
> Have someone of you ever had a similar issue ?
> 

Very odd.
I just tested my test hardware and get exactly the same 56 MB/sec both for
the RAID1 and the individual devices.

There is only one way that I can think of that the accesses going via RAID1
would be different from those going direct, and that is that the starting
offset might be different if you are using 1.x metadata.
I guess if you had those new 4K-sector devices that might make a difference,
but I wouldn't really expect it to.

For a sequential read like that, md/raid1 doesn't even do read-balancing, all
the reads go the the same device.

If you look at /proc/diskstats and particularly the 4th and 6th fields for
the device that you are interested in, and then take the differences for each
field between 'before' and 'after' running a test you will get
  - the number of IO requests
  - the number of sectors

that were serviced during that time.  Taking a ratio will get you the number
of sectors per IO.  Normally more is better.

I just tested 'sde' which gave 8.25 sectors per request - so most requests
were 4K.
md2 on the other hand gave 31.02, so many requests were 16K.  That really
surprises me.
Looking at he 'queue' numbers in /sys/block/X/queue - some of which guide the
breaking up of pages into requests - all the md2 number are the same as sde
or smaller.  So I'm currently rather confused.

It might be interesting to find out what the data offset is for your RAID1
(mdadm --examine will tell you if there is one), and compare the
request/sector numbers and see if they show anything.

NeilBrown
