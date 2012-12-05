From: NeilBrown <neilb@suse.de>
Subject: Re: Questions about initialization process of mdadm
Date: Thu, 6 Dec 2012 07:09:41 +1100
Message-ID: <20121206070941.5829f791@notabene.brown>
References: <CAKcGETdgabz4TBXqo=+LRRM=0BLpPCd=MxanjiJnD=pdNgEpLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/KXn7s1ZHxnta8q9Nop.eE=p"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKcGETdgabz4TBXqo=+LRRM=0BLpPCd=MxanjiJnD=pdNgEpLw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Taejin Kim <taejin1999@davinci.snu.ac.kr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/KXn7s1ZHxnta8q9Nop.eE=p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 4 Dec 2012 12:12:23 +0900 Taejin Kim <taejin1999@davinci.snu.ac.kr>
wrote:

> Dear Neil Brown,
>=20
> I'm Taejin Kim, Ph.D student at Seoul National Universtiy in Korea.
> Recently, I got interested in RAID for flash memory and just started
> studying about RAID.
>=20
> I have seen that there are considerable number of writes during
> initialization of mdadm, reconstructing array from degraded status.
> When I search for what mdadm does, I was able to find your article about
> the RAID5 initialization of mdadm so I now understand what happens.
> (http://marc.info/?l=3Dlinux-raid&m=3D112044009718483&w=3D2)
>=20
> However, I'm wondering why we need to make sure the parity blocks are all
> correct even for a "new" RAID5 array.

Because when a single block is updated, the raid5 module  might use a
read-modify-write cycle.
i.e.
 - read old data and parity
 - subtract old data from parity, and add new data to parity
 - write new data and parity

If the parity block wasn't correct before, then it won't be correct after.

So we must make sure it is correct  at the start.

> In my point of view, there would be no meaningful data in a "new" drive so
> we can write data and parity block from the beginning without having
> consistent parity block calculated from meaningless data in a "new" drive.
>=20
> I could come up with one possible reason for the initialization, which is=
 a
> bad block management.
> Is it correct to recognize bad blocks in each drive during initialization
> by trying to write out parity blocks?
> If not, would you explain the reason for this initialization?
>=20
> I'm also wondering if this process is necessary only for mdadm or for oth=
er
> RAID tools, too.

I believe most RAID implementations perform an initial sync.

md doesn't current require it for other levels (just RAID5 and RAID4) as th=
ey
don't do any read-modify-write. However it is possible that the
implementation for RAID6 might change  one day, so don't assume that
--assume-clean is safe for RAID6 long-term.


NeilBrown

>=20
> I would appreciate if you let me know above questions. It would be very
> helpful for my research.
> I'm looking forward to your reply.
> Thank you.
>=20
> Sincerely.
>=20


--Sig_/KXn7s1ZHxnta8q9Nop.eE=p
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUL+qBTnsnt1WYoG5AQJwUw//adVkdOkk2Nwk8Rq7snRCjqPp3UrwEGF2
IKUXN80IfYojzGKrbnFpataGs5UVvtK2ZKSjzjgiOT+u78tcLvOxeY6WHAyud9Wa
M3UIpzkYzyqZXyN03uw/Po5qDnv0OyW+YFMXm58hgIYhkEKLjc+TxvN8QHadEqdm
UhAfWB8Yp696gr2Knd/1RR4KlCAYX7KXYIepZuj2iz91ALCoe0TqkouP0u3X+e13
K5/OHp8OE2Fzq30Cp13IAzuZDWWCdvvBg5fNGuyE+VgxKN/yY4AEEySDgbnVHbM1
eTlQJD4fUpkwI9mngWiVMJEADvpgK1TdKLFLvaTcidzf4nDJyuLZGwJAohTp96MN
kkhnydlM+hzywyXER3nZz7cAjZGtc2wC7sPaQ+2FTBfNjtGPUUSvzE1ZezZCB60z
cdON+wIIvLghC7U03JPO5pFaDfWchzQovg53gQwdNDFjA/aC/+AI4xQV3fg3wcdD
N9v4KNjtsErcqKIBVMaznOfkXOLjknuI0xvd84pRf8mLUX7KuLhRBF4MAOO6oWQn
B26oqrxhduuam9G5Zg+dmh7XK2MSLjRYHfe5zG1O060svBj4eUmy2ocekPVUuqT1
00YqpS3TCaPRN3qqtxVHsmOHwF53omrvSGunw71fI4CFRzQKoty994a2jrcjwfVu
D6OnWwtemEQ=
=+3/c
-----END PGP SIGNATURE-----

--Sig_/KXn7s1ZHxnta8q9Nop.eE=p--
