From: Doug Ledford <dledford@redhat.com>
Subject: [Patch mdadm-2.6.7.1 2/3] Fix NULL pointer oops
Date: Wed, 29 Oct 2008 15:05:36 -0400
Message-ID: <7c468095f2afc12245eb2988457f87440b3882e9.1225306892.git.dledford@redhat.com>
References: <cover.1225306892.git.dledford@redhat.com>
 <c82952743d7177261512b107adcb101ecd035a21.1225306892.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.5.6.5"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c82952743d7177261512b107adcb101ecd035a21.1225306892.git.dledford@redhat.com>
In-Reply-To: <cover.1225306892.git.dledford@redhat.com>
References: <cover.1225306892.git.dledford@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------1.5.6.5
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


RAID10 is the only raid level that uses the avail char array pointer
during the enough() operation, so it was the only one that saw this.
The code in incremental assumes unconditionally that count_active will
allocate the avail char array, that it might be used by enough, and that
it will need to be freed afterward.  Once you make count_active actually
do that, then the oops goes away.

Signed-off-by: Doug Ledford <dledford@redhat.com>
---
 Incremental.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)
--------------1.5.6.5
Content-Type: text/x-patch; name="7c468095f2afc12245eb2988457f87440b3882e9.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="7c468095f2afc12245eb2988457f87440b3882e9.diff"

diff --git a/Incremental.c b/Incremental.c
index 0fb9afd..9c6524f 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -543,12 +543,18 @@ static int count_active(struct supertype *st, int mdfd, char **availp,
 		if (ok != 0)
 			continue;
 		st->ss->getinfo_super(st, &info);
+		if (!avail) {
+			avail = malloc(info.array.raid_disks);
+			if (!avail) {
+				fprintf(stderr, Name ": out of memory.\n");
+				exit(1);
+			}
+			memset(avail, 0, info.array.raid_disks);
+			*availp = avail;
+		}
+
 		if (info.disk.state & (1<<MD_DISK_SYNC))
 		{
-			if (avail == NULL) {
-				avail = malloc(info.array.raid_disks);
-				memset(avail, 0, info.array.raid_disks);
-			}
 			if (cnt == 0) {
 				cnt++;
 				max_events = info.events;

--------------1.5.6.5--


