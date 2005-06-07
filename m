From: Mike Hardy <mhardy@h3c.com>
Subject: Re: entire array lost when some blocks unreadable?
Date: Tue, 07 Jun 2005 14:13:20 -0700
Message-ID: <42A60DF0.3070502@h3c.com>
References: <42A60A1A.9030302@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42A60A1A.9030302@gmx.ch>
Sender: linux-raid-owner@vger.kernel.org
To: Tom Eicher <tom.eicher@gmx.ch>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Linux raid considers one unreadable block on one drive sufficient
evidence to kick the whole device out of the array.

If at that point reconstruction finds other blocks, you have the dreaded
raid 5 double disk failure. Total loss, *seemingly*.

You already realize the important information though, which is that the
unreadable sections of disk are probably not in the same stripe on each
disk (that's highly improbably, at least, and you can check either way)
so you actually have enough information via redundancy to recover all of
your information.

You just can't do it with the main raid tools.

I posted a number of things under the heading "the dreaded double disk
failure" on this list, including a script to create a loopback device
test array, and a perl script (several iterations, in fact) that
implements the raid5 algorithm in software and can read raid5 stripes
and tell you (via parity) what the data in a given device for a given
stripe should be.

Using a strategy similar to this, you can then re-write the data onto
the unreadable sectors, causing the drive firmware to remap those
sectors and fix that spot.

Repeat until you're clean, and you may have your data back.

In general though, your hunch is right. smartd
(http://smartmontools.sf.net) running scans (I do a short scan on each
disk staggered nightly, and a long scan on each disk once a week also
staggered) with email notifications will help. mdadm running with email
notifications will notify when you lost a disk so you can take action if
necessary (for instance, a long scan of all the remaining disks ASAP)

Also, raid is no substitute for good backups.

Good luck - and if you use the scripts, please post any patches that
make them more useful. They are far from perfect, but worked for me.
Hopefully they can help you if you need them.

-Mike

Tom Eicher wrote:
> Hi list,
> 
> I might be missing the point here... I lost my first Raid-5 array
> (apparently) because one drive was kicked out after a DriveSeek error.
> When reconstruction startet at full speed, some blocks on another drive
> appeared to have uncorrectable errors, resulting in that drive also
> being kicked... you get it.
> 
> Now here is my question: On a normal drive, I would expect that a drive
> seek error or uncorrectable blocks would typically not take out the
> entire drive, but rather just corrupt the files that happen to be on
> those blocks. With RAID, a local error seems to render the entire array
> unusable. This would seem like an extreme measure to take just for some
> corrupt blocks.
> 
> - Is it correct that a relatively small corrupt area on a drive can
> cause the raid manager to kick out a drive?
> - How does one prevent the scenario above?
>  - periodically run drive tests (smart -t...) to early detect problems
> before multiple drives fail?
>  - periodically run over the entire drives and copy the data around so
> the drives can sort out the bad blocks?
> 
> Thanks for any insight, tom
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
