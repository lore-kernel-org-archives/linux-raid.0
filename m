From: =?iso-8859-1?Q?Jakob_=D8stergaard?= <jakob@unthought.net>
Subject: Re: just how dangerous is this??
Date: Tue, 28 May 2002 21:51:01 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020528215101.E20621@unthought.net>
References: <200205281055.11601.jfillman@cucbc.com> <Pine.LNX.4.30.0205282103070.8146-100000@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.30.0205282103070.8146-100000@duplo.agenda.si>; from danci@agenda.si on Tue, May 28, 2002 at 09:20:39PM +0200
To: Danilo Godec <danci@agenda.si>
Cc: James Fillman <jfillman@cucbc.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, May 28, 2002 at 09:20:39PM +0200, Danilo Godec wrote:
> On Tue, 28 May 2002, James Fillman wrote:
=2E..
> I think this shouldn't work at all - have you rebooted the machine ye=
t?
>=20
> It's not quite clear how the mirrors reconstruct if one of the disks
> (partitions) already has a filesystem on it, but I'm almost sure it's=
 not
> ment to reconstruct it properly...

Either it reconstructs it "right" or it does it "wrong".  It seems in h=
is case
it did it right.   Lucky him.

Hoever, the persistent superblocks will overwrite the last few KB of hi=
s
*filesystem* on each partition.   So things *may* seem to work, but the
system will fail horribly later.  After an fsck the RAID suprblocks wil=
l
be damaged.  After another mkraid the filesystem will be damaged again.

>=20
> AFAIK making a filesystem on a Linux SW RAID array is somewhat differ=
ent
> from making it on a 'normal' disk, so while you may end up with a
> filesystem, it will probably be full of errors.

Yep.

>=20
> How does your raidtab look like?
>=20
> The 'right' way of doing this is:
>=20
> - create a 'degraded' mirror with sda* partitions marked as 'failed'
> - copy all the data from sda* partitions to the appropriate mirrors
>   (/dev/md*)
> - modify /etc/fstab on the mirrored filesystem to use the mirrors
> - reboot, use filesystems on the mirror (root=3D/dev/md?)
> - hot add sda* partitions to approprate mirrors (using raidhotadd or
>   mdadm)
> - wait for the reconstruction to finish
> - make sure that both disks have the boot loader installed in MBR, so=
 they
>   can both be used for booting

Yep.

>=20
> This should be it. Unfortunately, this procedure is not that easy to
> script.

I suppose that if the installation kernel (the one booted during the in=
stallation
process) could be made to support RAID (with autodetection), you could =
just create
the RAID arrays prior to installation, and then simply install on those=
 arrays.

But that may require some hacking of the SuSE install disk...

>=20
> > the mkraid command warns me that it will delete all the data on the=
 partitions
> > when creating the mirrors, but it doesn't.
>=20
> I guess it doesn't delete the data, it destroys it... :)

Just a small amount of it.  It "almost doesn't totally f*ck up the syst=
em"   ;)

>=20
> > What sort of implications am I looking at with this? Will it be uns=
table?
>=20
> I am no super-expert or guru, but I'd say YES. Try booting the system=
 with
> a rescue disk and run e2fsck on your mirrored filesystems. If this go=
es
> through OK... Well, then I might be wrong and it's OK to do this with=
 new
> kernel/raidtools...

I'd say you're right about the failures.

--=20
=2E...............................................................
:   jakob@unthought.net   : And I see the elder races,         :
:.........................: putrid forms of man                :
:   Jakob =D8stergaard      : See him rise and claim the earth,  :
:        OZ9ABN           : his downfall is at hand.           :
:.........................:............{Konkhra}...............:
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
