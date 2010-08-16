From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 15/35] additional environment dependent code for platform
 subset tests
Date: Mon, 16 Aug 2010 10:48:51 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8F9DC@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From 247fe5692e853b976325e9707299563563375712 Mon Sep 17 00:00:00 2001
From: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Date: Fri, 28 May 2010 13:35:27 +0200
Subject: [PATCH 15/35] additional environment dependent code for platform subset tests

in order to allow testing of implicit platform limitation somne code
to separate sda and the rest of AHCI devices has been added.
---
 super-intel.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index f704c43..973ccde 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5318,6 +5318,23 @@ static struct subset *platform_domain_imsm(struct supertype *st)
 	s->spare_group = NULL;
 	s->next = NULL;
 
+	/* TODO test code for implicit platform boudaries, delete it */
+	if (check_env("IMSM_SUBSET_TEST")) {
+		free(s->paths->path);
+		/* /dev/sda (scsi addr 0:0:0:0) in separate group */
+		s->paths->path = strdup("pci-0000:00:1f.2-scsi-0*");
+		s->next = malloc(sizeof(*s));
+		s->next->paths = malloc(sizeof(*s->paths));
+		if (!s->next->paths) {
+			free(s);
+			return NULL;
+		}
+		s->next->paths->path = strdup("pci-0000:00:1f.2-scsi-*");
+		s->next->paths->next = NULL;
+		s->next->spare_group = NULL;
+		s->next->next = NULL;
+	}
+
 	return s;
 }
 
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

