From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 19/35] Util: get device size from id
Date: Mon, 16 Aug 2010 10:51:59 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8F9E9@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From 84690c1079378ebb2b409ffd29338b209b6c7fb7 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Tue, 20 Jul 2010 15:11:05 +0200
Subject: [PATCH 19/35] Util: get device size from id

---
 mdadm.h |    1 +
 util.c  |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 8548a91..69eb04a 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -794,6 +794,7 @@ extern struct supertype *super_by_fd(int fd);
 extern struct supertype *guess_super(int fd);
 extern struct supertype *dup_super(struct supertype *st);
 extern int get_dev_size(int fd, char *dname, unsigned long long *sizep);
+extern int dev_size_from_id(int id, unsigned long long *ssize);
 extern void get_one_disk(int mdfd, mdu_array_info_t *ainf,
 			 mdu_disk_info_t *disk);
 void wait_for(char *dev, int fd);
diff --git a/util.c b/util.c
index a746b83..4c2f283 100644
--- a/util.c
+++ b/util.c
@@ -1246,6 +1246,24 @@ int get_dev_size(int fd, char *dname, unsigned long long *sizep)
 	return 1;
 }
 
+int dev_size_from_id(int id, unsigned long long *ssize)
+{
+	char *dv;
+	int fd;
+
+	dv = map_dev(major(id), minor(id), 1);
+	if (!dv)
+		return 0;
+	fd = open(dv, O_RDONLY);
+	if (fd < 0)
+		return 0;
+	if (get_dev_size(fd, dv, ssize)) {
+		close(fd);
+		return 1;
+	}
+	close(fd);
+	return 0;
+}
 
 /* Sets endofpart parameter to the last block used by the last GPT partition on the device.
  * Returns: 1 if successful
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

