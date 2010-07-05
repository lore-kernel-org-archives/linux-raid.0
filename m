From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 17/33] test code for loop device support added
Date: Mon, 5 Jul 2010 11:47:17 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC407@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C34@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C34@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46rom: Czarnowska, Anna=20
Sent: Monday, July 05, 2010 11:32 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowsk=
i, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciec=
hanowski, Ed; dledford@redhat.com
Subject: [PATCH 17/33] test code for loop device support added

=46rom: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.=
com>

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski=
@intel.com>
---
=A0super-intel.c |=A0=A0=A0 9 +++++++++
=A01 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c index 973ccde..9551ad1 10064=
4
--- a/super-intel.c
+++ b/super-intel.c
@@ -5318,6 +5318,15 @@ static struct subset *platform_domain_imsm(struc=
t supertype *st)
=A0=A0=A0=A0=A0 s->spare_group =3D NULL;
=A0=A0=A0=A0=A0 s->next =3D NULL;
=A0
+=A0=A0=A0=A0 if (check_env("IMSM_DEVNAME_AS_SERIAL")) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s->paths->next =3D malloc(sizeof(*s->pa=
ths->next));
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!s->paths->next) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return s;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s->paths->next->path =3D strdup("loop*"=
);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s->paths->next->next =3D NULL;
+=A0=A0=A0=A0 }
+
=A0=A0=A0=A0=A0 /* TODO test code for implicit platform boudaries, dele=
te it */
=A0=A0=A0=A0=A0 if (check_env("IMSM_SUBSET_TEST")) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free(s->paths->path);
--
1.6.4.2


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
