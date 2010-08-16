From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 08/35] imsm: platform dependent domain boundaries
Date: Mon, 16 Aug 2010 10:43:03 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8F9C1@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From 50652bbdeb278be4bef56d740f2ec4262d3f5484 Mon Sep 17 00:00:00 2001
From: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Date: Mon, 28 Jun 2010 16:17:07 +0200
Subject: [PATCH 08/35] imsm: platform dependent domain boundaries

two supertype primitives:
	struct subset *platform_domain(struct supertype *)
	char *get_spare_group(struct supertype *)
has been added in order to allow future support of implicit platform
boundaries.
For imsm metadata platform_domain() provides list of subsets created in
accordance with capabilities of this platform.
The second will provide metadata dependent spare group identifier.
---
 mdadm.h       |   10 ++++++++++
 super-intel.c |   26 ++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 7b950f8..a0b1ab9 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -680,6 +680,16 @@ extern struct superswitch {
 	/* Allow a metadata handler to override mdadm's default layouts */
 	int (*default_layout)(int level); /* optional */
 
+	/* returns subsets of domain_ent structure according to implicit
+	 * boundaries related to the capabilities of hardware or platform
+	 */
+	struct subset *(*platform_domain)(struct supertype *st);
+
+	/* returns sparegroup string representing internal identifier
+	 * used for device grouping by high level management tools (like CIM)
+	 */
+	char *(*get_spare_group)(struct supertype *st);
+
 /* for mdmon */
 	int (*open_new)(struct supertype *c, struct active_array *a,
 			char *inst);
diff --git a/super-intel.c b/super-intel.c
index d6d8b09..f704c43 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5296,6 +5296,31 @@ static void imsm_delete(struct intel_super *super, struct dl **dlp, int index)
 		__free_imsm_disk(dl);
 	}
 }
+
+/* leaving supertype for future use */
+static struct subset *platform_domain_imsm(struct supertype *st)
+{
+	struct subset *s = malloc(sizeof(*s));
+
+	if (!s) {
+		fprintf(stderr, Name ": unable to allocate memory for domain "
+				     "subset entry\n");
+		return NULL;
+	}
+	s->paths = malloc(sizeof(*s->paths));
+	if (!s->paths) {
+		free(s);
+		return NULL;
+	}
+	/* this is the only type of controller we know of */
+	s->paths->path = strdup("pci-0000:00:1f.2-*");
+	s->paths->next = NULL;
+	s->spare_group = NULL;
+	s->next = NULL;
+
+	return s;
+}
+
 #endif /* MDASSEMBLE */
 
 struct superswitch super_imsm = {
@@ -5327,6 +5352,7 @@ struct superswitch super_imsm = {
 	.match_metadata_desc = match_metadata_desc_imsm,
 	.container_content = container_content_imsm,
 	.default_layout = imsm_level_to_layout,
+	.platform_domain = platform_domain_imsm,
 
 	.external	= 1,
 	.name = "imsm",
-- 
1.6.4.2

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

