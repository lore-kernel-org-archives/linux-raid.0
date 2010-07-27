From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: raid1 performance
Date: Mon, 26 Jul 2010 20:23:40 -0500
Message-ID: <B3.9C.03451.D153E4C4@cdptpa-omtalb.mail.rr.com>
References: <20100726210324.6a4077e6@notabene>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100726210324.6a4077e6@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <nfbrown@novell.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > Hi Roman,
> > thank you for your hint, I verified the read-ahead settings and they are
> the
> > same for all the block devices involved in the test: the value is 256
> for all
> > /dev/sd?? and for all /dev/md?
> > there should be something else which is influencing  raid 1 performance.
> > Have someone of you ever had a similar issue ?
> >
> 
> Very odd.
> I just tested my test hardware and get exactly the same 56 MB/sec both for
> the RAID1 and the individual devices.
> 
> There is only one way that I can think of that the accesses going via
> RAID1
> would be different from those going direct, and that is that the starting
> offset might be different if you are using 1.x metadata.
> I guess if you had those new 4K-sector devices that might make a
> difference,
> but I wouldn't really expect it to.
> 
> For a sequential read like that, md/raid1 doesn't even do read-balancing,
> all
> the reads go the the same device.
> 
> If you look at /proc/diskstats and particularly the 4th and 6th fields for
> the device that you are interested in, and then take the differences for
> each
> field between 'before' and 'after' running a test you will get
>   - the number of IO requests
>   - the number of sectors
> 
> that were serviced during that time.  Taking a ratio will get you the
> number
> of sectors per IO.  Normally more is better.
> 
> I just tested 'sde' which gave 8.25 sectors per request - so most requests
> were 4K.
> md2 on the other hand gave 31.02, so many requests were 16K.  That really
> surprises me.
> Looking at he 'queue' numbers in /sys/block/X/queue - some of which guide
> the
> breaking up of pages into requests - all the md2 number are the same as
> sde
> or smaller.  So I'm currently rather confused.
> 
> It might be interesting to find out what the data offset is for your RAID1
> (mdadm --examine will tell you if there is one), and compare the
> request/sector numbers and see if they show anything.

	Interesting.  My video server has been up for 11 days since my last
reboot, and the individual members are showing an average of 173
sectors/request, while the RAID6 array is showing 167.  Meanwhile, the
backup server (up 9 days) is showing an average of 309 sectors/request,
while the RAID6 array there is showing 210.  Are these high numbers compared
to yours because most of the accesses are sequential?

