From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 2/2] mdadm: save previous journal_clean when reload super
Date: Mon, 28 Aug 2017 15:20:36 -0700
Message-ID: <20170828222036.3278481-3-songliubraving@fb.com>
References: <20170828222036.3278481-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170828222036.3278481-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Song Liu <songliubraving@fb.com>, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com
List-Id: linux-raid.ids

In Incremental.c:count_active(), max_events is tracked to show to
which devices are up to date. If a device has events==max_events+1,
getinfo_super() is called to reload the superblock from this
device. getinfo_super1() blindly set journal_clean to 0, which is
wrong. This patch fixes this issue by saving previous
journal_clean before calling getinfo_super().

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 Incremental.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Incremental.c b/Incremental.c
index 6cf2174..b17b37f 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -747,13 +747,16 @@ static int count_active(struct supertype *st, struct mdinfo *sra,
 				;
 			else if (info.events == max_events+1) {
 				int i;
+				int journal_clean;
 				max_events = info.events;
 				for (i = 0; i < raid_disks; i++)
 					if (avail[i])
 						avail[i]--;
 				avail[info.disk.raid_disk] = 2;
 				best[info.disk.raid_disk] = devnum;
+				journal_clean = bestinfo->journal_clean;
 				st->ss->getinfo_super(st, bestinfo, NULL);
+				bestinfo->journal_clean = journal_clean;
 			} else { /* info.events much bigger */
 				memset(avail, 0, raid_disks);
 				max_events = info.events;
-- 
2.9.5

