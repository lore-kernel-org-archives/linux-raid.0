From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: [PATCH 3/6] raid6check: Fix memory leaks detected by valgrind
Date: Tue, 18 Jun 2013 11:09:26 +0200
Message-ID: <20130618090926.1161109.45897.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
References: <20130618090910.1161109.69430.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130618090910.1161109.69430.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, piergiorgio.sartor@nexgo.de
Cc: linux-raid@vger.kernel.org, Bernd Schubert <bernd.schubert@fastmail.fm>
List-Id: linux-raid.ids

==2389947== 24 bytes in 1 blocks are definitely lost in loss record 1 of 10
==2389947==    at 0x4C2B3F8: malloc (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==2389947==    by 0x408067: xmalloc (xmalloc.c:36)
==2389947==    by 0x401B19: check_stripes (raid6check.c:151)
==2389947==    by 0x4030C6: main (raid6check.c:521)
==2389947==
==2389947== 24 bytes in 1 blocks are definitely lost in loss record 2 of 10
==2389947==    at 0x4C2B3F8: malloc (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==2389947==    by 0x408067: xmalloc (xmalloc.c:36)
==2389947==    by 0x401B67: check_stripes (raid6check.c:155)
==2389947==    by 0x4030C6: main (raid6check.c:521)
==2389947==

Signed-off-by: Bernd Schubert <bernd.schubert@fastmail.fm>
---
 raid6check.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/raid6check.c b/raid6check.c
index f5aeee4..17f7430 100644
--- a/raid6check.c
+++ b/raid6check.c
@@ -325,9 +325,11 @@ exitCheck:
 	free(stripe_buf);
 	free(stripes);
 	free(blocks);
+	free(block_index_for_slot);
 	free(p);
 	free(q);
 	free(results);
+	free(sig);
 
 	return err;
 }

