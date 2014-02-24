From: NeilBrown <neilb@suse.de>
Subject: Re: What is the sector size in /sys/block/md*/md items?
Date: Mon, 24 Feb 2014 13:29:44 +1100
Message-ID: <20140224132944.435c9a2e@notabene.brown>
References: <5307F95E.70501@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/bnTNBc0z1TyEuipXUS_Rj.1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5307F95E.70501@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/bnTNBc0z1TyEuipXUS_Rj.1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 22 Feb 2014 12:11:58 +1100 Eyal Lebedinsky <eyal@eyal.emu.id.au>
wrote:

> I am reading the kernel Documentation/md.txt.
>=20
> It explains what md the items in sysfs mean. It refers a few times to "se=
ctors".
> - Are we talking 512 bytes or the underlying physical disk sector size?

Always 512 bytes.

> - Do all disks in an array need to have the same sector size?

No.

>=20
> Seeing how md can be built over physical disks, partitions, loop mounts a=
nd more,
> I expect that 'sector' is short for '512 bytes' and real disk sector size=
 is not
> relevant here.

Correct.

>=20
> Nevertheless, there is md*/queue/hw_sector_size which gives 512. So there=
 are now
> a few sector sizes (the array and the underlying devices) and the text do=
es not
> make it clear which is used where. I assume the array cluster size is the=
 one
> referred to in this document.

I was never happy when 'queue' appeared under md*.  It is almost entirely
irrelevant.

Feel free to post a patch to clarify md.txt.

Thanks,
NeilBrown


>=20
> TIA
>=20
> --
> Eyal Lebedinsky (eyal@eyal.emu.id.au)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/bnTNBc0z1TyEuipXUS_Rj.1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUwqumDnsnt1WYoG5AQIQsA//fHn+/fA6adiO4SqmLLWX8b0TCCR8NM8i
dVcv6fkfmheN6B6GyrHrdoQL89lYRRCgz5GY7VMgqSxmEv+wms3wHrff3KkMDZgx
hivQnmvgTnntuu5Ni9GzK1+ZH4bfACfQ2Zr5SlxleuoRHsWqcz2Sqbnv56vIRgo5
wNgVVgNoqNQ6iodUdBrvISMR4fF4SHIuYaGSpM5pi/wWKf67P6LzR2tj/rbWs/CZ
2G7HK9iRz+PmTSdiI/WphobZOxR6qBc/juB49Hsh8W6ADEZNhcwai/7fw6pcZeCV
DGOpOKtU37YnevMiDYG5EyZJ0ErxvG555zqBI/LXo3zDW8F2g9a2meEkYlXUCND8
WWjLijuiyuPHh0PDu72kOfCQt3u8k1NUG9MqcTkpLgNbobxCgcQKsCKk/a7zDHNg
LdWqOpmtQxg1SRy8a8pb6KX1xxiIBMQYa11x7JlKWOGbG52LxoMlG6EB7KGG4bpP
5EgV8YezgAQvY+RWiedvXg2koA5XX7fG8zsJUq8h171uSPCACb5RdDXXctne/NLQ
3EF8D4Wx7m8P7+/8TmAlozRMJivWtmI1okjkBBxgssk6csjOluXASFw2NxwuQKVN
IPBJ7JkfsDSsxaT9C7uRnZLzcOCOYFwIjvy26RroaX+Jexv2+jNVVc8r+21Luumy
V+dMxyuWBPA=
=9Nh6
-----END PGP SIGNATURE-----

--Sig_/bnTNBc0z1TyEuipXUS_Rj.1--
