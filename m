From: NeilBrown <neilb@suse.de>
Subject: Re: RAID5 superblock and filesystem recovery after re-creation
Date: Mon, 9 Jul 2012 10:02:08 +1000
Message-ID: <20120709100208.5b9c56cd@notabene.brown>
References: <CA+=meHXO02k4hSJihNFiYXb+LOjik_LX3n8UZbqERC2tYy+L-g@mail.gmail.com>
	<20120709081358.199630c8@notabene.brown>
	<CA+=meHVhYu8Z5a+D5beWQ-4M7YXq1bCabsqqntMMKfFy5dqAPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/NAGIOcA_9lgcjf_v_MQAZgt"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+=meHVhYu8Z5a+D5beWQ-4M7YXq1bCabsqqntMMKfFy5dqAPA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Schleifer <alexander.schleifer@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/NAGIOcA_9lgcjf_v_MQAZgt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Jul 2012 00:45:08 +0200 Alexander Schleifer
<alexander.schleifer@googlemail.com> wrote:

> 2012/7/9 NeilBrown <neilb@suse.de>:
> > On Sun, 8 Jul 2012 23:47:16 +0200 Alexander Schleifer
> > <alexander.schleifer@googlemail.com> wrote:
> >
> >> Hi,
> >>
> >> after a new installation of Ubuntu, my RAID5 device was set to
> >> "inactive". All devices were set to spare device and the level was
> >> unknown. So I tried to re-create the array by the following command.
> >
> > Sorry about that.  In case you haven't seen it,
> >    http://neil.brown.name/blog/20120615073245
> > explains the background
> >
> >>
> >> mdadm --create /dev/md0 --assume-clean --level=3D5 --raid-disk=3D6
> >> --chunk=3D512 --metadata=3D1.2 /dev/sde /dev/sdd /dev/sda /dev/sdc
> >> /dev/sdg /dev/sdh
> >>
> >> I have a backup of the mdadm -Evvvvs output, so I could recover the
> >> chunk size, metadata and offset (2048) from this information.
> >>
> >> The partially output of mdadm --create... shows this output:
> >>
> >> ...
> >> mdadm: /dev/sde appears to be part of a raid array:
> >>     level=3Draid5 devices=3D6 ctime=3DSun Jul  8 23:02:51 2012
> >> mdadm: partition table exists on /dev/sde but will be lost or
> >>        meaningless after creating array
> >> ...
> >>
> >> The array is recreated, but no valid filesystem is found on /dev/md0
> >> (dumpe2fs: Filesystem revision too high while trying to open /dev/md0.
> >> Couldn't find valid filesystem superblock.). Also fdisk /dev/sde shows
> >> no partition.
> >> My next step would be creating Linux RAID type partitions on the 6
> >> devices with fdisk and call mdadm --create with /dev/sde1 /dev/sdd1
> >> and so on.
> >> Is this step a possible solution for recovering the filesystem?
> >
> > Depends.. Was the original array created on partitions, or on whole dev=
ices?
> > The saved '-E' output should show that.
> >
> > Maybe you have the devices in the wrong order.  The order you have look=
s odd
> > for a recently created array.
> >
> > NeilBrown
>=20
> The original array was created on whole devices, as the saved output
> starts with e.g. "/dev/sde:".

Right, so you definitely don't want to create partitions.  Maybe when mdadm
reported "partition table exists' it was a false positive, or maybe old
information - creating a 1.2 array doesn't destroy the partition table.

> I used the order of the 'Device UUID' from the saved output to
> recreate the order in the new system (the ports changed due to a new
> mainboard).

When you say "the order", do you mean the numerical order?

If you looked at the old "mdadm -E" output matching the "Device Role" with
"Device UUID" to determine the order of the UUIDs, then looked at the
"mdadm -E" output after the metadata got corrupted and used the "Device UUI=
D"
to determine the correct "Device Role", then ordered the devices by that Ro=
le,
then that should have worked.

I assume you did have a filesystem directly on /dev/md0, and hadn't
partitioned it or used LVM on it?

NeilBrown


>              After the installation I had a degraded array in
> initramfs, but I was able to simply "exit" the debug shell and the
> array was accessible. I will now skip the step of creating raid type
> partitions and try every possible order of devices.
>=20
> Thanks,
> -Alex


--Sig_/NAGIOcA_9lgcjf_v_MQAZgt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/ofgDnsnt1WYoG5AQJ0fg/+K8Kai+bKfNnvnx9uP+4cGAwMGJlkji0q
wMcf6tUc8u4gyFmgE7/RoNQH6ONQL4fSdivt1gWytVq28NhlN9wzNlDPsFM0F+wT
0jSW8TCgqOUjishpSOgVD0SB9SlUtppL02X4IFeQu78o3Hj6qxHJlW922XukfFQM
5Sp3JwykjOOinz37ZGkZq/fPKq5+osqZSp2JD/kSd+osrXab/EKK+2u0AfVi9qLC
lF2YZRL1nNduc5cfe1oU2WcXqW8hqfjkCLnq/xwLF5juNuWGHWQ0kPfAFkjMjXlO
Mp6V2HDLrGc72QVNn6xyRhdxG3GW/O94KUfn9hq2NLWkgxKSCG0WMZim1eR4gB3F
VzWGcOgkiZB5+s/EoqL/aib09M1oKeuapLYIxBalbHhq3Mkms9gnbhcgcyVb/ixb
iYjawZ2I8XGgPC9zLpYvYJACJp4+3aQEcqsWzkYr96z7WCVzP2nm653rzieEfWgb
cjlkVCNbFtlNEcQ+fqAAuoefKo8G8fUM+Yz/IpzmF8gh/lq3ISyyibxMK9im+C1F
Mfw9P9q/OvjUY0E/CCX7IZ1MxDimdEatOKKMFpMO3f+lQQTcsjaIjyWTGhMuZTJR
6E5hnJmcoTsMWDZzAaLLo8wPNtrm7lF39JtvwBSSm+FzzMIv/2KFSGbFQldrOrT7
nte2jrkvabI=
=Ldd+
-----END PGP SIGNATURE-----

--Sig_/NAGIOcA_9lgcjf_v_MQAZgt--
