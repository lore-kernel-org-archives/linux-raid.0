From: NeilBrown <neilb@suse.com>
Subject: Re: Question on blocks periodic writes
Date: Fri, 11 Nov 2016 12:52:34 +1100
Message-ID: <87a8d6lr4t.fsf@notabene.neil.brown.name>
References: <CAOzB0-6NYUqrzUyx3iQ8CbPwFh-dctKTVwE6GKupdYM-8AfOrg@mail.gmail.com> <8760nwm6vu.fsf@notabene.neil.brown.name> <58249BD9.8000303@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58249BD9.8000303@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Theophanis Kontogiannis <tkonto@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 11 2016, Wols Lists wrote:

> On 10/11/16 02:00, NeilBrown wrote:
>>> [ 8664.858104] xfsaild/md1(658): WRITE block 0 on md1 (8 sectors)
>> This is XFS doing something.  md cannot possibly stop all IO while the
>> filesystem performs occasional IO.  If these continue, you need to
>> discuss with xfs developers how to stop it.  If the writes to individual
>> drives continue after there are no writes to 'md1', then it is worth
>> coming back here to ask.
>>=20
>>=20
> Would the new journal feature be any help?

Probably not, though until we know what is causing the writes, it is
hard to say.

>
> I haven't dug in enough to understand it properly, and it would increase
> the vulnerability of the system to a journal failure, but the feature
> itself seems almost perfect for batching writes and enabling the disks
> to spin down for extended periods.

You might be able to build functionality onto the journal which allows
the drives in the main array to stay idle for longer, but it doesn't try
to do that at present.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYJSRiAAoJEDnsnt1WYoG5eNkP/RcHHwGsy02c5AY9PXktIFcR
9twXxK08Ry2UifBD12ea3w5oLxPwsXNqMPeYAsZ8V3D8GxRp2A2EH5CjX3zTX3ue
I0UU+sToTd0Ej8TTEv7vkDkhQC9DIdnChHa8GJnf85at2rdtmqXSvQzEuwVZFUhg
LuBtMK7qaY6NiQsQTonQRDvSKmomwLKoQdmNO0pUBW2Z2OlegOyzDtB/ZbQupjTu
HDzc66Bb6dwJXG05JA0ffgO95rhIJIaAYnpl8TP/spNdovKhX+EDosfOlkNX8vEi
ZnRZgtiLiVFiqR5O0dSoqZNLBMoG9dSU/xkuRkdewjfVfPXfAAeP+o0Hbj2i73wP
jVivoQsYepAv5ORbISuho7hNz9d1edMqJJP9pf3M5UEAZR4Hycd+JpBkYb/+g8vN
fyw+S9GYLHFUob7wLJhDqoy06PHbMPVlp75oazBR64KuZ3fU7cix7v1tYKvVc7e0
4sz8kpGzHbJeqNZWk8sd5cNeZjX0HaIz64kEFbssMtJN4QsgONXHNC9bRj0pOjc5
yvj4J3J6tbn8jsD8TEgO5A1UDEgxAOkg9IxTOeDCJBIB6za4If+3C+LTFDP4nSi1
tKZetEgWXECyofbHJfuaGAycCuqVS5gV30MY2ZXT0NYnluCs7oSMqxAaXI+5vvc1
twhVbX1fZMCFV1pchFIT
=2CyS
-----END PGP SIGNATURE-----
--=-=-=--
