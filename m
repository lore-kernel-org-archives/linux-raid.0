From: NeilBrown <neilb@suse.de>
Subject: Re: System runs with RAID but fails to reboot [explanation?]
Date: Mon, 3 Dec 2012 11:13:31 +1100
Message-ID: <20121203111331.762cfb9c@notabene.brown>
References: <1353517137.5795.55.camel@corn.betterworld.us>
	<20121122155236.0e7689c6@notabene.brown>
	<1353716131.18439.29.camel@corn.betterworld.us>
	<1353973722.7078.51.camel@markov.biostat.ucsf.edu>
	<20121127131527.4d0d81d5@notabene.brown>
	<1354071275.27664.90.camel@corn.betterworld.us>
	<20121129124509.55f3194b@notabene.brown>
	<1354171331.31993.41.camel@corn.betterworld.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/09.cBQ90u7zdLNK7rx/kN6l"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1354171331.31993.41.camel@corn.betterworld.us>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Boylan <ross@biostat.ucsf.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/09.cBQ90u7zdLNK7rx/kN6l
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Nov 2012 22:42:11 -0800 Ross Boylan <ross@biostat.ucsf.edu> wrot=
e:

> On Thu, 2012-11-29 at 12:45 +1100, NeilBrown wrote:
> > On Tue, 27 Nov 2012 18:54:35 -0800 Ross Boylan <ross@biostat.ucsf.edu> =
wrote:
> >=20
> > > It still doesn't seem to me the 1 device arrays should have been
> > > started, since they were inconsistent with mdadm.conf and not subject=
 to
> > > incremental assembly.  This is an understanding problem, not an
> > > operational problem: I'm glad the arrays did come up.  Details below,
> > > along with some other questions.
> >=20
> > Probably "mdadm -As"  couldn't find anything to assemble based on the
> > mdadm.conf file, so tried to auto-assemble anything it could find witho=
ut
> > concern for the ARRAY details in mdadm.conf.
> That would explain why they came up, but seems to undercut the "must
> match" condition given in the man page for mdadm.conf (excerpted just
> below).

Yeah, that's a bug.  I've got a rough fix worked out, but I need to test it=
 a
bit yet.  So mdadm-3.3 should behave differently.

Thanks,
NeilBrown


--Sig_/09.cBQ90u7zdLNK7rx/kN6l
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBULvuqznsnt1WYoG5AQLgSQ//do37zuPuAV/Wl14h8Zsjn6kw9pLPcG4Q
k8BYCl95gGjnGyGvKjtDrs7ue4okvP1GZSEywjr99PUoD3Rvd47ufydOumCPtXFY
832CA3xiFtPdPJUmi5Hxi3WWcMxudmyoF3ZMvHl7UuqWGkvmSomYfv2ZaUwOevQN
cuicQ+fLF6YKfaRdd4K4NmmITOz6CPOfUDinaxgRZ3ldNzAloWNG/8rX1Ar7aYbH
Ixo5RGv6QDckn0hN2o2YSD6jq/jVupYkwerwPKOnywtzSqZfBCX6+fUIkF0EI6zh
zsndxcrvEko01R1zJ2uJ67XGxSnvrdQekzMS89sJ3ruh/fkEEfy99/BYoD800BOH
JNkRjVmh+UMWLhcghTPq1O5bK1FqL7zvZEfJvHtHlVvPDrbE+7usXRc1DmiyPsCY
02vkh8txbNX8w6VjiTNFPGJkxW8potkk2SeO6GxKp71ElAtIWZxzhYF63rfNAihQ
3P6OIqdTbpQAgugHP/PtGatwEI2Y5C7ujQtymqWHOG8EMVZQoSCUtnj5ZO2E0d8C
XIFLiIJwq2EXEo8fV720+Ri1tz6SzCizIuYBo9b4rdYXGu3g6cY0VnFmC4RcvlJf
y+pQUSTLv7MzzZN/kO9ypw9fOBoXSw5TsBg/GOTHpDA7+oG2/tfNwMcnGaF532Cr
X66tMJGsNO4=
=sm2N
-----END PGP SIGNATURE-----

--Sig_/09.cBQ90u7zdLNK7rx/kN6l--
