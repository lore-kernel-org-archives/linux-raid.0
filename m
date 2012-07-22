From: NeilBrown <neilb@suse.de>
Subject: Re: raid10 array tend to two degraded raid10 array
Date: Mon, 23 Jul 2012 09:11:05 +1000
Message-ID: <20120723091105.5cb8dcf0@notabene.brown>
References: <50092079.a287440a.5002.ffff88ef@mx.google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7OGRG.RCA0t2dLKZmTx8TH2"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50092079.a287440a.5002.ffff88ef@mx.google.com>
Sender: linux-raid-owner@vger.kernel.org
To: vincent <hanguozhong@meganovo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/7OGRG.RCA0t2dLKZmTx8TH2
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, 20 Jul 2012 17:10:14 +0800 "vincent" <hanguozhong@meganovo.com> wro=
te:

> Hi, everyone:
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0I am Vincent, I am writing to you to ask a =
question about of
> mdadm.
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0I created a raid10 array with 4 160G disks =
used the command: mdadm
> -Cv /dev/md0 -l10 -n4 /dev/sd[abcd],
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 The version of my mdadm is 3.2.2, and the ver=
sion of my kernel=A0is
> 2.6.38
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 when the raid10 is in resyncing, I used the f=
ollowing command to
> make file system for it: mkfs.ext3 /dev/md0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 every was OK. The array continued to resync, =
but when the=A0process
> of resyncing is 3.4%, there were a lot of
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 IO error of "sda" and "sdc". There were bad b=
locks in sda and sdc.
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 Then I used "cat /proc/mdstat" to see the sta=
tus of /dev/md0:
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 Personalities=A0:=A0[raid10]=A0=A0=A0=A0=A0=A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 md0=A0:=A0active=A0raid10=A0sdb[1]=A0sdd[3]
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 310343680=A0blocks=A0super=A01.2=A0512K=A0chu=
nks=A02=A0near-copies=A0[4/2]=A0[_U_U]
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 unused=A0devices:=A0<none>
> =A0=A0=A0=A0=A0=A0=A0=A0=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 /dev/sdc and /dev/sda had lost.=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 Then=A0I reboot the system, but when i used "=
cat /proc/mdstat" to
> see the status of /dev/md0:
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0Personalities=A0:=A0[raid10]=A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0md126=A0:=A0active=A0raid10=A0sda[0]=A0sdc[=
2]
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0310343680=A0blocks=A0super=A01.2=A0512K=A0c=
hunks=A02=A0near-copies=A0[4/2]=A0[U_U_]
> =A0=A0=A0=A0=A0=A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0md0=A0:=A0active=A0raid10=A0sdb[1]=A0sdd[3]
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0310343680=A0blocks=A0super=A01.2=A0512K=A0c=
hunks=A02=A0near-copies=A0[4/2]=A0[_U_U]
> =A0=A0=A0=A0=A0=A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0unused=A0devices:=A0<none>
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0there had a array which name was md126, and=
 consisted by /dev/sdc
> /dev/sda.
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0I used "mdadm --assemble --scan" to assembl=
e the=A0md devices. the
> output=A0of the command is:
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 dm:=A0/dev/md/0=A0exists=A0-=A0ignoring
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 md:=A0md0=A0stopped.
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 mdadm:=A0ignoring=A0/dev/sda=A0as=A0it=A0repo=
rts=A0/dev/sdd=A0as=A0failed
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 mdadm:=A0ignoring=A0/dev/sdc=A0as=A0it=A0repo=
rts=A0/dev/sdd=A0as=A0failed
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 md:=A0bind<sdd>
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 md:=A0bind<sdb>
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 md/raid10:md0:=A0active=A0with=A02=A0out=A0of=
=A04=A0devices
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 md0:=A0detected=A0capacity=A0change=A0from=A0=
0=A0to=A0317791928320
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 mdadm:=A0/dev/md0=A0has=A0been=A0started=A0wi=
th=A02=A0drives=A0(out=A0of=A04).
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 md0:=A0unknown=A0partition=A0table
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 mdadm:=A0/dev/md/0=A0exists=A0-=A0ignoring
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 md:=A0md126=A0stopped.
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 md:=A0bind<sdc>
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 md:=A0bind<sda>
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 md/raid10:md126:=A0active=A0with=A02=A0out=A0=
of=A04=A0devices
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 md126:=A0detected=A0capacity=A0change=A0from=
=A00=A0to=A0317791928320
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 mdadm:=A0/dev/md126=A0has=A0been=A0started=A0=
with=A02=A0drives=A0(out=A0of=A04).
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 md126:=A0unknown=A0partition=A0table
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 And then=A0I used "mdadm -E /dev/sda", "mdadm=
 -E /dev/sdb", "mdadm
> -E=A0/dev/sdc", "mdadm -E /dev/sdc" ,=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 "mdadm -D /dev/md0" and "mdadm -D /dev/md127"=
 to=A0 check the
> details info of sda, sdb, sdc and sdd.=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 I found=A0the property of "Array UUID" of all=
 of these devices(sda,
> sdb, sdc, sdd)were the same. But the=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 property of "Events" and "Update Time" of "sd=
a" and=A0"sdc" were the
> same(21, =A0Fri Jul 6 11:02:09 2012),=A0=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 the property of "Events" and "Update Time" of=
 "sdb" and "sdd" were
> the same(35,=A0 Fri Jul 6 11:06:21 2012).
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0Although the "Update Time" and "events" pro=
perty of "sda" and
> "sdc" were not equal to "sdb" and=A0"sdd",=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 they had the same=A0"Array UUID". why=A0this =
array tend=A0to=A0two
> degraded arrays those had the same uuid?=A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 As the two arrays had the same uuid, it is di=
fficult to
> distinguish and=A0use them. I think it is unreasonable,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 could you help me ?
>=20

Yes, this is a known problem.  Hopefully it will be fixed in the next relea=
se
of mdadm. =20
For now, just remove the faulty devices, or at least remove the metadata fr=
om
them with
  mdadm --zero-superblock /dev/sd[ac]

NeilBrown

--Sig_/7OGRG.RCA0t2dLKZmTx8TH2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAyIiTnsnt1WYoG5AQK20RAAiW8khgTWK8d4+lJHbP2MDE8/aebcWVnV
RfVybg0ELArd9BuIgKeHklvSMA31zSHRXd4nGKQpemlsZic+fX81/YT1VVjOn9xX
t3vucdfYy0mtOrhiaiTh+wNWp/qZYNzOcwyCA2pnzF16axPWjhPsH/+cU3Vgc5Eg
dKithTDvi1/1fC0E1U12wHGunyOdSR6ngcWMJjiDszuqIRarLLWSAJEGq0CNhDhQ
1Grnxfa1FCPMxT5F3Ml1XDXkF9gtLQw9Bvqj/Bn3ffbJiRuwznmxv+EMR7J4nPRt
UIvtHJJyrdKVy+Zs8ZkcGrebo/oZrpVCCEZs7kv0v5jeYZ41UyzWwbphPM62REgo
dn5Z1ZO98mhSs9vA12sdRCtpd/+tBb4ViSIXfPk9P5vIHMvAHiyBMUKjfjowiQ4j
lY6lFnNfMWlTyJOekOuYMtaeg6Mr5EAvmfHWmf78J9IaJstreGveybLFZc05rktQ
WhmViRZx07vhnxL/YAuFwAf9c1C0jEo7JTjx/IqfM/IXGfVrrVefhD30BVmrovjo
bPe8WDgonuKLL1aHCair13nv0YvzAjVvSkDzmeTBBucUoosX/vEWGyQpLuLcBg5z
QVEsSCTRnuYBz9w9gGAGE5Y7yUYZ8TFj+6gh8ri5AMaeBjGc2sU+zayIdpBsLD30
g4fTKD0RwvA=
=jObp
-----END PGP SIGNATURE-----

--Sig_/7OGRG.RCA0t2dLKZmTx8TH2--
