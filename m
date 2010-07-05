From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 08/33] imsm: platform dependent domain boundaries
Date: Mon, 5 Jul 2010 11:45:08 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC3F5@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C08@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C08@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46rom: Czarnowska, Anna=20
Sent: Monday, July 05, 2010 11:24 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowsk=
i, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciec=
hanowski, Ed; dledford@redhat.com
Subject: [PATCH 08/33] imsm: platform dependent domain boundaries

=46rom: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.=
com>

two supertype primitives:
=A0=A0=A0=A0=A0 struct subset *platform_domain(struct supertype *)
=A0=A0=A0=A0=A0 char *get_spare_group(struct supertype *) has been adde=
d in order to allow future support of implicit platform boundaries.
=46or imsm metadata platform_domain() provides list of subsets created =
in accordance with capabilities of this platform.
The second will provide metadata dependent spare group identifier.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski=
@intel.com>
---
=A0mdadm.h=A0=A0=A0=A0=A0=A0 |=A0=A0 10 ++++++++++
=A0super-intel.c |=A0=A0 26 ++++++++++++++++++++++++++
=A02 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 7b950f8..a0b1ab9 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -680,6 +680,16 @@ extern struct superswitch {
=A0=A0=A0=A0=A0 /* Allow a metadata handler to override mdadm's default=
 layouts */
=A0=A0=A0=A0=A0 int (*default_layout)(int level); /* optional */
=A0
+=A0=A0=A0=A0 /* returns subsets of domain_ent structure according to i=
mplicit
+=A0=A0=A0=A0 * boundaries related to the capabilities of hardware or p=
latform
+=A0=A0=A0=A0 */
+=A0=A0=A0=A0 struct subset *(*platform_domain)(struct supertype *st);
+
+=A0=A0=A0=A0 /* returns sparegroup string representing internal identi=
fier
+=A0=A0=A0=A0 * used for device grouping by high level management tools=
 (like CIM)
+=A0=A0=A0=A0 */
+=A0=A0=A0=A0 char *(*get_spare_group)(struct supertype *st);
+
=A0/* for mdmon */
=A0=A0=A0=A0=A0 int (*open_new)(struct supertype *c, struct active_arra=
y *a,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 char *inst);
diff --git a/super-intel.c b/super-intel.c index d6d8b09..f704c43 10064=
4
--- a/super-intel.c
+++ b/super-intel.c
@@ -5296,6 +5296,31 @@ static void imsm_delete(struct intel_super *supe=
r, struct dl **dlp, int index)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __free_imsm_disk(dl);
=A0=A0=A0=A0=A0 }
=A0}
+
+/* leaving supertype for future use */
+static struct subset *platform_domain_imsm(struct supertype *st) {
+=A0=A0=A0=A0 struct subset *s =3D malloc(sizeof(*s));
+
+=A0=A0=A0=A0 if (!s) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name ": unable to alloc=
ate memory for domain "
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=
=A0=A0=A0 "subset entry\n");
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return NULL;
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 s->paths =3D malloc(sizeof(*s->paths));
+=A0=A0=A0=A0 if (!s->paths) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free(s);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return NULL;
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 /* this is the only type of controller we know of */
+=A0=A0=A0=A0 s->paths->path =3D strdup("pci-0000:00:1f.2-*");
+=A0=A0=A0=A0 s->paths->next =3D NULL;
+=A0=A0=A0=A0 s->spare_group =3D NULL;
+=A0=A0=A0=A0 s->next =3D NULL;
+
+=A0=A0=A0=A0 return s;
+}
+
=A0#endif /* MDASSEMBLE */
=A0
=A0struct superswitch super_imsm =3D {
@@ -5327,6 +5352,7 @@ struct superswitch super_imsm =3D {
=A0=A0=A0=A0=A0 .match_metadata_desc =3D match_metadata_desc_imsm,
=A0=A0=A0=A0=A0 .container_content =3D container_content_imsm,
=A0=A0=A0=A0=A0 .default_layout =3D imsm_level_to_layout,
+=A0=A0=A0=A0 .platform_domain =3D platform_domain_imsm,
=A0
=A0=A0=A0=A0=A0 .external=A0=A0 =3D 1,
=A0=A0=A0=A0=A0 .name =3D "imsm",
--
1.6.4.2


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
