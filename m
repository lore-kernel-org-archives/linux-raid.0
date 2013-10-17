From: NeilBrown <neilb@suse.de>
Subject: Re: Problem diagnosing rebuilding raid5 array
Date: Thu, 17 Oct 2013 13:39:36 +1100
Message-ID: <20131017133936.7028c02f@notabene.brown>
References: <20131014123104.77620e8uy2pe0214@phobos.elinuxservers.com>
	<20131016171157.7655fe31@notabene.brown>
	<20131016222754.15765kbm152z5skc@phobos.elinuxservers.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/OhaYbxHGlR.a4q=hPYbxQ40"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131016222754.15765kbm152z5skc@phobos.elinuxservers.com>
Sender: linux-raid-owner@vger.kernel.org
To: peter@steinhoff.se
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/OhaYbxHGlR.a4q=hPYbxQ40
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 16 Oct 2013 22:27:54 -0400 peter@steinhoff.se wrote:

> Thanks Neil,
>=20
> I've checked the drives and sdd had unrecoverable read errors which =20
> was the reason that the rebuilding of sdh failed in the first place.
>=20
> Then I made a clone of sdd with ddrescue and it looks like only 4096 =20
> bytes was completely unreadable.
>=20
> Then I did the --force assemble as you suggested using the 3 good =20
> drives and the cloned sdd. I ran e2fsck after that and temporarily =20
> mounted the array to check that it looked OK.
>=20
> Now I've added sdh again and the rebuilding process is underway. =20
> Hopefully it will complete.
>=20
>=20
> I was just wondering but since I lost 4kB of data when I cloned sdd, =20
> does that mean that I will have 4x4kB of garbled data somewhere since =20
> I assembled 4 drives (n-1) and the raid system wouldn't know? Or would =20
> that have been detected somehow when I ran fsck (ext3)?

You could have 2*4kB of garbled data (the block you lost, and the
corresponding block on the device that was rebuilt).
Or you could have 1*4kB, or 0*4kB garbled if either the corrupted block or
the recovered block were parity blocks.

Those bad blocks are not likely in filesystem metadata else fsck should have
noticed.  They could be in some file(s), or in some free space - in which
case you'll never notice.

NeilBrown

--Sig_/OhaYbxHGlR.a4q=hPYbxQ40
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUl9N6Dnsnt1WYoG5AQKg5xAAvfoKmE5Kemb53f1Wgp1RFI5oB9B8Yxm9
Xms6O839Fd8uA/JD+Y9LNFyjRBcYJcjUobIdxt4kevqKgUWKXOTGSbPa65vdUOnX
uK9LOhizm0bfjZzZiHgOA/s/fgAc1vY3HuO0O6khoDdrqCo9r/HB72Awm2yRzf2P
ivt7ne6wOWJdi9QB+xWJUKmc8kl9HjntuL5prOiIDr6r2yXA7MDAAT+1cpqoFbA6
H/6rXgkIgrtfG5mggBobYbvcQdB60BA4hQ8Hd5cFQM9A7PQBLn/pppPAKElWJZP/
WcSoiCuI9QbNStXKM8Idh3/l05kIppzrXkioOYZ3Od3KzE1jreWsjsIoHBIjrT2x
dFAIjth6JAm/ZNi/dC1SNwoKRjEf4vRb/6Bz9xK3/xl7wpiz9p0e31KXIcN32P2j
jJq95ISS+h0XhF09Cc6PBZx/IH4Q+IwWm1gDrRMvYqETtOUk3rs3ai5MDSuXnKBj
t4o+JcaY9CBgH0IOe98RU3DoSALpiJq8lQHM6o/xWCLEBkP/e5y/lZPSA1EBXsqa
QJP0lm+jzQPJM1P2DOiSox3B7K1BPflZz/cB+4v0xmQz47wEWlXmghosdNhXFfB+
11pc7NN9b2KdKyKFWveMl5nyui8l8IRbcDXV6VrWbCNM1+O9JiSUZzWg9a5fTFSl
Z/fYvU711Fk=
=5pfa
-----END PGP SIGNATURE-----

--Sig_/OhaYbxHGlR.a4q=hPYbxQ40--
