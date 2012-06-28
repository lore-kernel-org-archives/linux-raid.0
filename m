From: NeilBrown <neilb@suse.de>
Subject: Re: how to get 'peer disk' in raid configuration?
Date: Thu, 28 Jun 2012 10:26:52 +1000
Message-ID: <20120628102652.12521e0b@notabene.brown>
References: <4FEB9C69.9060608@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/q=fMX6pPfD+85O/Q0OI=e1J"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FEB9C69.9060608@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Shuklin <george.shuklin@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/q=fMX6pPfD+85O/Q0OI=e1J
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 28 Jun 2012 03:51:05 +0400 George Shuklin <george.shuklin@gmail.com>
wrote:

> Few days ago met intersting question:
>=20
> Let assume we have RAID10 on 4 disks. We want to remove two  disks=20
> without  breaking array.
>=20
> How we can know which drive is safe to eject? For 1st drive it obvious:=20
> any of. Second is more complicated: we need eject mirror part of 'second=
=20
> pair'.

Rules is simple.  Don't remove adjacent devices (where the last is
considered to be adjacent to the first).

There are some pairs of adjacent devices that it is safe to remove, but it =
is
always safe to remove a device that is not adjacent to a removed devices.

>=20
> How we can know exact topology of raid? (--detail does not provide=20
> enough information, IMHO).

What - exactly - would you like to see in --detail.
Your answer must take into account the possibility of an odd number of
devices, of more than 2 copies of each block, and of near, far, and offset
modes.

(Patches preferred, but English-language descriptions are acceptable :-)

NeilBrown


> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/q=fMX6pPfD+85O/Q0OI=e1J
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+ukzDnsnt1WYoG5AQIL4w/+P+xrBOBss0t1FKmpcIL1jGPTeiFcRyaV
HDcpD5kEpyh6pLgour08NuwB4efV6gAm5hQajyXCuDEK2LcZdkYLOMGvLAT7HjEI
bPcLoqDRsBkvUtMCOZJEY5fsmOl1ZSaEq2RoT2LH5zr21PXdNWmt4IrSLI1PMb/B
UX0vTbVeaL4XHqcI02V51vXA48n7Y6BOj7XzAfQFmsZ4JX7WtdqzIpAmY+7m8sCl
2GuIiztEazhDzJcxqnbmzS+OqLOKmsf0uBAFuSGle1noZwA+6/jk7Yq8VrH8fCmF
kHIFvwcDI96u8RceJhvm4G8K80iCZqMvzDZAK7neG8TfxmZ3nGFdGXaaHKxo6+qq
fVeFaZp159OrBQp2YXL5jF31sZkZAacCiBL+3KlVARjQV7z8Jw3oWGTbJn2sA+2Y
A/pa8pcTWd1TLRQcPO9zK+EaXRsdoO47+rb3xEpcLahUb5gDJksU65k8zMGhD2Qs
cdZsDZpNkDnrBQr6TCwew5Yw6NSEyk02cUTyluG0tDM/0hw7xo/SmPFLkY6uZIKY
eNQroG1JVFMSnz0tY5g41r0VW/fUrTfncsEST0hQ68W2rCBL3rFxBIZOU9tgUZl2
YnauOKzU5r/54e8JH0bJ4ccfxsv2tXkB/weI1hY2u6H4v3oVsN1UYwrGNyA/cbsy
OSz8wJzHMfU=
=zXkb
-----END PGP SIGNATURE-----

--Sig_/q=fMX6pPfD+85O/Q0OI=e1J--
