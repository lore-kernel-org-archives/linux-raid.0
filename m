From: NeilBrown <neilb@suse.de>
Subject: Re: auto assemble in read-only mode?
Date: Tue, 7 Oct 2014 18:15:20 +1100
Message-ID: <20141007181520.359d939b@notabene.brown>
References: <1412600795583058500@businessgrade.com>
	<1412664991898536500@businessgrade.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/+HhGZ3yyM5U/FxtcKSEu91R"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1412664991898536500@businessgrade.com>
Sender: linux-raid-owner@vger.kernel.org
To: Errol Neal <eneal@businessgrade.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/+HhGZ3yyM5U/FxtcKSEu91R
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Oct 2014 02:56:31 -0400 Errol Neal <eneal@businessgrade.com> wrot=
e:

> On Mon, 10/06/2014 09:06 AM, Errol Neal <eneal@businessgrade.com> wrote:
> > hi folks. is it possible to assemble an md device in read-only mode?=20
> > after an array has been assembled, I know I can mark it as readonly wit=
h --misc -o /dev/md0 for example, but only after its been assembled it seem=
s..
> >=20
>=20
> Hi again. No thoughts here?=20

Not even 18 hours since you last asked - what do you thing this is? The
Internet :-)


> I'm need to run a RAID1 device on two independent nodes (shared storage) =
and I'd like to assemble the device on the "slave" node in read-only mode t=
o prevent any sync actions and etc.=20

Did you try adding the "--readonly" option to your --assemble command?
(Always best to report everything you tried and how it failed - requires le=
ss
guess work).

I hope you don't expect too much of a filesystem mounted from such an array
while the  other node is writing to the array...

NeilBrown


> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/+HhGZ3yyM5U/FxtcKSEu91R
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVDOTCDnsnt1WYoG5AQJG5g//ejtujG+eC1J+fld93IQZvviz3rFbSixi
9uCxGzLc2k1MK8Ob3cfSDukECybaowOAsWf+yc+rVb/rVkrCL4gN5wzaKPRv5Qov
0o+mJL0oe8K78GlydGpy2HCZ81ToFqGnX+FlsRdymyLLdwULTZB2Aj3OsUzCV3Pp
zloRnkdj0AMynQOBq6O1Mp99lTuxQ1GKU7m6DrPSJgCYfY8YCOWOnAo4QkxRvIXr
Yh5apEnk1DOCaFXim5ldDWjUsfGDnSRMzyDC8JtkMkC9egfGcwrpCS5ZH/KbE3CX
KmeAspVFCxZfhAjb8rstVZ8zLAokq7o2gaPgNxGd3Nr7MgYwAVybD8Pp3lyfB3a0
tu+uQGm12Mc9iRdDhsse+pwW0JhWDou3TbyBjMGwIHVr7jkDuBQrsIBTtiry8OLx
zR4gxK1bzP4UjFFBnHe4VewWso9ke6o2DoPXOERbC/E3jDDUwhooIuWF114rIK/t
HBktRx1hZ5Z2HMzWrmv8xtVaccsIyh/eVHUNdogRM9fPKs+lYg2FWVLVTta9mNcg
2JNld7ovqbM7/O6k3XHLAHzhrUyDAl7/4uRKSn9f8vvXFUJgPIs2go9jscWIIvJd
u17rm0T7L8MWlfTlkMjdIqxj/vByX+n1nEX4PlspHtY+GvdykcpbwWrGzCZabqZc
3unMhVwUldY=
=dCPv
-----END PGP SIGNATURE-----

--Sig_/+HhGZ3yyM5U/FxtcKSEu91R--
