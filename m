From: Flynn <flynn@kodachi.com>
Subject: Re: RAID6 Reshape Gone Awry
Date: Fri, 03 Aug 2012 11:44:23 -0400
Message-ID: <1D8A0C2B1AA1D2315D7EED1D@ryoohko.kodachi.com>
References: <8C493F417CC49C6619BBAF45@ryoohko.kodachi.com>
 <501BB374.9020607@hardwarefreak.com> <501BD420.10203@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <501BD420.10203@hesbynett.no>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: stan@hardwarefreak.com, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

David writes:
> As I read it, he has this (prior to adding the new disk):
>
> md0 = raid6(sda5, sdb5, sdc5, sdd5, sde5)
> md1 = raid6(sda6, sdb6, sdc6, sdd6, sde6)
> ...
> md9 = raid6(sda14, sdb14, sdc14, sdd14, sde14)

That's correct (although it's md5 - md14, to match the partition numbers). 
You're also correct that the LVM is a concatenation rather than striped. 
It performs just fine for its use case: occasional large writes (mostly 
with scp), lots of reading.

David continues:
> I have sometimes used multiple arrays like this:
>
> md0 = raid1,n4(sda1, sdb1, sdc1, sdd1) for /boot (makes grub happy)
> md1 = raid5(sda2, sdb2, sdc2, sdd2) for everything else
>
> But this particular setup seems very odd to me - I would love to know the
> reasoning behind it.

In fact, there is also a RAID1 md0 for grub's sake as well, but it's not 
relevant to the problem.

I first built this array about four years ago, when CentOS 5.2 was current. 
It started life as a RAID5 (not 6) of 4 500GB drives, and I knew when I 
created it that I'd need to grow it over time by adding drives.

At that time, though, mdadm as shipped with CentOS 5.2 couldn't reshape a 
RAID5 -- IIRC, the most recent version of mdadm at the time listed it as an 
experimental feature that would eat your data and give you bad breath.  But 
LVM + md + multiple partitions makes it possible, as long as you hold some 
space in reserve (a good idea for snapshot support anyway).  Use pvmove to 
clear a given md device, pull the md out of the LVM, dissassemble it, 
reassemble it in whatever new configuration you need, and then put it back 
into the LVM.

Yes, it is an administrative mess.  But it was a powerful administrative 
mess.  [ :) ]  This array has gone from a 4x500GB RAID5 to a 4x1500GB RAID5 
to a 5x1500GB RAID6, without ever running anything in degraded mode, or 
taking the array as whole offline for any significant time.

Of course, the downside is that pvmove + recreating the array spends a lot 
of time hammering the drives: for 5x1500 RAID6 to 6x1500 RAID6, it was 
looking like a few weeks.  Since mdadm _can_ reshape RAID6 now, and it was 
past time to get off CentOS anyway, spending a few weeks beating on the 
disk drives didn't much appeal to me.

To preempt a few other obvious questions: CentOS was a plus because I 
worked at a shop that made heavy use of RHEL at the time.  Getting CentOS 
to boot off RAID sucked, though; that plus my tendency towards sysadmin by 
not screwing with a working system made me disinclined, for a long time, to 
go to a newer OS or mdadm.  And it's a rather stripped-down system, to make 
security simpler to manage.

At this point, the system boots Ubuntu off CF, sidestepping the whole 
booting-off-RAID issue completely.

Stan notes:
> What it can do is cause massive problems for the elevator when you try
> to reshape 10 arrays simultaneously...

Note, though, that mdadm _did not_ try to reshape ten arrays 
simultaneously.  It marked all but one as "pending" and then started into 
reshaping the one, which isn't any more abuse of the elevator algorithm 
than it normally gets...

Stan also suggests:
> Backup what you need to external storage [and] [s]tart over from 
scratch...

to which David concurs:
> If the OP can manage it, then I agree.

Nope, the OP cannot, especially not with arrays that can't be started.  [ 
:) ]  As noted, in theory it's all replaceable data anyway, but it would be 
much more pleasant to not have to make the experiment.

<deep breath>  OK.  All that being said, can we perhaps take the honor of 
the list as upheld, and return to the question of recovery?  Is there a way 
to recover a RAID6 where the event counters and checksums and all that are 
consistent, but where the superblock is marked as version 0.91.00, and 
where it complains about failing to restore the critical section, even 
though it said it got past the critical section before?

Thanks much!

 -- Flynn

--
Never let your sense of morals get in the way of doing what's right.
                                                            (Isaac Asimov)

