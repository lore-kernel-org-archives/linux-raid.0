From: Jes.Sorensen@redhat.com
Subject: [PATCH 2/2] Avoid stack overflow if GPT partition entries on disk are > 128 bytes
Date: Fri, 28 Oct 2011 21:50:51 +0200
Message-ID: <1319831451-26704-3-git-send-email-Jes.Sorensen@redhat.com>
References: <1319831451-26704-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1319831451-26704-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Per [1] GPT partition table entries are not guaranteed to be 128
bytes, in which case read() straight into a struct GPT_part_entry
would result in a buffer overflow corrupting the stack.

[1] http://en.wikipedia.org/wiki/GUID_Partition_Table

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 util.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/util.c b/util.c
index 1bbd87f..f65bf79 100644
--- a/util.c
+++ b/util.c
@@ -1127,7 +1127,8 @@ static int get_gpt_last_partition_end(int fd, unsigned long long *endofpart)
 {
 	struct GPT gpt;
 	unsigned char empty_gpt_entry[16]= {0};
-	struct GPT_part_entry part;
+	struct GPT_part_entry *part;
+	char buf[512];
 	unsigned long long curr_part_end;
 	unsigned all_partitions, entry_size;
 	unsigned part_nr;
@@ -1151,18 +1152,20 @@ static int get_gpt_last_partition_end(int fd, unsigned long long *endofpart)
 
 	/* sanity checks */
 	if (all_partitions > 1024 ||
-	    entry_size > 512)
+	    entry_size > sizeof(buf))
 		return -1;
 
+	part = (struct GPT_part_entry *)buf;
+
 	for (part_nr=0; part_nr < all_partitions; part_nr++) {
 		/* read partition entry */
-		if (read(fd, &part, entry_size) != (ssize_t)entry_size)
+		if (read(fd, buf, entry_size) != (ssize_t)entry_size)
 			return 0;
 
 		/* is this valid partition? */
-		if (memcmp(part.type_guid, empty_gpt_entry, 16) != 0) {
+		if (memcmp(part->type_guid, empty_gpt_entry, 16) != 0) {
 			/* check the last lba for the current partition */
-			curr_part_end = __le64_to_cpu(part.ending_lba);
+			curr_part_end = __le64_to_cpu(part->ending_lba);
 			if (curr_part_end > *endofpart)
 				*endofpart = curr_part_end;
 		}
-- 
1.7.6.4

