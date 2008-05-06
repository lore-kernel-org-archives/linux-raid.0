From: Markus Hochholdinger <Markus@hochholdinger.net>
Subject: Re: Resize / file system and create /home in existing raid 1
Date: Tue, 6 May 2008 11:26:24 +0200
Message-ID: <200805061126.24896.Markus@hochholdinger.net>
References: <5a3dd2390805051335s7b163505w5d94206dcb56b8a4@mail.gmail.com> <18463.33260.564139.783585@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1575444.nzK6NSDVbg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18463.33260.564139.783585@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--nextPart1575444.nzK6NSDVbg
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

Am Montag, 5. Mai 2008 23:53 schrieb Peter Grandi:
[..]
> Resizing is dangerous, shrinking is very dangerous, and most
> filesystems don't support shrinking anyhow.

is there any documentation why resizing is dangerous?

I'm using a lot of RAID1 with ext3 ontop in my virtual servers and i resize=
=20
(grow) the RAID1 and ext3 filesystem as i need more space without=20
interrupting.
I've done this very often (more than 50 times) for a long time (for about 2=
=20
years) and never had any problems. I also do sometimes fsck to check if=20
something went wrong (i can do this without interruption because my RAID1=20
partitions are managed with lvm, and so, i do snapshots and make the fsck o=
n=20
the snapshots).
I've done shrinking not that often because i don't know a filesystem which =
can=20
shrinking online (ext3 and reiserfs can be shrinked offline). But as i've=20
testet shrinking with ext3 it's for me also very stable. Shrinking reiserfs=
=20
(offline) doesn't work reliably and i use reiserfs only on my backup space.=
=20
But shrinking RAID1 is not possible without recreating the RAID1, means=20
shrinking RAID1 is not possible online.


=2D-=20
greetings

eMHa

--nextPart1575444.nzK6NSDVbg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIICRAXT3LE+AjWCsRAnQGAJ0fig9tlyaLK/yq6VdnDHLVJ1ekNACgkKzs
efcRoFMj7FDT91geDQJ7nFc=
=1984
-----END PGP SIGNATURE-----

--nextPart1575444.nzK6NSDVbg--
