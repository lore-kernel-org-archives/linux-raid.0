From: NeilBrown <neilb@suse.de>
Subject: Re: Need to remove failed disk from RAID5 array
Date: Fri, 20 Jul 2012 07:08:01 +1000
Message-ID: <20120720070801.498902ba@notabene.brown>
References: <CAB1R3shxBWebm13ie5gR0h++-GBTyfZrranHr8tjGkbPipV32w@mail.gmail.com>
	<50071C0A.8080307@tmr.com>
	<CAB1R3sjhES1+0XB43oXLomgH7Q6LPiTm11tPSoDJ91RRrfNy=A@mail.gmail.com>
	<20120719091611.22e16100@natsu>
	<500818D5.4080208@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/JO4qX4Re2V12=KvYoP.R24i"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <500818D5.4080208@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Roman Mamedov <rm@romanrm.ru>, Alex <mysqlstudent@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/JO4qX4Re2V12=KvYoP.R24i
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 19 Jul 2012 10:25:25 -0400 Bill Davidsen <davidsen@tmr.com> wrote:

> Roman Mamedov wrote:
> > On Wed, 18 Jul 2012 22:44:06 -0400
> > Alex <mysqlstudent@gmail.com> wrote:
> >
> >> I'm not sure what stats I could provide to troubleshoot this further.
> >> At this rate, the 2.7T array will take a full day to resync. Is that
> >> to be expected?
> > 1) did you try increasing stripe_cache_size?
> >
> > 2) maybe it's an "Advanced Format" drive, the RAID partition is not pro=
perly
> > aligned?
> >
> That's a good argument for not using "whole disk" array members, a partit=
ion can=20
> be started at a good offset and may perform better. As for the speed, sin=
ce it=20
> is reconstructing the array data (hope the other drives are okay), every =
block=20
> written requires three blocks read and a reconstruct in cpu and memory. Y=
ou can=20
> use "blockdev" to increase readahead, and set the devices to use the dead=
line=20
> scheduler, that _may_ improve things somewhat, but you have to read three=
 block=20
> to write one, so it's not going to be fast.
>=20

Read-ahead has absolutely no effect in this context.

Read-ahead is a function of the page cache.  When filling the page cache,
read-ahead suggests how much more to be read than has been asked for.

resync/recovery does not use the page cache, consequently the readahead
setting is irrelevant.

IO scheduler choice may make a difference.

NeilBrown


--Sig_/JO4qX4Re2V12=KvYoP.R24i
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAh3MTnsnt1WYoG5AQL+uA/9GXmumTmYh1wgKaEXRGrqbzghN7f6a5QG
Ebs9NIkQFdA/fp1f/xLDaS7K7JJaDNhRyqELmT3eklnxx8nikGNw9ar9LCBVBS0y
/oEiF82gggbVCJXqhPd55KVM1P8j+91dvWVMRC8oyhz/1C5zUzzAxFa9kVWglYP8
m8q1e+LzmOJxuk4aMjOYNp1d4Y2quRllZHmB2vZG5ctGvTLQi7nXlUVEnXvG1G1J
9v2n4fDkfO9JuuvyGq7g//xk7ejqRAH5IO2qNdF+SsytyhJA1+ANv9y1gj2ri4N/
N8Dmf0jFmUUjvEzYwswmvKw+VAX+U9CfvIjLjiDINBaj1OxWfKHDTAr2jJY/LYxL
g8e7Flp25LQKlrLzU7F6SyQ4i04otb1kTY9pALsJ3EvpKcofFCXeCvqG4VJ7cjuA
cgisY2npmwQAdvwGQSBnwcgR6Gw4RMWorgvCv44tNRkrRQoa7sNUV9QPhSRUz2cn
PT6Di3e4fhjktDO8WgBrzyJGeP9rCoe53rdBIRydTnRGr95MDALN77IXDoqPKp0K
NxqU9dqOpBnrbPjB+HAnUqQS4XAv7YAI/I0//LD4+40WDPw+VoLaK2qb60o3cwr4
G9oOqVxCxNiylRwp5+41dI3C4Gpb9U3lnpaFU3LzZ54nLtFPQKB/uw0iPpn3iHo8
3JEg04sRHm0=
=8QN7
-----END PGP SIGNATURE-----

--Sig_/JO4qX4Re2V12=KvYoP.R24i--
