From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Incorrect in-kernel bitmap on raid10
Date: Mon, 20 Apr 2009 00:55:56 +0200
Message-ID: <20090419225556.GC14157@darkside.22.kls.lan>
References: <slrnguk663.8bq.Mario.Holbe@darkside.dyn.samba-tng.org> <18922.50050.860008.242658@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S1BNGpv0yoYahz37"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18922.50050.860008.242658@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--S1BNGpv0yoYahz37
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 19, 2009 at 04:24:02PM +1000, Neil Brown wrote:
> On Saturday April 18, Mario.Holbe@TU-Ilmenau.DE wrote:
> > I created a 4.5T RAID10 with internal bitmap out of 3 1.5T disks on a
> > and I get a strange inconsistency between the on-disk and the in-kernel
> > bitmap representation:
> Could you let me know if that following patch helps?

I attached the patch to 2.6.28 because of the still pending .29-fix.
It looks better but not perfect, if you ask me:

root@darkside:~# mdadm -G -b internal /dev/md7
[  137.605821] md7: bitmap file is out of date (0 < 8382) -- forcing full r=
ecovery
[  137.627777] md7: bitmap file is out of date, doing full recovery
[  137.871855] md7: bitmap initialized from disk: read 9/9 pages, set 26827=
5 bits
[  137.893543] created bitmap (131 pages) for device md7
root@darkside:~# cat /proc/mdstat
Personalities : [raid1] [raid10]
md7 : active raid10 sdc1[0] sde1[4] sdd1[2]
      4395406848 blocks 512K chunks 2 near-copies [6/3] [U_U_U_]
      bitmap: 0/131 pages [0KB], 16384KB chunk
=2E..

It looks like there are now enough pages allocated in-kernel.
So - yes, the patch helps :)

The "read 9/9 pages" message does still look somewhat strange but better
than before (where it was "read 1/1 pages, set 6131 bits") and it seems
to be similar to messages of my other raids.
The "set 268275 bits" message does not seem to be consistent to the
"bitmap: 0/131 pages [0KB]" mdstat, but this is quite likely unrelated
to the original problem.

root@darkside:~# mdadm -X /dev/sd[cde]1 | grep Bitmap
          Bitmap : 268275 bits (chunks), 137203 dirty (51.1%)
          Bitmap : 268275 bits (chunks), 137203 dirty (51.1%)
          Bitmap : 268275 bits (chunks), 137203 dirty (51.1%)

The discrepancy between the "0/131 pages [0KB]" in-kernel and the
"137203 dirty (51.1%)" on-disk seems to be another, unrelated issue.
I experienced somehow similar issues when adding a new component to an
existing bitmapped device. When the full-sync of the new component is
finished, the bitmap on the new component does usually show still lots
of dirty bits (sometimes only a few %, sometimes up to 95%) while the
other devices show 0 dirties. And this doesn't change over time or when
dropping page caches.


Mario
--=20
We know that communication is a problem, but the company is not going to
discuss it with the employees.
                       -- Switching supervisor, AT&T Long Lines Division

--S1BNGpv0yoYahz37
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEVAwUBSeur/BS+e2HeSPbpAQI7iQf/Rbj0Uxy66dsBFOxIkj58V6dr+GCFVzQ6
+/9dZPc8k0fr5Ogg7UwDBR9lr2ShJwMSUVhOMi9H2XVp14eM8l2jyrGR6n3ChGaq
R5Cp6wkC3Vj1d6TYnXM083W0sdDVTMRqa7KIWosqaeOlioIguXBFkw8yUV/1KXD3
OeCQTa7n1x5JE+ED56RDS+MY3QxTYAXHSpVV63xaQ5RzC7mVMtX0lifjTtZPSSX7
AsUOs+HkcnuQFu1ImLmtRyggVOFTo39EkC5uFX/rvz6FEzYlgLW3kHnj4WoCMGli
ktpvGZROEglw/KWEaYpRt62pQ+/nBelFGumNbMYNVB3ryYz9A8ngxw==
=YxtD
-----END PGP SIGNATURE-----

--S1BNGpv0yoYahz37--
