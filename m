From: hxsrmeng <hxsrmeng@gmail.com>
Subject: Re: Is that normal a removed part in RAID0 still showed as "active
	sync"
Date: Tue, 08 Jan 2008 00:13:32 -0500
Message-ID: <1199769212.8587.22.camel@OpenSUSE-desktop.Home>
References: <14670113.post@talk.nabble.com>
	 <18306.62418.854287.117775@notabene.brown>
Reply-To: hxsrmeng@gmail.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18306.62418.854287.117775@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks. That's really helpful.

When doing this, I used "tail -f /var/log/messages" to monitor my
program, which does I/O to md0.

After sdd was removed physically, it seemed the I/O operations to the
md0 continued: 
"tail -f /var/log/messages" occasionally shows:
     SCSI error: return code = 0x00040000
     kernel: end_request: I/O error, dev sdd, sector 15357599
but showed all the other messages just as sdd was still there.

Is this normal? 

I am really not sure whether the result of my program is still
trustable.

Also, if sdd1 is the only device which fails, is there any way to know
it? Just as what "mdadm --monitor" does?

Thank you.


On Tue, 2008-01-08 at 14:53 +1100, Neil Brown wrote:
> On Monday January 7, hxsrmeng@gmail.com wrote:
> > 
> > The /dev/md0 is set as RAID0
> > "cat /proc/mdstat" shows
> > md0 : active raid0 sda1[0] sdd1[3] sdc1[2] sdb1[1]
> > 157307904 blocks 64k chunks
> > 
> > Then sdd is removed.
> > 
> > But  "cat /proc/mdsta" still shows the same information as above, while two
> > RAID5 devices show their sdd parts as (F)
> > md0 : active raid0 sda1[0] sdd1[3] sdc1[2] sdb1[1]
> > 157307904 blocks 64k chunks
> > 
> > Is this normal?
> 
> Yes.
> 
> raid0 is not real raid.  It is not able to cope with disk failures, so
> it doesn't even try.  Devices in a raid0 are never marked failed as
> doing so would be of no benefit.
> 
> NeilBrown
> 
> 

