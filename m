From: NeilBrown <neilb@suse.de>
Subject: Re: RAID5 superblock and filesystem recovery after re-creation
Date: Mon, 9 Jul 2012 17:08:11 +1000
Message-ID: <20120709170811.7aa546ec@notabene.brown>
References: <CA+=meHXO02k4hSJihNFiYXb+LOjik_LX3n8UZbqERC2tYy+L-g@mail.gmail.com>
	<20120709081358.199630c8@notabene.brown>
	<CA+=meHVhYu8Z5a+D5beWQ-4M7YXq1bCabsqqntMMKfFy5dqAPA@mail.gmail.com>
	<20120709100208.5b9c56cd@notabene.brown>
	<CA+=meHUtC5PqczdhgQM3c2JYBNVGFuWJektgq_+Pvs80JgVHMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Y7llNzDtm/o6XI5IUn4wF6k"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+=meHUtC5PqczdhgQM3c2JYBNVGFuWJektgq_+Pvs80JgVHMw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Schleifer <alexander.schleifer@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Y7llNzDtm/o6XI5IUn4wF6k
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Jul 2012 08:50:16 +0200 Alexander Schleifer
<alexander.schleifer@googlemail.com> wrote:

> 2012/7/9 NeilBrown <neilb@suse.de>:
> > On Mon, 9 Jul 2012 00:45:08 +0200 Alexander Schleifer
> > <alexander.schleifer@googlemail.com> wrote:
> >
> >> 2012/7/9 NeilBrown <neilb@suse.de>:
> >> > On Sun, 8 Jul 2012 23:47:16 +0200 Alexander Schleifer
> >> > <alexander.schleifer@googlemail.com> wrote:
> >> >
> >> >> Hi,
> >> >>
> >> >> after a new installation of Ubuntu, my RAID5 device was set to
> >> >> "inactive". All devices were set to spare device and the level was
> >> >> unknown. So I tried to re-create the array by the following command.
> >> >
> >> > Sorry about that.  In case you haven't seen it,
> >> >    http://neil.brown.name/blog/20120615073245
> >> > explains the background
> >> >
> >> >>
> >> >> mdadm --create /dev/md0 --assume-clean --level=3D5 --raid-disk=3D6
> >> >> --chunk=3D512 --metadata=3D1.2 /dev/sde /dev/sdd /dev/sda /dev/sdc
> >> >> /dev/sdg /dev/sdh
> >> >>
> >> >> I have a backup of the mdadm -Evvvvs output, so I could recover the
> >> >> chunk size, metadata and offset (2048) from this information.
> >> >>
> >> >> The partially output of mdadm --create... shows this output:
> >> >>
> >> >> ...
> >> >> mdadm: /dev/sde appears to be part of a raid array:
> >> >>     level=3Draid5 devices=3D6 ctime=3DSun Jul  8 23:02:51 2012
> >> >> mdadm: partition table exists on /dev/sde but will be lost or
> >> >>        meaningless after creating array
> >> >> ...
> >> >>
> >> >> The array is recreated, but no valid filesystem is found on /dev/md0
> >> >> (dumpe2fs: Filesystem revision too high while trying to open /dev/m=
d0.
> >> >> Couldn't find valid filesystem superblock.). Also fdisk /dev/sde sh=
ows
> >> >> no partition.
> >> >> My next step would be creating Linux RAID type partitions on the 6
> >> >> devices with fdisk and call mdadm --create with /dev/sde1 /dev/sdd1
> >> >> and so on.
> >> >> Is this step a possible solution for recovering the filesystem?
> >> >
> >> > Depends.. Was the original array created on partitions, or on whole =
devices?
> >> > The saved '-E' output should show that.
> >> >
> >> > Maybe you have the devices in the wrong order.  The order you have l=
ooks odd
> >> > for a recently created array.
> >> >
> >> > NeilBrown
> >>
> >> The original array was created on whole devices, as the saved output
> >> starts with e.g. "/dev/sde:".
> >
> > Right, so you definitely don't want to create partitions.  Maybe when m=
dadm
> > reported "partition table exists' it was a false positive, or maybe old
> > information - creating a 1.2 array doesn't destroy the partition table.
> >
> >> I used the order of the 'Device UUID' from the saved output to
> >> recreate the order in the new system (the ports changed due to a new
> >> mainboard).
> >
> > When you say "the order", do you mean the numerical order?
> >
> > If you looked at the old "mdadm -E" output matching the "Device Role" w=
ith
> > "Device UUID" to determine the order of the UUIDs, then looked at the
> > "mdadm -E" output after the metadata got corrupted and used the "Device=
 UUID"
> > to determine the correct "Device Role", then ordered the devices by tha=
t Role,
> > then that should have worked.
>=20
> Ok, I used the "Device UUID" only to get the order. Now I reordered my
> "mdadm --create..." call according to old "Device Role" and it works
> ;)
>=20
> >
> > I assume you did have a filesystem directly on /dev/md0, and hadn't
> > partitioned it or used LVM on it?
>=20
> Yes, the devices all are the same type and so I used the whole device
> and created a filesystem directly on /dev/md0.
>=20
> Now, fsck is running pass 1 for a few minutes with no error. So, I
> think that everything is fine and I say thank you for helping get my
> raid back to life ;-)
>=20

Good news!  Always happy to hear success reports.

Thanks,
NeilBrown

--Sig_/Y7llNzDtm/o6XI5IUn4wF6k
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/qDWznsnt1WYoG5AQL76A/+Id3kIRBY0cURAMdYD9NSIkHTdwYziN0g
Dcb6RNe5IjFyBze2nKNSwWfCM4jLzfNMB7jyi4vVoJiNCdTv1jryhTCvznstpKPa
sltWEA0aMUqLQWEQWVIKlcltt8Fsu2DwNjTiYlCDx7vLMucbHp4ZRtR3cmLYwtwW
53BIfWXohkBS6faW6T7+ayN41booUu7di97QbqtCzNF8LAicVOX+JM0A7o2tfgUd
SY+0X1AO/Kup0H3iV9Lxgt6lzI2L9mJsdX8nVLYk9t3C0x/u/kkh8hwrFiQ0edf5
dIkgh9qGqX0KjSEN8VWhCzFdGBv/Y1Wvm+wyrcFnl9HI27DjzmN2b54pb+L7rhtq
w32BdJEEeKGIcG3EERVtSZ+8TkyUyfD9WLbgMxnyZnOXCtQnr6v/xsnhK6fCoCAs
TUK9ycJY2RohW4ZcTeNXUKPF7L7XfV42ggObZ8U2TIXce6Wu0uVhJ18ukfChFktU
WW27uwciwDCf5dG6/4mrEib9zsyKSe+xf2VDjSqYz9ld48dbG54sUv1Jzs+uDz/F
jK2LvL3B1XXkm8510+189zPIVfd8yluhrktYkHbGfqS1CU2eD2GoncPiZP0T42Zz
QqTX5Ch6H1tt35MJZ6AL1L06XpyrdHOoa+gJe1+zQYHvrJNk5C2R14KNjvet2/99
WR5EWQgIOgM=
=GAY/
-----END PGP SIGNATURE-----

--Sig_/Y7llNzDtm/o6XI5IUn4wF6k--
