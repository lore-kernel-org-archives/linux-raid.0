From: NeilBrown <neilb@suse.de>
Subject: Re: Please Help! RAID5 -> 6 reshapre gone bad
Date: Tue, 7 Feb 2012 15:25:01 +1100
Message-ID: <20120207152501.5541d379@notabene.brown>
References: <CAOANJV-V8ZTXBvQxxMnEnv24p8A-fAas-6x65ifW5yp35ZqHnA@mail.gmail.com>
	<20120207133947.5c4b9a59@notabene.brown>
	<20120207141023.22cce706@notabene.brown>
	<CAOANJV_jC_jvUuNuB96ARwJDyg1KAR1ind6uvjTFb4pfuyaHag@mail.gmail.com>
	<20120207143941.58c3ccb6@notabene.brown>
	<CAOANJV_giURCH_yi8fMyKGpQ-uRSzF9iwOoV-_qO5sAASvYWwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/I8ZCFguVXNq7QcTfxd5Q06U"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOANJV_giURCH_yi8fMyKGpQ-uRSzF9iwOoV-_qO5sAASvYWwA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Herd <2001oddity@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/I8ZCFguVXNq7QcTfxd5Q06U
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Feb 2012 14:50:57 +1100 Richard Herd <2001oddity@gmail.com> wrote:

> Hi Neil,
>=20
> OK, git head is: mdadm-3.2.3-21-gda8fe5a
>=20
> I have 8 disks.  They get muddled about each boot (an issue I have
> never addressed).   Ignore sde (esata HD) and sdh (usb boot).
>=20
> It seems even with --force, dmesg always reports 'kicking non-fresh
> sdc/g1 from array!'.  Leaving sdg out as suggested by Phil doesn't
> help unfortunately.
>=20
> root@raven:/neil/mdadm# ./mdadm -Avvv --force
> --backup-file=3D/usb/md0.backup /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1
> /dev/sdd1 /dev/sdf1 /dev/sdg1
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 2.
> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 3.
> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 5.
> mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 4.
> mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 0.
> mdadm:/dev/md0 has an active reshape - checking if critical section
> needs to be restored
> mdadm: accepting backup with timestamp 1328559119 for array with
> timestamp 1328567549
> mdadm: restoring critical section
> mdadm: added /dev/sdg1 to /dev/md0 as 0
> mdadm: added /dev/sda1 to /dev/md0 as 2
> mdadm: added /dev/sdc1 to /dev/md0 as 3
> mdadm: added /dev/sdf1 to /dev/md0 as 4
> mdadm: added /dev/sdd1 to /dev/md0 as 5
> mdadm: added /dev/sdb1 to /dev/md0 as 1
> mdadm: failed to RUN_ARRAY /dev/md0: Input/output error


Hmmm.... maybe your kernel isn't quite doing the right thing.
 commit 674806d62fb02a22eea948c9f1b5e58e0947b728 is important.
It is in 2.6.35.  What kernel are you running? =20
Definitely something older given the "1: w=3D1 pa=3D18...." messages.  They
disappear in 2.6.34.

So I'm afraid you're going to need a new kernel.

NeilBrown




>=20
> and dmesg:
> [13964.591801] md: bind<sdg1>
> [13964.595371] md: bind<sda1>
> [13964.595668] md: bind<sdc1>
> [13964.595900] md: bind<sdf1>
> [13964.599084] md: bind<sdd1>
> [13964.599652] md: bind<sdb1>
> [13964.600478] md: kicking non-fresh sdc1 from array!
> [13964.600493] md: unbind<sdc1>
> [13964.612138] md: export_rdev(sdc1)
> [13964.612163] md: kicking non-fresh sdg1 from array!
> [13964.612183] md: unbind<sdg1>
> [13964.624077] md: export_rdev(sdg1)
> [13964.628203] raid5: reshape will continue
> [13964.628243] raid5: device sdb1 operational as raid disk 1
> [13964.628252] raid5: device sdf1 operational as raid disk 4
> [13964.628260] raid5: device sda1 operational as raid disk 2
> [13964.629614] raid5: allocated 6308kB for md0
> [13964.629731] 1: w=3D1 pa=3D18 pr=3D6 m=3D2 a=3D2 r=3D6 op1=3D0 op2=3D0
> [13964.629742] 5: w=3D1 pa=3D18 pr=3D6 m=3D2 a=3D2 r=3D6 op1=3D1 op2=3D0
> [13964.629751] 4: w=3D2 pa=3D18 pr=3D6 m=3D2 a=3D2 r=3D6 op1=3D0 op2=3D0
> [13964.629760] 2: w=3D3 pa=3D18 pr=3D6 m=3D2 a=3D2 r=3D6 op1=3D0 op2=3D0
> [13964.629767] raid5: not enough operational devices for md0 (3/6 failed)
> [13964.640403] RAID5 conf printout:
> [13964.640409]  --- rd:6 wd:3
> [13964.640416]  disk 1, o:1, dev:sdb1
> [13964.640423]  disk 2, o:1, dev:sda1
> [13964.640429]  disk 4, o:1, dev:sdf1
> [13964.640436]  disk 5, o:1, dev:sdd1
> [13964.641621] raid5: failed to run raid set md0
> [13964.649886] md: pers->run() failed ...

--Sig_/I8ZCFguVXNq7QcTfxd5Q06U
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzCnnTnsnt1WYoG5AQKrOA//ZD+RlUhTz9NFtxXIrgIfVPtufNw/olIn
fFuK1TYD6RUkl0cH8Fbw7CYcPzp/UxsB70544kxzjZeBcHdnK+djOuPQSGzyDrae
K9oEjKwEZ1JlFKSvcO7ZyXqCDSijSAYTSnoIEc9g7iM5libDwYb62YiQM4QcXKd9
vf/8FXhMJsCLCU22EWLHQzCBcDPKyecNWGjPX6Jnlae3nFowkWC2RpSr0SIrePv/
pOzvlmLdO9QNuy/V5fIAN69wyCw4alr6jzqNfUzhehVFIhT34EjTwkxNVk8eykX9
ujRFKFEwmXyMmQ4+wgKP73oHRxR8VJji4/jFJkNqUmw60T2+hFfpIgA2CE6VlAbd
vjPUmepeB7cbP5/LcgYPMYnIKLUyfEUwQLdmDWhcIWo5UHP5Zh1aXqfoAqALF1cx
BuLx3EL5BLSdpNx8OBUD1p007dnhGzAZ6TgqAVQM75GA7+7DNpPxnTLgRXK3XicW
492JaKezaXQ15TTvxUwGv0UB1HOW2/w+xF5d7ppktqx5bqSvsP/tY4MxZJegCbZW
WgfAETYu245EUFPMoteuueFwOdGQDbLwCp4lKFkOwmxGwj8qXu1eJvXFk09qkGQW
DH4WvOFDhNf5gtORlBDqocrSZKSKlmn85gmUc7ffpotXZyc4MkIOkN387xYt0rgR
L9ZVdWr3anQ=
=hxuj
-----END PGP SIGNATURE-----

--Sig_/I8ZCFguVXNq7QcTfxd5Q06U--
