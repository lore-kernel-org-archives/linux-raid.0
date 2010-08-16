From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 16/35] test code for loop device support added
Date: Mon, 16 Aug 2010 10:49:42 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8F9E1@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From 4c5cc25d1c9c867c6f2b8c8b2f05c74f051c8d04 Mon Sep 17 00:00:00 2001
From: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Date: Wed, 16 Jun 2010 14:08:31 +0200
Subject: [PATCH 16/35] test code for loop device support added

---
 super-intel.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 973ccde..9551ad1 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5318,6 +5318,15 @@ static struct subset *platform_domain_imsm(struct supertype *st)
 	s->spare_group = NULL;
 	s->next = NULL;
 
+	if (check_env("IMSM_DEVNAME_AS_SERIAL")) {
+		s->paths->next = malloc(sizeof(*s->paths->next));
+		if (!s->paths->next) {
+			return s;
+		}
+		s->paths->next->path = strdup("loop*");
+		s->paths->next->next = NULL;
+	}
+
 	/* TODO test code for implicit platform boudaries, delete it */
 	if (check_env("IMSM_SUBSET_TEST")) {
 		free(s->paths->path);
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

