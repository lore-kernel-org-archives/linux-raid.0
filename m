From: Luca Berra <bluca@comedia.it>
Subject: [mdadm PATCH 1/3] fix gcc warnings about strict-aliasing rules
Date: Sat, 27 Feb 2010 14:53:38 +0100
Message-ID: <20100227135338.GB24207@maude.comedia.it>
References: <cover.1267264723.git.bluca@comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1267264723.git.bluca@comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Signed-off-by: Luca Berra <bluca@comedia.it>
---
   util.c |    4 ++--
   1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/util.c b/util.c
index 68f048d..1def2a0 100644
--- a/util.c
+++ b/util.c
@@ -1160,7 +1160,7 @@ static int get_gpt_last_partition_end(int fd, unsigned long long *endofpart)
   	entry_size = __le32_to_cpu(buf[GPT_ENTRY_SIZE_OFFSET]);
   
   	/* Check GPT signature*/
-	if (*((__u64*)buf) != GPT_SIGNATURE_MAGIC)
+	if ((__u64)buf[0] != GPT_SIGNATURE_MAGIC)
   		return -1;
   
   	/* sanity checks */
@@ -1178,7 +1178,7 @@ static int get_gpt_last_partition_end(int fd, unsigned long long *endofpart)
   		/* is this valid partition? */
   		if (memcmp(part->type_guid, empty_gpt_entry, 16) != 0) {
   			/* check the last lba for the current partition */
-			curr_part_end = __le64_to_cpu(*(__u64*)part->ending_lba);
+			curr_part_end = __le64_to_cpu((__u64)part->ending_lba[0]);
   			if (curr_part_end > *endofpart)
   				*endofpart = curr_part_end;
   		}
-- 
1.7.0

-- 
Luca Berra -- bluca@comedia.it
          Communication Media & Services S.r.l.
   /"\
   \ /     ASCII RIBBON CAMPAIGN
    X        AGAINST HTML MAIL
   / \
