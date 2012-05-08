From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm v3.1.3 spare group does not work
Date: Tue, 8 May 2012 20:05:52 +1000
Message-ID: <20120508200552.34af96fc@notabene.brown>
References: <002b01cd2cbd$fd6ea3a0$f84beae0$@com>
	<20120508122029.62488da5@notabene.brown>
	<015b01cd2d00$5f575020$1e05f060$@com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1e8lmKP4EAfLU1PtJarm5fE"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <015b01cd2d00$5f575020$1e05f060$@com>
Sender: linux-raid-owner@vger.kernel.org
To: Johnson Yan <johnson_yan@usish.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/1e8lmKP4EAfLU1PtJarm5fE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 8 May 2012 17:53:08 +0800 "Johnson Yan" <johnson_yan@usish.com> wro=
te:

> Hi Neil & All,
> I tried mdadm 3.2.3 again with mdmonitor service restart, the spare group=
 function is OK now. Mdadm v3.1.3 still can't work.
> Sorry for the inconvenience.

So it is fixed in 3.2.3 - good.
Thanks for letting me know.

NeilBrown

--Sig_/1e8lmKP4EAfLU1PtJarm5fE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6jwADnsnt1WYoG5AQLPyw//WToPaHdpAGYJg+N9w9wQAnMTm3mxXbmT
soul394qzb9fbdxAffFa8teI7aOGHpIrVA8XwELK/2T2Nmrlv7mbmCL79k++alf3
HfWAC4FpCkknpUaEgkYGx7jq7doEaO4cn1ZFXZYkYJ8OYcvsS2Qvl+Lmp0Q9jmS1
pC/DqrV4g72A2k+d96tGxJ49ayGcBpU5qBl3JQr74ukBcm2FHTLZvG7mJyie1/rz
MgMgvkXX9yvGnI7U0+bz+E95xkOu0gMJ+AIiKPFz7Gem9bHakcnJr/Y8FQ+zB2l8
xNb4FesgL3KaUL/whCKiEULNdEbSKyL9v6K1DMqA1KrZTs47chJcasWCmjMBN83A
BzMStGpJKMydcdctYVFPtgdssM607rsnx00LvKmToCDMV+edSbkgVbPMEpl5XOdC
q6qcyS42KUM65j4lS8hExfN8NRYQvJcrtbz09n/Hz3qqP6864n9VGCPO/2b3uWPC
jeAwZiALpTJCvaWZXijaRLNKrDmmkrmuARlj7FDiFdTTp8s7K9SeyJxXXlKOKJzR
NMtp19gk4TI74H5hdjLO7ncK+DwDKnCM8S01RxVwC+e61wDTij2qhs59jndTpa+9
5V276G3fI3rJjiZckuQrYFgt/BGVoF52bHdEf6048hzAfPHT0TbrPf4EBJhvR8eU
3XA/eFYFboQ=
=BM8F
-----END PGP SIGNATURE-----

--Sig_/1e8lmKP4EAfLU1PtJarm5fE--
