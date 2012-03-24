From: Markus Hochholdinger <Markus@hochholdinger.net>
Subject: Re: [PATCH 018 of 29] md: Support changing rdev size on running arrays.
Date: Sat, 24 Mar 2012 21:47:15 +0100
Message-ID: <201203242147.23273.Markus@hochholdinger.net>
References: <20080627164503.9671.patches@notabene> <200806271809.29768.Markus@hochholdinger.net> <18533.31375.280387.666514@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3397132.AVTIXisazL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18533.31375.280387.666514@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Chris Webb <chris@arachsys.com>
List-Id: linux-raid.ids

--nextPart3397132.AVTIXisazL
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello,

it's been a long time, but today I tried again and had success!

Am 28.06.2008 um 01:41 Uhr schrieb Neil Brown <neilb@suse.de>:
> On Friday June 27, Markus@hochholdinger.net wrote:
> > Am Freitag, 27. Juni 2008 08:51 schrieb NeilBrown:
> > > From: Chris Webb <chris@arachsys.com>
[..]
> You don't want to "mdadm --grow" until everything has been resized.
> First lvresize one disk, then write '0' to the .../size file.
> Then do the same for the other disk.
> Then "mdadm --grow /dev/mdX --size max".

it works for me, if I do:
  echo 0 > /sys/block/md2/md/rd0/size
  mdadm --grow /dev/md2 --size=3Dmax
  # till here, nothing happens
  echo 0 > /sys/block/md2/md/rd1/size
  mdadm --grow /dev/md2 --size=3Dmax
  # rebuild of the added space begins

If I do only:
  echo 0 > /sys/block/md2/md/rd0/size
  echo 0 > /sys/block/md2/md/rd1/size
  mdadm --grow /dev/md2 --size=3Dmax
nothing will change.

As I understand, with "echo 0" md sees the new size and only with --grow th=
e=20
superblock will be moved.

I'm doing this with 2.6.32-5-xen-686 within Debian (squeeze) 6.0.

Many thanks to you and all the other linux-raid developers for this feature!

I'm very happy about this :-)


=2D-=20
greetings

eMHa

--nextPart3397132.AVTIXisazL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAk9uMtQACgkQXT3LE+AjWCsVmgCfeEk5ZiChxmcFUyEH3g0dKqch
GUMAmwcNbUD35gx2Hx5mFQ6molU1gZPN
=vEZ8
-----END PGP SIGNATURE-----

--nextPart3397132.AVTIXisazL--
