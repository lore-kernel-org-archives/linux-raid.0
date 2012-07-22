From: NeilBrown <neilb@suse.de>
Subject: Re: Question about how to migrate raid0 to raid5
Date: Mon, 23 Jul 2012 09:22:43 +1000
Message-ID: <20120723092243.57af5e33@notabene.brown>
References: <5007B30A.8070709@freescale.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5EfJQ9ymJd3WI65t_ZvNdc+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5007B30A.8070709@freescale.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhang Jiejing <b33651@freescale.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/5EfJQ9ymJd3WI65t_ZvNdc+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 19 Jul 2012 15:11:06 +0800 Zhang Jiejing <b33651@freescale.com> wro=
te:

>   Hi Neil Brown,
>=20
> Sorry for interrupt you.
>=20
> I'm using linux md raid0 in my server, and it's working very good unless=
=20
> it's outof space recently.
> Thanks for you good job.
>=20
> I have two question about linux md,
> 1. the first one maybe a common one:
>      I install my server /home dir as RAID-0 for speed, this server is=20
> usually to code build and development, but recently I need add a 2TB HDD=
=20
> to this md, and I found add disk on RAID-0 is not supported, but I found=
=20
> there will maybe a way to convert my RAID-0 to RAID-5, and then add=20
> other disk on the RAID-5  (I don't covert it back).
>=20
> I sow some patch about md takeover:
> like
> md/raid4: permit raid0 takeover
> md: Fix dev_sectors on takeover from raid0 to raid4/5
>=20
> But I'm a newbie about linux md, can you give a some guide about how to=20
> do this or it was not supported ?

If you use a recent kernel (3.4) and a recent mdadm you should be able to
grow a RAID0 array.  It will be converted to RAID5, reshaped, then converted
back.
I recommend creating some 'loopback' devices to experiment with just to make
sure it works.
i.e. create 4 big files, use "losetup /dev/loop0 filename" etc to create 4
loopback devices.  Create a RAID0 over 3 of those, then try to add a device.
The command is:
   mdadm --grow /dev/md0 --raid-devices=3D4 --add /dev/loop3

or similar.

>=20
> My kernel version: Linux  2.6.38-15-server #64-Ubuntu SMP Fri Jul 6=20
> 19:08:52 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
>=20
> mdadm - v3.1.4 - 31st August 2010

You'll definitely need newer kernel and mdadm.


>=20
>=20
> 2. the second question is about radi0.c : create_strip_zones() function,
> this function will scan mddev->disks  and check them EQUAL size or not,=20
> can you give me some guide about where this disks passed to this mddev ?
>=20
> The reason I ask this question is, I add a new HD, and partition two=20
> "Linux raid autodetect" partition on this disk, but I don't know how to=20
> add this disk to md1.
>=20
> So I type:
>   mdadm --add /dev/md1 /dev/sdc
> and report -EINVAL error.

You cannot add a device to a RAID0 - there is nowhere to put it.
To grow a RAID0, you give the --add in the same command as the --grow, as
above.



>=20
> I first tough is I caused by my partition not right, so I partition my=20
> sdc to 2 partition, with partition type is "Linux raid autodetect".
>=20
> and found also failed, so I did some google, and found RAID-0 don't=20
> support add disk online.
>=20
> After did a ubuntu "do-release-upgrade", and reboot, I found kernel will=
=20
> check /dev/sdc, looking at sdc, and then failed to create the zone.
>=20
> After remove the HD in BIOS, I can success mount the md1 again, so my=20
> question is do I need do some mdadm command to remove the /dev/sdc in my=
=20
> md1 (maybe it record the device node in some where ?)
>=20
>=20
> Thanks for you advance.
>=20


NeilBrown

--Sig_/5EfJQ9ymJd3WI65t_ZvNdc+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAyLQznsnt1WYoG5AQKphw/8Cn1QzpKj5DoAW3MdgJsIiQyG4VN34Yj1
WwS3QCqIxV1Mhn5z/OYB4eK2eyhr4Mc2dsXsgc/ePxuaEVGYRLKE6sHbAPTtOA1I
7hevLwQoMnoXW9v6dUO5b1sWqX+U/TwSMz9iAkx8tB3PSg8msnDUyvtfdm/KFKwI
bGx/x34mY2o5OmuIoXe9U69jB6DN7t+tql3cfkTChM3nlI1seKKhHeU+E3RjBPqL
l+Er+rN3Ejqs9uVFLNt7rFVY1SDA+NuV68Y2LkewVYNcAbeUyjkAN6nJdcyMZGZz
OY4mQuS0NlCsitZSFXm2WEVB1HiLshN0lTl7wRPv6UgfCWjb6n1hkbzK0ylZKPZf
TiQj4rCFvpralCxZrJ6UIKXNA640FhPfctgRPXFUXjuLH51+BJ/0XusVhTJeapXI
E8qZp3RGtiiQPrCZ2q3Fh9UZy+d6Kcf81YcnTJFcRF5wibwJXrZ1fN7sK+uszIly
1d1qdtCOzknbAys/BD9fKNto1/KTJtIrLz/hYSiBs/vPc8m/xTzM2DWlpMkbHt6P
tAn+STUpqR8GBaZCVXdqHV/JkDpIgkhvxQrrs/mm++x/Po00es7wfbiX1T5bX9IE
/3tYMNAT7pLg90sclo06iD/mNt70bq8d1bkbyroviWjpcX+sjo3f7MQvZ8kH+W60
+pUUx6u9qwA=
=dHAy
-----END PGP SIGNATURE-----

--Sig_/5EfJQ9ymJd3WI65t_ZvNdc+--
