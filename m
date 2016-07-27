From: pg@lxra2.to.sabi.co.UK (Peter Grandi)
Subject: Re: migration of raid 5 to raid 6 and disk of 2TB to 4TB
Date: Wed, 27 Jul 2016 16:12:05 +0100
Message-ID: <22424.53061.186858.220134@tree.ty.sabi.co.uk>
References: <CADzS=aqYQEoqxHbp7keeuYqN2dLur1O=RfctfuFsraggxiWTKg@mail.gmail.com>
	<22423.44287.974770.114127@tree.ty.sabi.co.uk>
	<5797C5CE.6020300@youngman.org.uk>
	<CADzS=arvFWy-9_e8L3ngdrYxwGxVNm=zTqoLusvwKmmkUnBfQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADzS=arvFWy-9_e8L3ngdrYxwGxVNm=zTqoLusvwKmmkUnBfQQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

BTW as to in general this question:

> which one is the safest ?

That would be the first option I presented, where the 3x 4TB
disks get split in two, and the existing 3 2TB slices get copied
onto them, as I wrote:

> The least scary option might be:
> 
> * Split into two partitions D and E.
> * Block copy the image on C to D1 and E2.
> * Re-partition C also in two.
> * Block copy B to C1.
> * Block copy A to E2.
> * Now we have greatly increased redundancy, as we have the 3x
>   2TB data slices on two separate sets, A, C1, D1 and D2, B,
>   E2.

That is about as good as it gets as to safety with the limited
number of drives in play.  BTW note that it is really important
not to start the second copy, because it has the same set and
member UUIDs as the other one. But the O.P. must be a very
experienced RAID specialist, or he would not be trying to do
subtle device restructuring like this.

> * Add E1 as a spare to the A, C1, D1 RAID5 set, and start it so
>   you end up with a full RAID5 set on A, C1, D1, E1 after
>   resync end.

This resync is less dangerous because we have a full (if
degraded) copy of the data on D2, B, E2.

With an extra 4TB drive, even a temporary one, to hold an
offline backup (if the 4.5TB can be compressed to fit), more
dangerous options become less scary.

> * Now that the first RAID5 set is not degraded, you can erase
>   the copies on D2, B, E2, and create a second RAID5 set on
>   B, C2, D2, E2, which will be empty.
