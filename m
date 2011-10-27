From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: RE: [PATCH] GCC compile fix: remove calculation of unused variable
 'reservation'
Date: Thu, 27 Oct 2011 07:46:10 +0000
Message-ID: <3F8F31A3BFD1664EAB894D1BD6AF32B9044259@IRSMSX102.ger.corp.intel.com>
References: <1317912231-26625-1-git-send-email-Jes.Sorensen@redhat.com>
	<4EA80258.70302@redhat.com> <20111027153308.7e6cbe48@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_3F8F31A3BFD1664EAB894D1BD6AF32B9044259IRSMSX102gercorpi_"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111027153308.7e6cbe48@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--_002_3F8F31A3BFD1664EAB894D1BD6AF32B9044259IRSMSX102gercorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I have sent a patch removing the unused variable a while ago.
It must have been overlooked.
Regards
Anna

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of NeilBrown
> Sent: Thursday, October 27, 2011 6:33 AM
> To: Jes Sorensen
> Cc: linux-raid@vger.kernel.org; Czarnowska, Anna
> Subject: Re: [PATCH] GCC compile fix: remove calculation of unused
> variable 'reservation'
>=20
> On Wed, 26 Oct 2011 14:51:36 +0200 Jes Sorensen
> <Jes.Sorensen@redhat.com>
> wrote:
>=20
> > On 10/06/11 16:43, Jes.Sorensen@redhat.com wrote:
> > > From: Jes Sorensen <Jes.Sorensen@redhat.com>
> > >
> > > gcc 4.6.1 doesn't like calculating a variable that then isn't
> > > used. Remove it.
> > >
> > > Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> > > ---
> > >  super-intel.c |    2 --
> > >  1 files changed, 0 insertions(+), 2 deletions(-)
> >
> > Neil,
> >
> > Any chance you could reply this one? It still seems to be an issue
> with
> > the latest git tree.
> >
> > Thanks,
> > Jes
>=20
> Yeah - sorry. I wanted to check that it really should be removed and
> there
> wasn't some other bug hiding - but I looks like it is simply
> unnecessary.
> Hopefully Anna will correct me if I'm wrong...
>=20
> I''ve applied your patch.
>=20
> Thanks,
> NeilBrown


--_002_3F8F31A3BFD1664EAB894D1BD6AF32B9044259IRSMSX102gercorpi_
Content-Type: message/rfc822
Content-Disposition: attachment;
	creation-date="Thu, 27 Oct 2011 07:46:09 GMT";
	modification-date="Thu, 27 Oct 2011 07:46:09 GMT"

From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
To: 'NeilBrown' <neilb@suse.de>
CC: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>, "Williams,
 Dan J" <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>,
	"Grabowski, Grzegorz" <grzegorz.grabowski@intel.com>
Subject: [PATCH] remove unused variable
Thread-Topic: [PATCH] remove unused variable
Thread-Index: Acx8SQleaJj2RVQUSjeAK+Xap7yweQ==
Date: Mon, 26 Sep 2011 12:37:22 +0000
Message-ID: <3F8F31A3BFD1664EAB894D1BD6AF32B902FEE1@IRSMSX102.ger.corp.intel.com>
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-Exchange-Organization-SCL: -1
X-MS-TNEF-Correlator: 
x-ms-exchange-organization-originalclientipaddress: 163.33.239.180
x-ms-exchange-organization-originalserveripaddress: 163.33.3.155
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0

From ccbe8fd4b762d88184c0fea61abb966cf8c99cc9 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Mon, 26 Sep 2011 11:54:04 +0200
Subject: [PATCH] remove unused variable

reservation is calculated below in imsm_min_reserved_sectors()
so this variable is not needed

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 super-intel.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 07d47b5..75b432d 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -988,9 +988,8 @@ static unsigned long long min_acceptable_spare_size_ims=
m(struct supertype *st)
 	struct dl *dl;
 	struct extent *e;
 	int i;
 	unsigned long long rv =3D 0;
-	__u32 reservation;
=20
 	if (!super)
 		return rv;
 	/* find first active disk in array */
@@ -1006,9 +1005,8 @@ static unsigned long long min_acceptable_spare_size_i=
msm(struct supertype *st)
 	for (i =3D 0; e[i].size; i++)
 		continue;
 	if (i > 0)
 		rv =3D e[i-1].start + e[i-1].size;
-	reservation =3D __le32_to_cpu(dl->disk.total_blocks) - e[i].start;
 	free(e);
=20
 	/* add the amount of space needed for metadata */
 	rv =3D rv + imsm_min_reserved_sectors(super);
--=20
1.7.4


--_002_3F8F31A3BFD1664EAB894D1BD6AF32B9044259IRSMSX102gercorpi_--
