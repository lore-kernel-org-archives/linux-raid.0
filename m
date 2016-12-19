From: NeilBrown <neilb@suse.com>
Subject: Re: Fwd: (user) Help needed: mdadm seems to constantly touch my disks
Date: Mon, 19 Dec 2016 15:01:49 +1100
Message-ID: <87twa0tvma.fsf@notabene.neil.brown.name>
References: <CAJ=9zicFM+wOUhpdX1XEVm+y2gYoW3r2aTRj6gAcEkypxJULmA@mail.gmail.com> <871sxbz4yz.fsf@notabene.neil.brown.name> <CAJ=9zieRuTNiEGuB_RouqbdLGoxNkn09yiogR6rND84LtMdbxA@mail.gmail.com> <CAJ=9zifGPd+3YnP1aLwLPXjtpygRc9DsDP37CNz-VHBHn1vDOg@mail.gmail.com> <87inqgvpyj.fsf@notabene.neil.brown.name> <CAJ=9zidNV4sPj7KC7_mJEo8+=-YTKyWD5RiLsGG9p33CV12Qdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ=9zidNV4sPj7KC7_mJEo8+=-YTKyWD5RiLsGG9p33CV12Qdg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jure =?utf-8?Q?Erzno=C5=BEnik?= <jure.erznoznik@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

[please remember to keep linux-raid cc:ed]

On Mon, Dec 19 2016, Jure Erzno=C5=BEnik wrote:

> I wrote this in OP: iosnoop shows COMM=3D[idle, md0_raid5, kworker] as
> processes working on the disk. Blocks reported are 8, 16 (data size a
> few KB) and 18446744073709500000 (data size 0). That last one must be
> some virtual thingie as the disks are nowhere near that large.
>
> Does this answer the question or did you mean something else?

Maybe if you just make the blktrace logs available somewhere and I will
look at them myself.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhXW60ACgkQOeye3VZi
gbnWng/9F2iQhIWdg5H7bH8HOVy+1Ez4t6m2jrIioOjjm4vnNSBpgYuQAXOv8xN+
JS3qjWZr2Tg2tjnwR5L3JVF0pQtZNW2cjCosz1lJ3KGTpvROGiDhSdiPKOiQKqcL
O+GoCuFDXuUWk+BkIh/uyEqBs4Zsp2XXH1DCInLVh08DYx5A94SLYc8POq8f6IBA
a/HzEqHaSBEELy+4BhIU7aHXnZIPQ7CBcUAtmC1u2M/zw70aHKwoRZVS32B2V4Ia
oUyzX6BVLnzLCB8e+5LeXGecT9Ok2iXesVscVlDjvVmz9ApsHXNUKTD/wOZCipgY
DgN1pZGDh6Im8I5sdFKXwfDhTB3w9Q04YvnF8jonziD4+emY7BAtCC71DCuVnxHb
hXt0zDis1Tpzfpx/KarcDoKm4EB4EVeFee/18BvggiBPz1iVe9W1BzIC9m0ghCSg
gt+lRfDkTTN81vSIDpH0oMyI5U3xgemgGhUQ25sU6cbSDjTtay93ANlj/xU/2Mhm
wGNv6C0bUBRiJLdc7OtVZBgv2L7HZOy3p6yCVjSo9U0mg8CiDPPCocw0oZqMez98
gwv9qdzX/Jt1iYsqDLO6AkQp0OF8JE20T1ntUiB5/7AwrDlOjCCIjKK/KVVQ337f
5G1QLcTbvFpG7h/afTLUul7cHOghvlEVX80S9mKi3ijKX3O4P3Q=
=uDp5
-----END PGP SIGNATURE-----
--=-=-=--
