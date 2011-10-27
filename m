From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] GCC compile fix: remove calculation of unused variable
 'reservation'
Date: Thu, 27 Oct 2011 19:01:15 +1100
Message-ID: <20111027190115.5820d742@notabene.brown>
References: <1317912231-26625-1-git-send-email-Jes.Sorensen@redhat.com>
	<4EA80258.70302@redhat.com>
	<20111027153308.7e6cbe48@notabene.brown>
	<3F8F31A3BFD1664EAB894D1BD6AF32B9044259@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4ARNJ7y4Qz_D7taQzSjHCyn"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3F8F31A3BFD1664EAB894D1BD6AF32B9044259@IRSMSX102.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/4ARNJ7y4Qz_D7taQzSjHCyn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Oct 2011 07:46:10 +0000 "Czarnowska, Anna"
<anna.czarnowska@intel.com> wrote:

> I have sent a patch removing the unused variable a while ago.
> It must have been overlooked.

OK, thanks.

(And sorry I missed the patch)

NeilBrown


> Regards
> Anna
>=20
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > owner@vger.kernel.org] On Behalf Of NeilBrown
> > Sent: Thursday, October 27, 2011 6:33 AM
> > To: Jes Sorensen
> > Cc: linux-raid@vger.kernel.org; Czarnowska, Anna
> > Subject: Re: [PATCH] GCC compile fix: remove calculation of unused
> > variable 'reservation'
> >=20
> > On Wed, 26 Oct 2011 14:51:36 +0200 Jes Sorensen
> > <Jes.Sorensen@redhat.com>
> > wrote:
> >=20
> > > On 10/06/11 16:43, Jes.Sorensen@redhat.com wrote:
> > > > From: Jes Sorensen <Jes.Sorensen@redhat.com>
> > > >
> > > > gcc 4.6.1 doesn't like calculating a variable that then isn't
> > > > used. Remove it.
> > > >
> > > > Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> > > > ---
> > > >  super-intel.c |    2 --
> > > >  1 files changed, 0 insertions(+), 2 deletions(-)
> > >
> > > Neil,
> > >
> > > Any chance you could reply this one? It still seems to be an issue
> > with
> > > the latest git tree.
> > >
> > > Thanks,
> > > Jes
> >=20
> > Yeah - sorry. I wanted to check that it really should be removed and
> > there
> > wasn't some other bug hiding - but I looks like it is simply
> > unnecessary.
> > Hopefully Anna will correct me if I'm wrong...
> >=20
> > I''ve applied your patch.
> >=20
> > Thanks,
> > NeilBrown
>=20


--Sig_/4ARNJ7y4Qz_D7taQzSjHCyn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqkP0Tnsnt1WYoG5AQKIwA//RaCYdSOtLXwLo80KjYxyez+NALtentru
mHZy1qxpzC7ALBjqFhJXDW6HvJ+g18UsYEhG9P2uG315unuWDY6IAjL9Jc7lir4x
2ECRxFgVJk0vIdEUT91AsAgk7usBrP62Mc3piuOGQsNP0xPFpW2uZoA2DzQ67ofg
C4eYsaMVMrKVjKEg8yeQa2VWHwcON37BF4USHDYiY4R1SZZ3fsnFCH+TrlreeFrc
zoDI6SmXLMkPItzBpXvcG6k87irNQSXHEAWEQaY4rl8unlvDExMQOkomN2ipZwPG
qo3i/pQ7BMcgww6BqjFpmuBHz6P6KgheblDU89bMVmHXLP2vmNf01yQ7gYdbg79s
GBzSzjj1fgrJ1IBjacz18TBAq0pm4W51DIvUFHlO6yghHKoyy7YgPKNtlSISddAj
AV0YrLQV7nAWxhWJKhJa/6WVfK0KJ1k9q4YLX0jDO39YGSTBrIYur50C5HLy3H5G
R3/QijjVKlXXg3QI6p21QQAsibBoaf2YigedKgvr317lgCVqc17oq4J8SSAwshQy
C1TCDupX9CFkvUWtv21PJCueXeWmEU0qDcNSE4uMgPIrumFKR0Ngjppkoeq9sha7
hIehnpjy556ASTjwt9kUy2IFTU6C/C7Bi2DI/fg0My8CMDVNVT/HjuljckQqCM5v
8BTG671tj6M=
=YNPc
-----END PGP SIGNATURE-----

--Sig_/4ARNJ7y4Qz_D7taQzSjHCyn--
