From: <pg_mh@mh.to.sabi.co.UK>
Subject: Re: How many drives are bad?
Date: Thu, 21 Feb 2008 20:54:24 +0000
Message-ID: <18365.58624.781868.314351@tree.ty.sabi.co.UK>
References: <6b3a7f010802190923v6b600fedy2a68ad6797449c6e@mail.gmail.com>
	<alpine.DEB.1.00.0802191231100.25959@p34.internal.lan>
	<21289113-077C-4082-8EE1-C7AA11D4FE69@gmail.com>
	<alpine.DEB.1.00.0802191332390.25959@p34.internal.lan>
	<6b3a7f010802191038y377999e0v46dcd7132ab3bc97@mail.gmail.com>
	<alpine.DEB.1.00.0802191413060.26058@p34.internal.lan>
	<6b3a7f010802191125q3905d1abw2372ed5c7ab1eaf0@mail.gmail.com>
	<18363.54503.132788.594068@tree.ty.sabi.co.UK>
	<9348A68C-6747-481A-96C0-13691F7863EF@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
In-Reply-To: <9348A68C-6747-481A-96C0-13691F7863EF@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Thu, 21 Feb 2008 13:12:30 -0500, Norman Elton
>>> <normelton@gmail.com> said:

[ ... ]

normelton> Assuming we go with Guy's layout of 8 arrays of 6
normelton> drives (picking one from each controller),

Guy Watkins proposed another one too:

   =ABAssuming the 6 controllers are equal, I would make 3 16 disk
    RAID6 arrays using 2 disks from each controller.  That way
    any 1 controller can fail and your system will still be
    running. 6 disks will be used for redundancy.

    Or 6 8 disk RAID6 arrays using 1 disk from each controller).
    That way any 2 controllers can fail and your system will
    still be running. 12 disks will be used for redundancy.
    Might be too excessive!=BB

So, I would not be overjoyed with either physical configuration,
except in a few particular cases. It is very amusing to read such
worries about host adapter failures, and somewhat depressing to
see "too excessive" used to describe 4+2 parity RAID.

normelton> how would you setup the LVM VolGroups over top of
normelton> these already distributed arrays?

That looks like a trick question, or at least an incorrect
question; because I would rather not do anything like that
except in a very few cases.

However, if one wants to do a bad thing in the least bad way,
perhaps a volume group per array would be least bad.

Going back to your original question:

  =ABSo... we're curious how Linux will handle such a beast. Has
   anyone run MD software RAID over so many disks? Then piled
   LVM/ext3 on top of that?=BB

I haven't because it sounds rather inappropriate to me.

  =ABAny suggestions?=BB

Not easy to respond without a clear statement of what the array
be used for: RAID levels and file systems are very anisotropic
in both performance an resilience, so a particular configuration
may be very good for something but not for something else.

=46or example a 48 drive RAID0 with 'ext2' on top would be very
good for some cases, but perhaps not for archival :-).
In general, I'd use RAID10 (http://WWW.BAARF.com/), RAID5 in
very few cases and RAID6 almost never.

In general current storage practices do not handle that well
large single computer storage pools (just consider 'fsck'
times) and beyond 10TB I reckon that currently only multi-host
parallel/cluster file systems are good enough, for example
Lustre (for smaller multi TB filesystem I'd use JFS or XFS).

But then Lustre can be also used on a single machine with
multiple (say 2TB) block devices, and this may be the best
choice here too if a single virtual filesystem is the goal:

  http://wiki.Lustre.org/index.php?title=3DLustre_Howto
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
