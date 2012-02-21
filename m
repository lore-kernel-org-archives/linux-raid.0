From: NeilBrown <neilb@suse.de>
Subject: Re: Question regarding RAID10
Date: Wed, 22 Feb 2012 06:46:11 +1100
Message-ID: <20120222064611.7d6fc20a@notabene.brown>
References: <CB691B4C.DD17%benjamin.goodrich@eXperticity.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/d8q5b79d2VE1i5bNhwYBM_L"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CB691B4C.DD17%benjamin.goodrich@eXperticity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin Goodrich <Benjamin.Goodrich@experticity.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/d8q5b79d2VE1i5bNhwYBM_L
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 21 Feb 2012 09:58:36 -0700 Benjamin Goodrich
<Benjamin.Goodrich@experticity.com> wrote:

> Neil,
>=20
> I was hoping you could clear up a question I had. The software implementa=
tion of RAID 10 on Linux does not seem to have a way to print the layout of=
 which disk is mirroring data for another disk. Is there a way to determine=
 which drives can be safely removed from the RAID 10 set?
>=20
> Thanks,
>=20
> Benjamin


Please send all questions about linux RAID to
   linux-raid@vger.kernel.org

I've copied this reply there.

In general, if you don't remove adjacent devices you should be safe.
(The last device is adjacent to the first).

There are other combination that can be removed in specific case.

Yes, it might be useful for mdadm to display something which clearly depicts
the layout.  Concrete suggestions welcome.  Patches even more welcome.

NeilBrown

--Sig_/d8q5b79d2VE1i5bNhwYBM_L
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT0P0gznsnt1WYoG5AQJHUw//Y9XQY5jXWVMwOtX3G1G2F1mYzsKIDbkT
Gmp1YU/ngUR0Evf9ngMq0rT6KthzYyW+mGFPRxp22TUEkQ0wJzJHmF5xqCbETQSu
3Qphbw83KJRQUnjzbvU3uV52oVP/tQ4NMw+8xv9ML0Uk8V25nA1Rc1qKEKRYUpsF
od0AZdTW6k0Es0q+/O98a6zWmLcXNXLO4/SpZBjWp+XAxnXAdSh66KYmvbIepg6T
VxEuF7NKx4Gaf8nf04M9SSZLVaEz9AMTZRl0+3ww9avY8zv/1GNlrgpoQiyZgy9x
ilOgmhZ5Hwfgn4PKpKyWFuyDAhcZFsfyDnECW9kJvkCsc6/Zxi/6HAQB4LA4iEE7
/tGLpKvcAlkrDAqMfbQRzBFIBDxzxGK7c+P+PmISB5k4w+dhT4TcGHDXvSwDrHy1
pxs5QxUReNU55vPiypEog1WR9gp1wGAXz+VojSxPqOzk21FwgJZbhXRfIzYz/yzk
RLqWcAJQur+jbOlU01SFdtOsJA8W/KSb/0/wUopUHbfTHdj3PD4vyx6c/H3Aax7o
WQ4j/it8Bk7HBCxtc7AfwoBOYwggec4hNaJG+N+XoM7cqLHPVA7UX5I7N4415Dj5
shCaXXz3/+RmWvrVAeuWuud5K1a6Ouss23vGiTSPsGpJ2pmjeql7+fK3CLcgCznT
6up47HQKUcU=
=tRV3
-----END PGP SIGNATURE-----

--Sig_/d8q5b79d2VE1i5bNhwYBM_L--
