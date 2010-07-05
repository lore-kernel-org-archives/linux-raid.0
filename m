From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 16/33] additional environment dependent code for platform
 subset tests
Date: Mon, 5 Jul 2010 11:46:58 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC405@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C2F@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C2F@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46rom: Czarnowska, Anna=20
Sent: Monday, July 05, 2010 11:30 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowsk=
i, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciec=
hanowski, Ed; dledford@redhat.com
Subject: [PATCH 16/33] additional environment dependent code for platfo=
rm subset tests

=46rom: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.=
com>

in order to allow testing of implicit platform limitation somne code to=
 separate sda and the rest of AHCI devices has been added.
---
=A0super-intel.c |=A0=A0 17 +++++++++++++++++
=A01 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c index f704c43..973ccde 10064=
4
--- a/super-intel.c
+++ b/super-intel.c
@@ -5318,6 +5318,23 @@ static struct subset *platform_domain_imsm(struc=
t supertype *st)
=A0=A0=A0=A0=A0 s->spare_group =3D NULL;
=A0=A0=A0=A0=A0 s->next =3D NULL;
=A0
+=A0=A0=A0=A0 /* TODO test code for implicit platform boudaries, delete=
 it */
+=A0=A0=A0=A0 if (check_env("IMSM_SUBSET_TEST")) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free(s->paths->path);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* /dev/sda (scsi addr 0:0:0:0) in sepa=
rate group */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s->paths->path =3D strdup("pci-0000:00:=
1f.2-scsi-0*");
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s->next =3D malloc(sizeof(*s));
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s->next->paths =3D malloc(sizeof(*s->pa=
ths));
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!s->next->paths) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free(s);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return NULL;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s->next->paths->path =3D strdup("pci-00=
00:00:1f.2-scsi-*");
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s->next->paths->next =3D NULL;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s->next->spare_group =3D NULL;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s->next->next =3D NULL;
+=A0=A0=A0=A0 }
+
=A0=A0=A0=A0=A0 return s;
=A0}
=A0
--
1.6.4.2


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
