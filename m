From: NeilBrown <neilb@suse.de>
Subject: Re: Assembly failure
Date: Wed, 11 Jul 2012 12:43:16 +1000
Message-ID: <20120711124316.206ab3d9@notabene.brown>
References: <20120710163345.GB29855@nsrc.org>
	<4FFC5CC0.8050808@profitbricks.com>
	<20120710170646.GA29962@nsrc.org>
	<4FFC68AB.4010801@profitbricks.com>
	<20120710185927.GA30164@nsrc.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/z4T4UQQa/xmPsosg0Vd4adY"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120710185927.GA30164@nsrc.org>
Sender: linux-raid-owner@vger.kernel.org
To: Brian Candler <B.Candler@pobox.com>
Cc: Sebastian Riemer <sebastian.riemer@profitbricks.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/z4T4UQQa/xmPsosg0Vd4adY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Jul 2012 19:59:27 +0100 Brian Candler <B.Candler@pobox.com> wrot=
e:

> On Tue, Jul 10, 2012 at 07:38:51PM +0200, Sebastian Riemer wrote:
> > Your kernel is similar to v3.4 mainline. Your kernel has been compiled
> > one day after Linus tagged v3.4. This kernel has major issues. Please
> > reboot into the old 3.2 kernel.
> >=20
> > Your kernel has no tag in the Ubuntu Git repos!
> >=20
> > http://kernel.ubuntu.com/git?p=3Dubuntu/ubuntu-precise.git;a=3Dtags
> > http://kernel.ubuntu.com/git?p=3Dubuntu/ubuntu-quantal.git;a=3Dtags
> >=20
> > Your kernel is absolutely unstable. Who built this kernel? Can't be
> > official release!
>=20
> I don't know who makes ~kernel-ppa packages.
>=20
> Anyway, box is now on linux-image-3.2.0-24-generic. Same problem:
>=20
> brian@dev-storage1:~$ cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [rai=
d4] [raid10]=20
> md127 : inactive sdm[1](S) sdg[5](S) sdh[4](S) sdd[3](S) sdj[9](S) sdl[11=
](S) sdi[8](S) sdk[10](S) sdb[0](S) sde[7](S) sdf[6](S) sdc[2](S)
>       35163186720 blocks super 1.2
>       =20
> unused devices: <none>
>=20
> What's my best next step? There's nothing critical on here, but I would l=
ike
> to use this as practice of recovering a broken md raid volume.
>=20

mdadm -S /dev/md127

Then assemble again with "--force" as you expected.

Don't try to --create --assume-clean, it isn't needed.
And don't worry too much about the kernel - though keep away from any Ubuntu
3.2 kernel before the one you have -there is a nasty bug (unrelated to your
current experience) that you don't want to go near.

When you re-assemble it won't include all the devices in the array - just
enough to make the array functional.  You would then need to add the others
back in if you trust them.


As others have suggested, there is probably some hardware problem somewhere.
It looks like sdr failed first, around "Jul  3 04:21:50 2012".
The array continued working until about 06:36 when sdu then sds failed.
Since then it doesn't look like much if anything has been written to the
array - but I cannot be completely certain.

Do you have kernel logs from the morning of 3rd July?

NeilBrown

--Sig_/z4T4UQQa/xmPsosg0Vd4adY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/zoRDnsnt1WYoG5AQKbUQ//f7ozHdBCBUVu2pej0Ri16TjeIRlYY1B2
Wq7tjZGTOoTa5XuIYR21UD5y5XPFErjweoYdzsIiZ5NbHRKHrwVBRw0AppVflAPc
xqWZdgKQOoFeNPxYVka3Hu3w1WUVgTJxa3bhz7hrH2dneLC2ENpA/2yizdLC8ODU
8E3ry0RSB6GndbJLLhUom/VdGYugq9MKf1e7FT0wMQs+RUP7qPtG+z2WI/6H1qCs
P/j+0TQxCICbqt4va0vGC8PXt5xmy+oGUoUn0J9hvVMQ8Bt8wAE4QlB+VW9wqJ3d
CSSeT8sT2EzqVDQkqYVxI+XteTXlMrQz9ScFXbIVjbliNS/NtqnmJHCvy9LkbJ61
flqfuqYGGRodD37roxh+9XoB+z+tbbM5nmGhpuUSdif57KkxWRG5SITNmG2iYXx4
k3MeDVOVzL5ZLbQzoEJmUTvPqmYBqfntTm4h/xB3MmJnLrd/GVISrrAngLmZgEKB
05rawVxwi6MirKxv11Dlf9VxqJOXe/aRBuD+sJV6EGB+m9BZtXr4iAEbtiqGXX2G
B8L+svks7FW6eeBr8fTTwHE4JNVmuEqXKV+d/WMM4C5VTLUq6zcES8JV3Z+2c5Oh
XpwCgmRJ9rPZVSP+teFXyj9jOhP1KwaTnkFt9y9mCY0KKB9lGPzAOhA8H5MpO/xl
I3lrieXgGNo=
=9DTX
-----END PGP SIGNATURE-----

--Sig_/z4T4UQQa/xmPsosg0Vd4adY--
