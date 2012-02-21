From: Jim Meyering <jim@meyering.net>
Subject: [PATCH] avoid double-free upon "old buggy kernel" sysfs_read failure
Date: Tue, 21 Feb 2012 12:37:00 +0100
Message-ID: <87sji42zab.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


* Incremental.c (Incremental): On sysfs_read failure, don't call
sysfs_free(sra) just before "goto out_unlock", since that very
same "sra" is freed the same way by the clean-up code below.
---
FYI, coverity spotted the double free.

 Incremental.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/Incremental.c b/Incremental.c
index 78c9712..4ab9747 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -326,7 +326,6 @@ int Incremental(char *devname, int verbose, int runstop,
 			fprintf(stderr, Name
 		      ": You have an old buggy kernel which cannot support\n"
 				"      --incremental reliably.  Aborting.\n");
-			sysfs_free(sra);
 			rv = 2;
 			goto out_unlock;
 		}
--
1.7.9.1.266.g24ee9
