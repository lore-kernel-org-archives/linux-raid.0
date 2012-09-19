From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Can't reshape RAID1 to RAID5 due to chunk size
Date: Wed, 19 Sep 2012 13:46:01 +0600
Message-ID: <20120919134601.0671d75f@natsu>
References: <20120912105956.155f5d5e@natsu>
	<20120919162058.3101366d@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/24/3NvmYNkI6kwYffM2XDNa"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120919162058.3101366d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/24/3NvmYNkI6kwYffM2XDNa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 19 Sep 2012 16:20:58 +1000
NeilBrown <neilb@suse.de> wrote:

> What you need to do is:
>   - make sure the filesystem in /dev/md1 doesn't use the last 3k (it prob=
ably=20
>     uses a 4K block size, so cannot use that last bit
>   - resize the array down to 488372860K  (mdadm -G /dev/md0 --size 488372=
860)
>   - convert to a 2-device RAID5 with a 4K chunk size:
>       mdadm -G /dev/md1 -c 4K -l5 -n2
>   - convert to a 3-device RAID5 with a 64K chunk size:
>       mdadm -G /dev/md1 -c 64k -n3
>=20
> NeilBrown

Thanks, Neil.

I have since finished this migration in another way, luckily I had some spa=
re
drives lying around, so had an option to create a separate RAID5 from scrat=
ch
and move over & replace the drives one by one.

By the way the "want_replacement" feature is totally awesome, thanks to it =
at
no point in my operations I was left without redundancy (after all a N-disk
degraded RAID5 reliability-wise is like a RAID0 of N disks, and that's
something I wanted to avoid having even for a short period).

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/24/3NvmYNkI6kwYffM2XDNa
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlBZeDkACgkQTLKSvz+PZwgkYQCfUy/WnL9H9kC1Sc1FFw7425dW
qcMAnAjwa7p1y8USSdKAeJM8dVhQEgPQ
=iz6U
-----END PGP SIGNATURE-----

--Sig_/24/3NvmYNkI6kwYffM2XDNa--
