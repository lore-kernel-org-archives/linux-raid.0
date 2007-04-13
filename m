From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: Re: Growing a raid 6 array
Date: Fri, 13 Apr 2007 10:27:05 +0200
Message-ID: <20070413082705.GA10264@apartia.fr>
References: <45E72549.2080108@unix-scripts.info> <Pine.LNX.4.64.0703011728270.7560@p34.internal.lan> <17895.34033.867599.954940@notabene.brown> <461F3C09.1030909@unix-scripts.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <461F3C09.1030909@unix-scripts.info>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Apr 13, 2007 at 10:15:05AM +0200, Laurent CARON wrote:
> Neil Brown a =E9crit :
> > On Thursday March 1, jpiszcz@lucidpixels.com wrote:
> >> You can only grow a RAID5 array in Linux as of 2.6.20 AFAIK.
> >=20
> > There are two dimensions for growth.
> > You can increase the amount of each device that is used, or you can
> > increase the number of devices.
> >=20
> > You are correct that increasing the number of devices only works fo=
r
> > RAID5 (and RAID1, but you don't get extra space) in 2.6.20 (RAID6
> > coming in 2.6.21).
> >=20
> > However this question is about growing an array the first way:
> > increasing the amount of space used on each devices, and that is
> > supported for RAID1/4/5/6.
> >=20
> > And Laurent:
> >   1/ Yes, it is that easy
> >   2/ I doubt a nearly-full ext3 array increases the risk
> >   3/ The effect of adding a bitmap is that if you suffer a crash wh=
ile
> >      the array is degraded, it will resync faster so you have less
> >      exposure to multiple failure.
>=20
> I just finished changing disks, growing the array, and then the files=
ystem.
>=20
> It worked flawlessy.
>=20
> Just a little notice: I had to unmount my ext3 filesystem to be able =
to
> resize it. (Took ~8 hours to fsck + resize the 15 disks array from 6 =
to
> 9TB on a dual Xeon with 4GB RAM).

=46WIW:

I changed a 6 x 400G system to 500G disks and grew the raid5 array. It=20
worked fine save for these warnings:

	Apr  8 16:54:33 sylla mdadm: RebuildStarted event detected on md devic=
e /dev/md1
	Apr  8 16:54:33 sylla mdadm: Rebuild20 event detected on md device /de=
v/md1
	Apr  8 16:54:33 sylla mdadm: Rebuild40 event detected on md device /de=
v/md1
	Apr  8 16:54:33 sylla mdadm: Rebuild60 event detected on md device /de=
v/md1
	Apr  8 16:54:33 sylla mdadm: Rebuild80 event detected on md device /de=
v/md1
	Apr  8 16:54:33 sylla kernel: md1: invalid bitmap page request: 187 (>=
 186)
	Apr  8 16:54:33 sylla kernel: md1: invalid bitmap page request: 187 (>=
 186)

	etc...

So after rebooting I removed the bitmap and recreated it.

Online resizing of the 2.0T xfs to 2.4T only took a few _seconds_.

A similar operation on a 4 x 250G raid5 system upgraded to 400G disks=20
with reiser3 also took a few seconds of _online_ time.

Kernel 2.6.20.6
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
