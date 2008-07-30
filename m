From: Richard Michael <rmichael-raid@edgeofthenet.org>
Subject: Re: Docs and operation of RAID10, size limitations on 0.90
Date: Wed, 30 Jul 2008 17:49:33 -0400
Message-ID: <20080730214933.GC12623@nexus.edgeofthenet.org>
References: <20080728143553.GE30681@nexus.edgeofthenet.org> <4890943E.5060608@tmr.com> <20080730182907.GB10710@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080730182907.GB10710@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 30, 2008 at 08:29:07PM +0200, Keld J=F8rn Simonsen wrote:
> On Wed, Jul 30, 2008 at 12:18:06PM -0400, Bill Davidsen wrote:
> > Richard Michael wrote:
> > >Hello list,
> > >
> > >I'm building a new system with 8 disks, in two RAID5 arrays of 4 d=
isks
> > >each, and a RAID1 array across them.  (Then LVM2 on top of the RAI=
D1
> > >array.)
> > >
> > >I approached it this way for two reasons:
> > >
> > >1/ It feels "cleanest"; in the sense that it's not a special case,=
 it's
> > >just RAID1 with two devices, which happen to be RAID5.
>=20
> To me it seems muddy. Just having one big raid5 or raid10 would be cl=
eaner and
> give better performance.

I can't have one big RAID5 because I want to split it in half
regularly.  I refer to it as "cleaner", because it treats the devices
separately, which is what they are; one is RAID1 device, the other is a
RAID5 device.  Each is agnostic, and independent, with regard to the
other.  "Muddy" in my opinion is a mdadm hybrid RAID10, of which I need
special knowledge.  YMMV.
=20
> > >2/ I have a particular usage in mind: I need to be able to split
> > >the mirror and remove half; return it later and resync.  Therefore=
,
> > >I want to know which disks comprise which halves.
>=20
>=20
> I am not sure what you mean with this. You want to remove half of the
> disks? I think you can do that with raid10, you just remove every
> other disk. I have not tried that out, however. You could try it out
> before actually emplouing it.

Re-reading what I wrote, it's a mess of typos. :)  But, yes, I want to
remove half the disks on a regular basis, as off-site storage, and retu=
rn
them to the array for periodic resync.

Regards,
Richard
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
