From: NeilBrown <neilb@suse.de>
Subject: Re: Another corrupt RAID5
Date: Tue, 1 May 2012 17:36:02 +1000
Message-ID: <20120501173602.3fe75118@notabene.brown>
References: <4F9F83E2.90407@networklabs.co.nz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rQsSmJWfyUV99qVXkACVyh1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F9F83E2.90407@networklabs.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Thrift <andrew@networklabs.co.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/rQsSmJWfyUV99qVXkACVyh1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 01 May 2012 18:34:10 +1200 Andrew Thrift <andrew@networklabs.co.nz>
wrote:

> Hi,
...

> And the /dev/md0 array is now corrupt.   The /dev/md1 array appears=20
> fine, but obviously without the /dev/md0 that the LV was spanned across=20
> it is not usable.
>=20
> Each drive that was previously in /dev/md0 has the following output:
>=20
> mdadm --examine /dev/sdh1
> /dev/sdh1:
>            Magic : a92b4efc
>          Version : 0.90.00
>             UUID : 00000000:00000000:00000000:00000000
>    Creation Time : Tue May  1 14:44:06 2012
>       Raid Level : -unknown-
>     Raid Devices : 0
>    Total Devices : 2
> Preferred Minor : 0
>=20
>      Update Time : Tue May  1 16:24:56 2012
>            State : active
>   Active Devices : 0
> Working Devices : 2
>   Failed Devices : 0
>    Spare Devices : 2
>         Checksum : bccafbfb - correct
>           Events : 1
>=20
>=20
>        Number   Major   Minor   RaidDevice State
> this     0       8      113        0      spare   /dev/sdh1
>=20
>     0     0       8      113        0      spare   /dev/sdh1
>     1     1       8       81        1      spare   /dev/sdf1
>=20
>=20
> e.g. Raid Level is -unknown- and the UUID is=20
> 00000000:00000000:00000000:00000000
>=20
> This appears to be a quite major bug, is this known, and is there any=20
> way I can recover my data ?

Yes, it is known and fixed in 3.3.4 and elsewhere.
Only the metadata is corrupt, not the data

You should be able to get your data back with

 mdadm -S /dev/md0
 mdadm -C /dev/md0 -e 0.90 -5 -n 4 --assume-clean --chunk 64 \
   /dev/sdf1 /dev/sdg1 /dev/sdi1 /dev/sdh1

Then activate the LVM and check the filesystem just to be sure before doing
anything that would write to the array.

I'm guessing the '64K' chunk size - I think that was the default when 0.90
was the default.  Maybe you know better or have some old copy of
"/proc/mdstat" output to check.
I think the order of devices is correct.  I got it from

> May  1 00:09:37 blackbox kernel: [ 3712.863217] RAID conf printout:
> May  1 00:09:37 blackbox kernel: [ 3712.863222]  --- level:5 rd:4 wd:1
> May  1 00:09:37 blackbox kernel: [ 3712.863225]  disk 0, o:0, dev:sdf1
> May  1 00:09:37 blackbox kernel: [ 3712.863227]  disk 1, o:0, dev:sdg1
> May  1 00:09:37 blackbox kernel: [ 3712.863229]  disk 2, o:1, dev:sdi1
> May  1 00:09:37 blackbox kernel: [ 3712.863231]  disk 3, o:0, dev:sdh1

Note that you also seem to have a serious problem with your drives or
controllers that is producing IO errors.  This is nothing to do with md,
but it probably making it more likely for the md but to hurt you.

To avoid the md bug (until you can get a bug-free kernel) it is safest to
stop all md arrays before rebooting or shutting down.


NeilBrown


--Sig_/rQsSmJWfyUV99qVXkACVyh1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5+SYjnsnt1WYoG5AQI0kg//VDxbKDrbNJz0nAq4HWnxhWd38PBNJ1ac
5u9AQV6H05aUVjaZSmnw8H+PgYvbiS+F9zca1MiWfU+xlktXmdkExutd+mrvqJVH
4GQbfZjsKepGzC9u874KaY54eoDY03Z8hzP0/t3Qxhn8xOP5FcXHfgL//Cprx03W
4/b2TEiFN/BfaHXafkmNy4w2TajK8KE620y3kBU12uJ3/8PVrxOA5MG3+EihQ117
JrMlUXvRjJWEJLPDIUWdR/cZgI+0bbHYF6cvee019kz/DBWPhygXiz6taoiLAy+Y
ofE4mhs5FBlDsLMxkm8ltuMVqPHMsf/cEXXUBfqPkHwGht1+RQ93bfhlM0mzbrr1
4Sz/jdl/cIG8vwAbFelOS6BXJ1vDGFLOCnMFsA3r6cV6EVv1iy6tnN6EIbEyLLQn
eM2WWaVjXFvWJdhEfS0PpORLTDtkPFnZwdupvAmQyx/G4NiW66FPw5d2aZ76C03H
c8yy3n9d+mbiY6HIrblpZHz586dkHgo48C8y0qxOqqbYa61e+oS1Xf7Z5IExJph6
7wG4AMTYGn3rNhK4inUS2wYij6+RsxLe17lJopLVOOZ2e6SUr0tOFQAKbN7Jh1hz
p7fqUQSAp7HoVZvCLP2zM27fHowtxZVcTsHAnktIXOaix2I8Yfb/1yCpXyJwVVuW
sQJKpTeVOP0=
=Ja9p
-----END PGP SIGNATURE-----

--Sig_/rQsSmJWfyUV99qVXkACVyh1--
