From: Forrest Taylor <ftaylor@redhat.com>
Subject: Re: RAID 5 Grow
Date: Fri, 15 Jul 2005 14:23:54 -0600
Message-ID: <1121459034.3012.66.camel@x1-6-00-0d-60-fd-e8-4c>
References: <1121457052.3012.36.camel@x1-6-00-0d-60-fd-e8-4c>
	 <42D81981.1050902@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42D81981.1050902@ieee.org>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Valiquette <v.simon@ieee.org>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 2005-07-15 at 14:16, Simon Valiquette wrote:
> Forrest Taylor a =C3=A9crit :
> > I am doing some RAID scenarios on a single disc (testing purposes) =
on
> > RHEL4.  I have some partitions as follows:
> >=20
> > /dev/hda5  100M
> > /dev/hda6  200M
> > /dev/hda7  200M
> > /dev/hda8  200M
> > /dev/hda9  200M
> >=20
> > I create a RAID 5 set with /dev/hda{5,6,7,8}.  I fail/remove /dev/h=
da5
> > and add /dev/hda9, at which point I can grow the RAID.  Running:
> >=20
> > mdadm -G /dev/md0 -z max
> >=20
>=20
>    Have you copied the data from hda5 to hda9 with dd?  If i remember=
,=20
> growing a RAID 5 that way is done by creating the missing stripes at=20
> the end of each disks.  If the array is already in degraded mode, I a=
m=20
> not sure if mdadm is able to recover from that.

I pulled hda5 and added hda9, then I waited for it to resync.  It was
not in degraded mode when I tried to grow the RAID.  I did not copy any
data from hda5 to hda9.  In fact, I had it mounted, and I checked the
integrity of the data at each step.  I did not lose any data, nor did I
lose the RAID.  I don't think that I tried the grow with /dev/md0
unmounted, so it may be possible that having it mounted caused some
trouble.

Thanks,

=46orrest
--=20

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
