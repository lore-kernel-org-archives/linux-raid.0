From: NeilBrown <neilb@suse.de>
Subject: Re: Re-adding disks to RAID6 in a Fujitsu NAS: old mdadm?
Date: Thu, 28 Jun 2012 19:39:05 +1000
Message-ID: <20120628193905.1049b243@notabene.brown>
References: <4FE9BFC1.5070607@xunil.at>
	<20120628163205.2c6a1122@notabene.brown>
	<4FEC1CE7.5010709@xunil.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/VuyGvL3ixk_LFyRIIUYKjoA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FEC1CE7.5010709@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: lists@xunil.at
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/VuyGvL3ixk_LFyRIIUYKjoA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 28 Jun 2012 10:59:19 +0200 "Stefan G. Weichinger" <lists@xunil.at>
wrote:

> Am 28.06.2012 08:32, schrieb NeilBrown:
> > On Tue, 26 Jun 2012 15:57:21 +0200 "Stefan G. Weichinger"
> > <lists@xunil.at> wrote:
> >> Could that relate to this issue:
> >>=20
> >> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D500309
> >=20
> > Nope.  It was an earlier bug fixed in 2.6.5 by
> >=20
> > http://neil.brown.name/git?p=3Dmdadm;a=3Dcommitdiff;h=3D7a3be72fc621b4a=
7589e923cf065
>=20
> Ah,
> >=20
> I see. So this *could* be solved by using a more recent mdadm,
> correct?
>=20
> >> The NAS seems to run some ubuntu:
> >>=20
> >> # cat /proc/version Linux version 2.6.33.2 (root@NasX86-5) (gcc
> >> version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1
> >> SMP Mon Sep 13 04:28:32 CST 2010
> >=20
> > Does the "X86" in there suggest and x86 processor?  What does
> > "uname -a" show?
>=20
> # uname -a
> Linux NASCA0A00 2.6.33.2 #1 SMP Mon Sep 13 04:28:32 CST 2010 i686 unknown
>=20
> # cat /proc/cpuinfo
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 6
> model		: 28
> model name	: Intel(R) Atom(TM) CPU D525   @ 1.80GHz
> stepping	: 10
> cpu MHz		: 1795.730
> cache size	: 512 KB
> [...]
>=20
> > You mean the NAS didn't come with a complete build environment and
> > sources for all programs?  Outrageous.
>=20
> *sigh*
>=20
> > If you have a machine with the same arch at the NAS, you could
> >=20
> > git clone git://neil.brown.name/mdadm -b mdadm-2.6.5 cd mdadm make
> > mdadm.static CWFLAGS=3D-Wall
> >=20
> > and then use the "mdadm.static" on the NAS.
>=20
> Ok, thanks. I could boot some ubuntu on my Atom-netbook .. or what?
> Would it be enough to match the 64bit-environment, or would I have to
> use something with the same kernel ... ?

You just need a 32 bit build environment (not 64 bit).  It doesn't matter
what the kernel is.
You might manage it with

   make mdadm.static CWFLAGS=3D-m32 LDFLAGS=3D-m32

depending on what you have installed.

BTW, I got the command a bit wrong.  This works.

git clone git://neil.brown.name/mdadm ; cd mdadm; git checkout mdadm-2.6.5 ;
 make mdadm.static CWFLAGS=3D-Wall

I happen to have a 32bit machine, so I'll send you the resulting binary
in private email (don't want to clog up the list).

NeilBrown


--Sig_/VuyGvL3ixk_LFyRIIUYKjoA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+wmOTnsnt1WYoG5AQIisA//YDVQdEP+zuJyyDSwI2OyJwAtWZFoeuR+
qSnktIieGNPZps/Ut34nXNwor3eDj9cOrdaXT6nf7qq6qz9anSFQO4ttc5BuVrQh
H4bMneuTSbpIY3U1wBabLp8obKmRY6HoLTwIayGAZLWgXIF6Cf+35IGQiXUBAqMm
4zHQNZqeIM6pIB4svblBV1TjrefCC9Bm5qlQ0smHjl9XGpyPUUVtdWSJLklCR/I8
HxXnOATaPNv/K70U9wbAnbLIkLm5nvxqQF0Z6U9DEYDBym9lstDo7q+RXW+4LCnc
sAzxYO6ykDA3jhKQ60kVb3sQdHQ6N348YsPpr5/bqdQ115Rpawkd5gj0wQcn3jmm
TbVwqAnpAyAxXcdVCgYiAQ+LnxPIACoMRdj43Xtjf29zxX86Cq7KjVuQhu69AgFg
unzkBtvvoTJ4CrWPbhUUJD2V5OjKh92kdsKGr8KGTFP3KBpcATNQ2oIcPntxTmua
KUYvyjbj/GL8A7IfIqH7YoM4MVznCMyf73bqOfZQVoUwWSOCMcomHlRbwumY5mrS
94pqp8P2f7XXsip9fDGy690MIkLzXp/IaUA+oGXfZrF0Oyh1EBkze6yMsPoKJova
8mgcWhyzdYe2Zv//zGOeCLZ5HpeiOYp/5kYc4GGtLWANAwe0rotGyyxdBAa+Babm
b3OTc/jNhlI=
=KqRb
-----END PGP SIGNATURE-----

--Sig_/VuyGvL3ixk_LFyRIIUYKjoA--
