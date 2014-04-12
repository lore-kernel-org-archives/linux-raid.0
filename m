From: NeilBrown <neilb@suse.de>
Subject: Re: Guess the size of a RAID{5,6} device
Date: Sat, 12 Apr 2014 18:24:48 +1000
Message-ID: <20140412182448.3de6d253@notabene.brown>
References: <5347A58B.2060308@gmail.com>
	<20140412095049.6cce32a6@notabene.brown>
	<5348F550.2040609@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/c2y/.MTX9wdR5RKj4rrTszk"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5348F550.2040609@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/c2y/.MTX9wdR5RKj4rrTszk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 12 Apr 2014 10:12:00 +0200 Francis Moreau <francis.moro@gmail.com>
wrote:

> Hello Neil,
>=20
> On 04/12/2014 01:50 AM, NeilBrown wrote:
> > On Fri, 11 Apr 2014 10:19:23 +0200 Francis Moreau <francis.moro@gmail.c=
om>
> > wrote:
> >=20
> >> Hello,
> >>
> >> I'd like to know if it's possible to get the size of a RAID{5,6} which
> >> is not created yet but the size of the partitions which will make up t=
he
> >> array are.
> >=20
> > How precise does the "guess" need to be?
> >=20
>=20
> I just need an approximation in order to report to user some information
> about the (raided) partition my tool is about to create.
>=20
> > If you subtract about 128Meg from the size of the partitions, round dow=
n the
>=20
> Just to be sure the size of the partitions is equal to the min size of
> all partitions ?

Correct.

NeilBrown


>=20
> > a multiple of the chunk size then multiply by the number of data disks,=
 you
> > should come quite close.
>=20
> Thanks, that should do the trick.


--Sig_/c2y/.MTX9wdR5RKj4rrTszk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU0j4UDnsnt1WYoG5AQJTWA/+NRTA2k6OZ+YsygxKKKQCB3JlxzcBJzri
sQlvdoNPj8GDqVmY7DvRnlltQtM37VqPJXD6+nqPtQU73q8hdFBDLRQq3+WbK/hy
DdUSKZQgUU53/Cgit5ksEKJ0g+Ry+DdskH0x7x+Miw7lZwF0Yl5rnG+r3YKUmN6y
IxMyN44rH0lYcguH/urwcabtE8Oo4aFvWUKJXBI/DbffMQWZPUgC2AqlR+OlTGx+
9DXmzXHE2/Kxv7XlkdYIOkS4tnwTXZUlHbuOfRE8I7uDA+2+NzFaz0Uf4NU0njqd
GtwnhXl5PHkjHJBXJbAHiz8uOJn/PFAejE5+r1tptOHWBX0Ope9VPzN4KNncsDHG
9f+bWhh9infW9E6m+QNBhYg7pvTtklTPB0SwatIwY7/EZ+RoCMJYfKrfXiKrdMsj
nSVeOU8W3Ktjy38qOeRaaOESHicM/jBugxWzmJmwb6lUngVuKQNrxfQTa98y6sR7
lM1ItE1HrijMiSL1bDxlxDQRrrZ4Uni7AH6b0ilDQ4qJKB6Yf7m3Bh0bsj03jC9/
Hv5o26bFstRBftG2bfrGlw6aH/l3I3RB8w/yFOWEZnybB83VRRJhlwBurOHuru56
3nWi9TsgDagvC9U6rap6P4TTQ0HgX/38LWevGrOUlKvq8+Qt3XryV1LayIf5EO+s
yueHuC6R65g=
=67Kc
-----END PGP SIGNATURE-----

--Sig_/c2y/.MTX9wdR5RKj4rrTszk--
