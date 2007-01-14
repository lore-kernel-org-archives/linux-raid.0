From: dean gaudet <dean@arctic.org>
Subject: Re: raid5 software vs hardware: parity calculations?
Date: Sat, 13 Jan 2007 19:16:32 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0701131903270.16472@twinlark.arctic.org>
References: <2A887D754684B6703B52E126@emerald.sei.cmu.edu>
 <Pine.LNX.4.64.0701120935000.18431@twinlark.arctic.org>
 <F4B05AD60951BBA089A81535@emerald.sei.cmu.edu>
 <e9c3a7c20701130120o246f5cf1i8d364777123c50d8@mail.gmail.com>
 <45A917B8.2060706@tmr.com> <eobpl9$df3$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <eobpl9$df3$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Bowes <robin-lists@robinbowes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 13 Jan 2007, Robin Bowes wrote:

> Bill Davidsen wrote:
> >
> > There have been several recent threads on the list regarding software
> > RAID-5 performance. The reference might be updated to reflect the poor
> > write performance of RAID-5 until/unless significant tuning is done.
> > Read that as tuning obscure parameters and throwing a lot of memory into
> > stripe cache. The reasons for hardware RAID should include "performance
> > of RAID-5 writes is usually much better than software RAID-5 with
> > default tuning.
> 
> Could you point me at a source of documentation describing how to
> perform such tuning?
> 
> Specifically, I have 8x500GB WD STAT drives on a Supermicro PCI-X 8-port
> SATA card configured as a single RAID6 array (~3TB available space)

linux sw raid6 small write performance is bad because it reads the entire 
stripe, merges the small write, and writes back the changed disks.  
unlike raid5 where a small write can get away with a partial stripe read 
(i.e. the smallest raid5 write will read the target disk, read the parity, 
write the target, and write the updated parity)... afaik this optimization 
hasn't been implemented in raid6 yet.

depending on your use model you might want to go with raid5+spare.  
benchmark if you're not sure.

for raid5/6 i always recommend experimenting with moving your fs journal 
to a raid1 device instead (on separate spindles -- such as your root 
disks).

if this is for a database or fs requiring lots of small writes then 
raid5/6 are generally a mistake... raid10 is the only way to get 
performance.  (hw raid5/6 with nvram support can help a bit in this area, 
but you just can't beat raid10 if you need lots of writes/s.)

beyond those config choices you'll want to become friendly with /sys/block 
and all the myriad of subdirectories and options under there.

in particular:

/sys/block/*/queue/scheduler
/sys/block/*/queue/read_ahead_kb
/sys/block/*/queue/nr_requests
/sys/block/mdX/md/stripe_cache_size

for * = any of the component disks or the mdX itself...

some systems have an /etc/sysfs.conf you can place these settings in to 
have them take effect on reboot.  (sysfsutils package on debuntu)

-dean
