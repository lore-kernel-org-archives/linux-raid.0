From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] GCC compile fix: remove calculation of unused variable
 'reservation'
Date: Thu, 27 Oct 2011 15:33:08 +1100
Message-ID: <20111027153308.7e6cbe48@notabene.brown>
References: <1317912231-26625-1-git-send-email-Jes.Sorensen@redhat.com>
	<4EA80258.70302@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+yf0F+5Qe4Hl51_lbEgtI74"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EA80258.70302@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org, Anna Czarnowska <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

--Sig_/+yf0F+5Qe4Hl51_lbEgtI74
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Oct 2011 14:51:36 +0200 Jes Sorensen <Jes.Sorensen@redhat.com>
wrote:

> On 10/06/11 16:43, Jes.Sorensen@redhat.com wrote:
> > From: Jes Sorensen <Jes.Sorensen@redhat.com>
> >=20
> > gcc 4.6.1 doesn't like calculating a variable that then isn't
> > used. Remove it.
> >=20
> > Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> > ---
> >  super-intel.c |    2 --
> >  1 files changed, 0 insertions(+), 2 deletions(-)
>=20
> Neil,
>=20
> Any chance you could reply this one? It still seems to be an issue with
> the latest git tree.
>=20
> Thanks,
> Jes

Yeah - sorry. I wanted to check that it really should be removed and there
wasn't some other bug hiding - but I looks like it is simply unnecessary.
Hopefully Anna will correct me if I'm wrong...

I''ve applied your patch.

Thanks,
NeilBrown


--Sig_/+yf0F+5Qe4Hl51_lbEgtI74
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqjfCTnsnt1WYoG5AQLiwQ//fjyL42YyxhC6LqGxhxiSFy5OY+n/LMCX
qm/OcedYQIJvLoUIJLWXy1tBicrQsKaS1hEr5TTUqF2Xt+Njd/PqPSf2N84p/nhP
YXOOKYWUa9DZRuiEolTe9atwL5k8XpqH/GICx7zfIPDO4pXFPtz4ptodTk0H65rb
erM1dgqH25rBQyacU0XIKcya3T5ely49OE4Ob/ChaoGeTrXoh1j4P5Udtg82O5ak
cvAgDGSyK9XaAQAH6/AWK+1Kh75NtW4JwcuC3OzP+3HY4IbfPyLW4w6f3rbvH2Eh
/MP3qkpkpPYUEhGFJcPeJvroa9qifObiKADH1ZBPwAmop79Ws6QFH4zjTAtAdDb3
S3AQMHoAXXhr01AvB+YnHkW+ict9a6LUPPjiw+ucHr1ROxTl6yYbJdlvkMnor2Wj
a4Cl9GPAmcgzy8y178MIou9C1Ch46jQT4LgfeIuVoIvbgZhjKjc+O8G9ifnzOJXz
c1WVMCrmxkLwGN2uzng1QNsFGyapg5tHAobO0cwkpUIwXLuHGTuN7ejPUgFOIAk9
vJRADTCl2qmly3Gf7f+RXOFhxXroM/qV+H53iG4GESmjvV2nJJIUi3NMWcoKKD5F
/6p886CggcR88SfybSiRKVlRzJ5A4X1AZyytNKxPD3cBXrM3Xczz++0P6XCuNhEX
fRxMb7Pqkps=
=Y7C1
-----END PGP SIGNATURE-----

--Sig_/+yf0F+5Qe4Hl51_lbEgtI74--
