From: Martin Hermanowski <martin@mh57.de>
Subject: Re: Crashing a software raid 5 partition ( disk trouble )
Date: Thu, 12 Jun 2003 12:26:17 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030612102617.GI19328@mh57.de>
References: <007201c330b9$c316f310$3001a8c0@melkor>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5I6of5zJg18YgZEa"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <007201c330b9$c316f310$3001a8c0@melkor>
To: Nicolas Meaux <nicolas.meaux@artabel.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--5I6of5zJg18YgZEa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2003 at 10:08:09AM +0200, Nicolas Meaux wrote:
[lost 2 members of a raid5]
> In the FAQ i read :
>=20
> In short: quite often you get a temporary failure of several disks at onc=
e;
> afterwards the RAID superblocks are out of sync and you can no longer init
> your RAID array.
> One thing left: rewrite the RAID superblocks by mkraid --force
>=20
>=20
> But when i type this command, i have :
> DESTROYING the contents of /dev/md2 in 5 seconds, Ctrl-C if unsure!
>=20
> And i am very afraid off this , i dont want to loose my data.
> ( my /etc/raidtab is conform as my raid architecture )
>=20
> Finally, i would like to say, that i have backup the most important data,
> but not all the data.
>=20
> So, the question is : is there any way to restore my raid partition or
> recover data on it ?
> Or did i have loose everything ?

I did a `mkraid --force' once, after two two hdds locked up nearly
simultaneously. It worked.

But I do not know what happens if one disc has been out of the raid for
a longer time.

LLAP, Martin

--=20
pgp-key: https://mh57.de/cc/view.php?file=3D/martin/pgp

--5I6of5zJg18YgZEa
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+6FVJmGb6Npij0ewRAuEyAJ9ew8CCPm4MNaasc5ck3EEohMoOiwCeLBtj
7z2M61FVjydKNWtydhg2epk=
=sTII
-----END PGP SIGNATURE-----

--5I6of5zJg18YgZEa--
