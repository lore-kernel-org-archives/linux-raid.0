From: "Robin Bowes" <robin-lists@robinbowes.com>
Subject: Re: Sanity check installation scheme
Date: Thu, 15 Apr 2004 12:12:51 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <34091.194.60.85.4.1082027571.squirrel@194.60.85.4>
References: <S262063AbUDNXhL/20040414233712Z+1806@vger.kernel.org>
    <Pine.LNX.4.56.0404150825010.12357@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0404150825010.12357@lion.drogon.net>
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, April 15, 2004 9:15, Gordon Henderson said:
> On Thu, 15 Apr 2004 robin-lists@robinbowes.com wrote:
>
>> Does this look feasible? Can you see any major gotchas? Any better
>> suggestions?
>
> Personally I'd keep life simple at the expense of a little disk space - my
> layouts are also based on wanting to split partitions to, so I'd never put
> /, /usr and /var on the same partition - historical reasons, including
> fsck time and maybe a distrust of very old PDP11 Unix systems...  (Yes,
> I'm a boring old fart) Anyway what I do with my own machines (and those I
> build for others) is as follows:

I do the same thing. I thought that I could create separate partions on
top of the RAID-5 array, like I would with hardware RAID (I have some
experience with a Compaq SMART-2P and external storage rack). If that's
not the case then I shall re-think accordingly.

> Partition each disk identically. That way, if you need to swap out a
> drive, you already have a copy of what it's partition table ought to look
> like by simply looking at the other drives - sort of self documenting if
> you like.

Makes sense to me.

> So for a single disk system it might look like:
>
>   sda1	256MB		/
>   sda2    1GB		swap
>   sda3    2GB		/usr
>   sda4  Rest of disk	/var
>
> Actually, /usr might be less and swap would be double memory, but you get
> the jist - use the 4 primary partitions and usually no more. In olden days
> consideration would be made to where the disk head spends most of its time
> - here, oscillating between the /usr (programs) and /var (data) might be
> optimal, but I don't think anyone cares about this these days.
> (historically, /usr was where users home directories lived too, then the
> head would be between /usr and swap and /bin with special programs having
> the 'sticky bit' set to make them reside in memory or swap to make them
> quicker to load)
>
> Partition the drives similar to this in a RAID system too. Then combine
> them as follows:
>
>   sda1 and sdc1:	RAID 1		/
>   sda2,b2,c2,d2:	RAID 5		swap
>   sda3,b3,c3,d3:	RAID 5		/usr
>   sda4,b4,c4,d4:	RAID 5		/var
>
> You "lose" 2 partitions: sdb1 and sdd1. You can combine these in another
> RAID1 if you like, but it's not much use for anything.

OK, I get the picture.

> Putting swap on RAID5 probably isn't optimal, but if your machine is
> swapping heavily, buy more memory. If you are really tight on disk space
> and know you have plenty of RAM no swap is probably better than too little
> swap.

I'll probably put the swap on a mirror, i.e. RAID-1.

> You might need to adjust the sizes of the swap and /usr partitions - I
> usually aim for 2GB under /usr (that would be 4 x 768MB partitions under
> RAID5) - I've found that to be enough for Debian and X and space for other
> stuff, but YMMV. Remember with a 4-disk RAID 5 system you get 3 times the
> capacity.
>
> Debian also puts /home under /, so I always remove it before creating any
> users and create a /var/home and symlink /home to /var/home.
>
> If it's just a home server and you don't anticipate the log files growing,
> you may want to consider not having a separate /var partition and mounting
> that as /home instead...

I usually create several partitions and put as much as possible on
separate file systems, e.g. /var, /home, /usr, /opt, /tmp,
/var/qmail/queue. I might reconsider that if I have to do the same on
every disk!

I may even look into using EVMS so I can configure all of this with a
common interface.

> You need to make sure you can actually boot off sdc1 should you ever lose
> sda. This is vitally important! Most SCSI controllers allow you to change
> the boot drive, so it shouldn't be a problem, but it might mean manual
> intervention should you need to reboot it in a degraded mode.

I'll do some tests to make sure I can do this.

>
> I've not used a /boot partition for about 8 years now. As far as I'm aware
> it was just a "hack" when BIOSes couldn't boot from cylinders > 1024, and
> putting / on the very first partition sorts this anyway. /boot on my
> servers is just a directory under / on all my machines.

Yeah, probably. I just do it as a matter of habit now. It doesn't cost
anything, other than an additional partition.

> Knowing that you are only using 4.3GB drives, I might be tempted to merge
> the /usr and /var partitions.

How do you mean?

Thanks,

R.

-- 
http://robinbowes.com
