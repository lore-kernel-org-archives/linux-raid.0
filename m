From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: Add NO_IMSM_PLATFORM flag description to manual.
Date: Mon, 4 Mar 2013 17:26:32 +1100
Message-ID: <20130304172632.1168644a@notabene.brown>
References: <20130218115140.2751.36089.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hndDjUbXwNCt7K8sEjemGgw"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130218115140.2751.36089.stgit@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Marcin Tomczak <marcin.tomczak@intel.com>
Cc: linux-raid@vger.kernel.org, lukasz.dorau@intel.com
List-Id: linux-raid.ids

--Sig_/hndDjUbXwNCt7K8sEjemGgw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Feb 2013 12:51:40 +0100 Marcin Tomczak <marcin.tomczak@intel.com>
wrote:

> In exceptional cases user can use NO_IMSM_PLATFORM flag to use IMSM
> metadata RAIDs without valid Intel platform. With this flag set
> mdadm does not perform any compatibility checks.
>=20
> Note: Usage of this flag may lead to data loss!
>=20
> Signed-off-by: Marcin Tomczak <marcin.tomczak@intel.com>
> ---
>  mdadm.8.in |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
>=20
> diff --git a/mdadm.8.in b/mdadm.8.in
> index 535cc39..3ef20c7 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -2714,6 +2714,25 @@ to '1', the
>  .I mdadm
>  will create and devices that are needed.
> =20
> +.TP
> +.B IMSM_NO_PLATFORM
> +ATTENTION! Usage of this flag is extremely dangerous! You should use
> +this flag only when you know what you are doing and when it is
> +necessary. Make a backup before any action. You use it on your own
> +responsibility - unpredictable effects may appear much later.

I'm sorry, but I'm not going to include that sort of hyperbole in the man
page.  A simple statement of what it does is sufficient.

I have applied this patch.

NeilBrown


=46rom 401f095c39b732b4247bd728cb493eb7bb692298 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Mon, 4 Mar 2013 17:25:36 +1100
Subject: [PATCH] mdadm.8: Detail use for IMSM_NO_PLATFORM environment
 variable.

Suggested-by: Marcin Tomczak <marcin.tomczak@intel.com>

diff --git a/mdadm.8.in b/mdadm.8.in
index a3abc2d..1c06533 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -2710,6 +2710,21 @@ to '1', the
 .I mdadm
 will create and devices that are needed.
=20
+.TP
+.B IMSM_NO_PLATFORM
+A key value of IMSM metadata is that it allows interoperability with
+boot ROMs on Intel platforms, and with other major operating systems.
+Consequently,
+.I mdadm
+will only allow an IMSM array to be created or modified if detects
+that it is running on an Intel platform which supports IMSM, and
+supports the particular configuration of IMSM that is being requested
+(some functionality requires newer OROM support).
+
+These checks can be suppressed by setting IMSM_NO_PLATFORM=3D1 in the
+environment.  This can be useful for testing or for disaster
+recovery.  You should be aware that interoperability may be
+compromised by setting this value.
 .SH EXAMPLES
=20
 .B "  mdadm \-\-query /dev/name-of-device"


--Sig_/hndDjUbXwNCt7K8sEjemGgw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUTQ+mDnsnt1WYoG5AQLaqBAAgyeJ0/2q15nbvxY9AbwInCpPj8VPfzAm
RgIZ1JrnX4B/X+G4qWCTCWXDdNwqPooQL8wPqWXLDGiHVjMhkHudzws3unKBH6f5
Lot3WCzB4Mg33JsHKcglS99k/M3iVFE8Mt4caqJ+S8jdLtVaqsiUqZPuWLh6Fd2S
Xo+BxEel1cT/btwkxc0f7DrFIo/otAauvHVrorvjzCjK5/7TnkF4Tw3f+d6XJI3G
Deq1p4NMdWKauOI3mecbR3VEF6iW9X3QIUOK1/7SBjLQWl+lFlZVRjUXdNhN3cvt
JJfnjYZRv6qNduiiZnJ9SSBKNsKIdxyXO9a/5BQhg3Q4KQwT1xhu0QhHQLNL2zY4
lEGbfDLAq0nQHGxQr90fkBq9R14MuU6/aQ/99MNIsuVS1x3hwDTnfvIzjehSKQCo
9YJWN1cxtsntd3PkCs2utd0KdlM/75P7bhJHojZyVMwQtOD5nVEtLttk6CXAtqUe
OeSzK1pDcgy9NyqVCUw7B74ZatyA71bLttAZrOFPcobeakeiTDYdGQYylDA5RLvD
XLHG5Kq+BOmsA9fo93YhSfiO6FWDdEeqXiKsyK+HIHXKUuapGLtoiW4k7RAWUHKF
TZI58BuYvGYWHL+iDf1yuHgm+pvH460lo7WxQGj8QwGxllGxX/TOhicJWaCG8Onr
rH9wud1pZ7I=
=oljS
-----END PGP SIGNATURE-----

--Sig_/hndDjUbXwNCt7K8sEjemGgw--
