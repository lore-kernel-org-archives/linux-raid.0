From: Jim Meyering <jim@meyering.net>
Subject: Re: [PATCH] avoid double-free upon "old buggy kernel" sysfs_read failure
Date: Tue, 21 Feb 2012 14:02:22 +0100
Message-ID: <87fwe42vc1.fsf@rho.meyering.net>
References: <87sji42zab.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87sji42zab.fsf@rho.meyering.net> (Jim Meyering's message of
	"Tue, 21 Feb 2012 12:37:00 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jim Meyering wrote:
> * Incremental.c (Incremental): On sysfs_read failure, don't call
> sysfs_free(sra) just before "goto out_unlock", since that very
> same "sra" is freed the same way by the clean-up code below.

Here it is again, but with the Signed-off-by line:

From 981af2b292448a9daa56af86b4c514ad9339665a Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering@redhat.com>
Date: Tue, 21 Feb 2012 11:08:25 +0100
Subject: [PATCH] avoid double-free upon "old buggy kernel" sysfs_read failure

* Incremental.c (Incremental): On sysfs_read failure, don't call
sysfs_free(sra) just before "goto out_unlock", since that very
same "sra" is freed the same way by the clean-up code below.

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
 Incremental.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/Incremental.c b/Incremental.c
index b457bf3..836a6f1 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -325,7 +325,6 @@ int Incremental(char *devname, int verbose, int runstop,
 			fprintf(stderr, Name
 		      ": You have an old buggy kernel which cannot support\n"
 				"      --incremental reliably.  Aborting.\n");
-			sysfs_free(sra);
 			rv = 2;
 			goto out_unlock;
 		}
--
1.7.9.1.266.g24ee9
