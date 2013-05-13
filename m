From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm fails to assemble arrays with quotes in name
Date: Mon, 13 May 2013 11:34:12 +1000
Message-ID: <20130513113412.2102592d@notabene.brown>
References: <5187E9AB.4040904@superhosting.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ppryvA_NLrEIUeFG1Vgpm8z"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5187E9AB.4040904@superhosting.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Marek Becka <marek.becka@superhosting.cz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ppryvA_NLrEIUeFG1Vgpm8z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 06 May 2013 19:34:35 +0200 Marek Becka <marek.becka@superhosting.cz>
wrote:

> Hi,
>=20
> By accident I have created an array with simple quotes in name:
>=20
> mdadm --assemble /dev/md0 --name=3D\'newname\':0 --update=3Dname /dev/sdb=
1=20
> /dev/sdd1
>=20
> My mdadm.conf contains following line:
>=20
> ARRAY /dev/md/0 metadata=3D1.2 UUID=3D0324aa8b:e17efd1a:bae27dd0:66fc7573=
=20
> name=3D'newname':0
>=20
> Mdadm fails to assemble this array. After removing the name from=20
> mdadm.conf, everything works fine.
>=20
> mdadm  --assemble --scan -v 2>&1 | grep sd[bd]1
> mdadm: no RAID superblock on /dev/sdd1
> mdadm: no RAID superblock on /dev/sdb1
> mdadm: /dev/sdd1 has wrong uuid.
> mdadm: /dev/sdb1 has wrong uuid.
> mdadm: /dev/sdd1 has wrong name.
> mdadm: /dev/sdb1 has wrong name.
>=20
> I'm using mdadm - v3.2.5 - 18th May 2012 and kernel version 3.4.35. The=20

mdadm-3.2.6 will quote the quotes in --detail --brief and  --examine --brief
output, so this issue is already address in the latest mdadm.
Next release will mention quotes in the mdadm.conf documentation.

NeilBrown


--Sig_/ppryvA_NLrEIUeFG1Vgpm8z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUZBDFDnsnt1WYoG5AQJhAw//YxlmxHh48oMj+BWEUwvJ7AAre03r2EjY
gjyKvnD7ZuJ4ZBt6Uq96qafEXeXIh8HuSO/k+u50SbsVCaDlpWF4+saBcTEHwN/J
qHyNT2+8xz0Rn5bXKVznsW5QdDBX0gPnK28UdBSqIiWJJ5kF9vk68q96o64MMnrd
olzizKnUXs5YujALt7TIFuwXIxnsWeJQm5i5Jr5cOG6Sh8QyIaHXWbnJRhngRzJX
CbbkT2sgciku6zIecwh5ZOIaaK0VIlfeqriQ2j7rlvl+6+bxsEk06I6o/BWzE1Et
gkM1srMOQlnHfSkCFnJxz1ofct1Iup8oJr8BgIMilOdwCtbbrkeEItM1XoOR+Epi
bFVJNXRYQv7K29aTY+35o4zatHDXunFq0hT8tj32/7/t+RU79jghXKONHHGk9Rtq
8fvnTTl2pSnYB3MdmTYapqpRnh8WS9P8BQrYU5Hew7xex7uqCnfNQpw0M5zkHiFZ
2r559+HQfjkgKkHR5Ge9PeDtmK0CaIk7niEJlQfd3jYRc1sAMM6VDs3cO9q4j+Lf
uJOUYp4QfRHp9ZQJSi1ncB2sMknLy4aSSQ5bzkTK4m0DQUSkCahNtwIRGzilk0iY
R0rDUp1rWbJhTInFuA3J4St1tFO+JfHIXuUvLHMPQTjGeJsn/dWITECkT0N5dX9P
bIBNH7tQs/8=
=DyjK
-----END PGP SIGNATURE-----

--Sig_/ppryvA_NLrEIUeFG1Vgpm8z--
