From: Ben Martin <monkeyiq@users.sourceforge.net>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Wed, 16 Jul 2008 13:36:32 +1000
Message-ID: <1216179392.5633.348.camel@sam.localdomain>
References: <1216130769.5633.318.camel@sam.localdomain>
	 <487CC660.9030004@ziu.info>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fTYTPDO/Tha+gn+pEp0R"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <487CC660.9030004@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <soltys@ziu.info>
Cc: linux-raid@vger.kernel.org, Ben Martin <monkeyiq@users.sourceforge.net>
List-Id: linux-raid.ids


--=-fTYTPDO/Tha+gn+pEp0R
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-15 at 17:46 +0200, Michal Soltys wrote:
> Ben Martin wrote:
> > Hi,
> >   Apologies if posting this here is inappropriate but a recent article
> > of mine compares the Linux Kernel RAID code to an $800 hardware RAID
> > card and might be of interest to list members:
> >=20
> > http://www.linux.com/feature/140734
> >=20
>=20
> Very interesting. Btw - did you use stripe-width on ext3s as well, or=20
> only stride ?

Only stride unfortunately. After digging through this ML's archives the
stride was mentioned a lot but not =EF=BB=BFstripe-width. I still have some
reserved partitions across the RAID for future benchmarks and
verification so I'll whip up a comparison of using =EF=BB=BFstripe-width vs=
 not
using it at some stage (ah, free time).

Perhaps this page could use some love with append(=EF=BB=BFstripe-width).
http://linux-raid.osdl.org/index.php/RAID_setup#Options_for_mke2fs


>=20
> Also looking back at other benchmarks, stripe_cache_size can have pretty=20
> tremendous effect on md raid performance. There're other settings that=20
> could matter as well (read ahead, queue depths). It would be interesting=20
> to see e.g. raid5 256k chunk comparison, done with those altered (=20
> _especially_ md's stripe_cache_size with some high value like 16384 or=20
> 32768), and with stripe-width used in ext3 case (if it wasn't used alread=
y).

I have been meaning to ask for a while, why is the =EF=BB=BFstripe_cache_si=
ze
set so low by default if it has such an effect on performance?=20

Obviously being conservative by default is less likely to get the kernel
devs into trouble, but perhaps having the system realize that the system
has 8gb of RAM and two RAID-$whatever setups in /etc/mdadm.conf and
using some simple dynamic algorithm to figure out that for this amount
of system RAM and two RAIDs of type $whatever it should chomp up say
256Mb of RAM for each RAID and turn read ahead on for each mdadm device.

I'm not sure if each individual Linux distro cares enough about this to
hack up their boot time scripts to do it.


--=-fTYTPDO/Tha+gn+pEp0R
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkh9bMAACgkQsIKOrI+5WvM/SQCglzkuigWQD9rzafs0kgy2qbU/
qgoAoPOgASI+dqzuD8Z8Xggsto7ghqEL
=Lt58
-----END PGP SIGNATURE-----

--=-fTYTPDO/Tha+gn+pEp0R--

