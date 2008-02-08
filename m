From: Marcin Krol <admin@domeny.pl>
Subject: Re: Deleting mdadm RAID arrays
Date: Fri, 8 Feb 2008 10:35:25 +0100
Message-ID: <200802081035.25722.admin@domeny.pl>
References: <200802051142.19625.admin@domeny.pl> <200802071056.33221.admin@domeny.pl> <47AB79B1.6000503@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47AB79B1.6000503@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thursday 07 February 2008 22:35:45 Bill Davidsen napisa=C5=82(a):
> > As you may remember, I have configured udev to associate /dev/d_* d=
evices with
> > serial numbers (to keep them from changing depending on boot module=
 loading=20
> > sequence).=20

> Why do you care?=20

Because /dev/sd* devices get swapped randomly depending on boot module =
insertion
sequence, as I explained earlier.

> If you are using UUID for all the arrays and mounts =20
> does this buy you anything?=20

This is exactly what is not clear for me: what is it that identifies dr=
ive/partition as part of=20
the array? /dev/sd name? UUID as part of superblock? /dev/d_n?

If it's UUID I should be safe regardless of /dev/sd* designation? Yes o=
r no?

> And more to the point, the first time a =20
> drive fails and you replace it, will it cause you a problem? Require=20
> maintaining the serial to name data manually?

That's not the problem. I just want my array to be intact.

> I miss the benefit of forcing this instead of just building the=20
> information at boot time and dropping it in a file.

I would prefer that, too - if it worked. I was getting both arrays mess=
ed=20
up randomly on boot. "messed up" in the sense of arrays being composed
of different /dev/sd devices.


> > And I made *damn* sure I zeroed all the superblocks before reassemb=
ling=20
> > the arrays. Yet it still shows the old partitions on those arrays!
> >  =20
> As I noted before, you said you had these on whole devices before, di=
d=20
> you zero the superblocks on the whole devices or the partitions? From=
=20
> what I read, it was the partitions.

I tried it both ways actually (rebuilt arrays a few times, just udev di=
dn't want
to associate WD-serialnumber-part1 as /dev/d_1p1 as it was told, it sti=
ll claimed
it was /dev/d_1).=20

Regards,
Marcin Krol
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
