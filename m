From: Jameson Graef Rollins <jrollins@finestructure.net>
Subject: Re: Bug#624343: linux-image-2.6.38-2-amd64: frequent message "bio too big device md0 (248 > 240)" in kern.log
Date: Mon, 02 May 2011 09:38:05 -0700
Message-ID: <87k4e9cb2q.fsf@servo.factory.finestructure.net>
References: <20110427161901.27049.31001.reportbug@servo.factory.finestructure.net> <1304051980.3105.46.camel@localhost> <8739kyf53e.fsf@servo.factory.finestructure.net> <4DBE753D.20709@westcontrol.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DBE753D.20709@westcontrol.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, 624343@bugs.debian.org, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 02 May 2011 11:11:25 +0200, David Brown <david@westcontrol.com> wro=
te:
> This is not directly related to your issues here, but it is possible to=20
> make a 1-disk raid1 set so that you are not normally degraded.  When you=
=20
> want to do the backup, you can grow the raid1 set with the usb disk,=20
> want for the resync, then fail it and remove it, then "grow" the raid1=20
> back to 1 disk.  That way you don't feel you are always living in a=20
> degraded state.

Hi, David.  I appreciate the concern, but I am not at all concerned
about "living in a degraded state".  I'm far more concerned about data
loss and the fact that this bug has seemingly revealed that some
commonly held assumptions and uses of software raid are wrong, with
potentially far-reaching affects.

I also don't see how the setup you're describing will avoid this bug.
If this bug is triggered by having a layer between md and the filesystem
and then changing the raid configuration by adding or removing a disk,
then I don't see how there's a difference between hot-adding to a
degraded array and growing a single-disk raid1.  In fact, I would
suspect that your suggestion would be more problematic because it
involves *two* raid reconfigurations (grow and then shrink) rather than
one (hot-add) to achieve the same result.  I imagine that each raid
reconfiguration could potentially triggering the bug.  But I still don't
have a clear understanding of what is going on here to be sure.

jamie.

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJNvt3tAAoJEO00zqvie6q89RgP/0o8ceGiiI0ChPbys/HtNtL/
ZbNTTdM7ax6EgKeIbBPkYaEsByMWOTfEEBUOAm7plFJNTc1UstVGLRvbT0P3vxfb
QGKhXm3+bI/uW97sggTOu89vQVnanND6q3RCNvuzgEs/0AZaEASJMLx13Vix7gCh
7g2caJmRO9goTbW46kDQaicCOAy5x84LsGG9vPr9fwVQmILJR+JpXrAXJjOWqpxr
8utES23mtCDZnI3XgXWHxQ0mqFICHivKg96mdwnGFGaTTZ8rOyumf1ZvNUUxZ4aA
o/H6t0pQxi26Yu+1mRylz+Frffw1E3lP9G4wiGk1pv+IN0/TtZm/BBhDg4qIYnSd
QKS9wJc7dKhbCRnk3m9Fqt9qYLaz92Jb0sMdZAeY4LACPevzlgf4ouTXC8FPbX7z
pBtgq/3LoMadD++hP+ph4Q1HNCR12/sxaYZfz5r9X7AbrqS2uEZT3C7tLd03OUMP
Kw2z2qI8Ovnye81nTNDdGRTVYBisox9t2/pTxi7yrHg2FX6zOmXe14avIJwQtQFZ
xaDcgTqHP26GeKela0204nuRwKYomVNFiEP0fXSlh7jmh7NKA93eXBhuRhcy3MXn
kEEvuaBkMN40lJbFpuPJz11rKs+25I4rgjjPdVNX+PX/8/ceaz13qsgMPRQSKzds
bxDasCUqPz0Q/K6uA24J
=DLJU
-----END PGP SIGNATURE-----
--=-=-=--
