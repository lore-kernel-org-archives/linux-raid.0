From: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Subject: [RESEND PATCH 5/5] raid5: set write hint for PPL
Date: Wed, 14 Feb 2018 14:23:34 +0100
Message-ID: <20180214132334.13687-6-mariusz.dabrowski@intel.com>
References: <20180214132334.13687-1-mariusz.dabrowski@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180214132334.13687-1-mariusz.dabrowski@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Mariusz Dabrowski <mariusz.dabrowski@intel.com>
List-Id: linux-raid.ids

When the Partial Parity Log is enabled, each write overwrites the old PPL
entry on the drive so set WRITE_LIFE_SHORT write hint for all PPL writes.

Change write hint policy for parity to WRITE_LIFE_MEDIUM because its
lifetime for single write is longer than PPL. It might cause a slightly
higher write amplification, but data with different lifetime will not be
mixed.

Introduce new policy "sharing" to use same write hint for both PPL and
parity when the workload is predominantly sequential (similar lifetime
for parity and PPL data).

Signed-off-by: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Reviewed-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 Documentation/admin-guide/md.rst | 16 ++++++++++++++++
 drivers/md/raid5-ppl.c           |  4 ++++
 drivers/md/raid5.c               | 18 +++++++++++++++++-
 drivers/md/raid5.h               |  2 ++
 4 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-guide/md.rst
index 84de718f24a4..b3adab6ed960 100644
--- a/Documentation/admin-guide/md.rst
+++ b/Documentation/admin-guide/md.rst
@@ -756,3 +756,19 @@ These currently include:
       The cache mode for raid5. raid5 could include an extra disk for
       caching. The mode can be "write-throuth" and "write-back". The
       default is "write-through".
+
+  write_hint_policy (raid4, raid5 and raid6 only)
+      Write lifetime hint policy for raid 4/5/6. This file lists all active
+      policies separated by commas. Policy can be changed by writing:
+
+        ``parity`` set write hint for all parity requests which will be
+                   overwritten in a moment.
+
+        ``ppl`` set write lifetime hint for all requests containing PPL data.
+
+        ``sharing`` set the same write hint for PPL and parity. If not set, use
+                    longer lifetime write hint for parity. Applicable only if
+                    ``parity`` and ``ppl`` policies are enabled.
+
+      To disable specific policy, use ``-`` prefix. To disable all policies use
+      ``off`` value.
\ No newline at end of file
diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 2764c2290062..d98855281254 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -424,6 +424,10 @@ static void ppl_log_endio(struct bio *bio)
 static void ppl_submit_iounit_bio(struct ppl_io_unit *io, struct bio *bio)
 {
 	char b[BDEVNAME_SIZE];
+	struct r5conf *conf = io->log->ppl_conf->mddev->private;
+
+	if (test_bit(WH_POLICY_PPL, &conf->write_hint_flags))
+		bio->bi_write_hint = WRITE_LIFE_SHORT;
 
 	pr_debug("%s: seq: %llu size: %u sector: %llu dev: %s\n",
 		 __func__, io->seq, bio->bi_iter.bi_size,
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 1c581b0bbc44..2236103b7306 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -992,7 +992,11 @@ static void raid5_set_parity_write_hint(struct bio *bio,
 
 	if (!test_bit(STRIPE_FULL_WRITE, &sh->state) &&
 	    (++*updates_cnt < data_disks)) {
-		hint = WRITE_LIFE_SHORT;
+		if (test_bit(WH_POLICY_SHARING, &conf->write_hint_flags) &&
+		    test_bit(WH_POLICY_PPL, &conf->write_hint_flags))
+			hint = WRITE_LIFE_SHORT;
+		else
+			hint = WRITE_LIFE_MEDIUM;
 	} else {
 		int i;
 
@@ -6708,6 +6712,10 @@ raid5_show_write_hint_policy(struct mddev *mddev, char *buf)
 		} else {
 			if (test_bit(WH_POLICY_PARITY, &flags))
 				len += sprintf(buf+len, "parity%s", sep);
+			if (test_bit(WH_POLICY_PPL, &flags))
+				len += sprintf(buf+len, "ppl%s", sep);
+			if (test_bit(WH_POLICY_SHARING, &flags))
+				len += sprintf(buf+len, "sharing%s", sep);
 			len -= strlen(sep);
 		}
 	}
@@ -6735,6 +6743,14 @@ raid5_store_write_hint_policy(struct mddev *mddev, const char *page, size_t len)
 			set_bit(WH_POLICY_PARITY, &conf->write_hint_flags);
 		else if (strncmp(page, "-parity", 7) == 0)
 			clear_bit(WH_POLICY_PARITY, &conf->write_hint_flags);
+		else if (strncmp(page, "ppl", 3) == 0)
+			set_bit(WH_POLICY_PPL, &conf->write_hint_flags);
+		else if (strncmp(page, "-ppl", 4) == 0)
+			clear_bit(WH_POLICY_PPL, &conf->write_hint_flags);
+		else if (strncmp(page, "sharing", 7) == 0)
+			set_bit(WH_POLICY_SHARING, &conf->write_hint_flags);
+		else if (strncmp(page, "-sharing", 8) == 0)
+			clear_bit(WH_POLICY_SHARING, &conf->write_hint_flags);
 		else if (strncmp(page, "off", 3) == 0)
 			conf->write_hint_flags = 0;
 		else
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 4a5fa44ffecf..ca7233dacdf1 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -197,6 +197,8 @@ enum reconstruct_states {
 
 enum write_hint_flags {
 	WH_POLICY_PARITY = 0,
+	WH_POLICY_PPL,
+	WH_POLICY_SHARING,
 };
 
 struct stripe_head {
-- 
2.16.1

