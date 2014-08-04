From: Michel Normand <normand@linux.vnet.ibm.com>
Subject: [PATCH] V2 cast print arguments in super-ddf.c
Date: Mon,  4 Aug 2014 16:53:03 +0200
Message-ID: <1407163983-29770-1-git-send-email-normand@linux.vnet.ibm.com>
References: <1407145424-14116-1-git-send-email-normand@linux.vnet.ibm.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1407145424-14116-1-git-send-email-normand@linux.vnet.ibm.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Guy Menanteau <menantea@linux.vnet.ibm.com>
List-Id: linux-raid.ids

From: Guy Menanteau <menantea@linux.vnet.ibm.com>

V2 differs only by correct From and Signe-off fields.

as per rhbz https://bugzilla.redhat.com/show_bug.cgi?id=1125883
the mdadm is failing on ppc64 and ppc64le architectures.
===
super-ddf.c: In function '_set_config_size':
super-ddf.c:2849:4: error: format '%llx' expects argument of type 'long long unsigned int', but argument 6 has type '__u64' [-Werror=format=]
    pr_err("%s: %x:%x: workspace size 0x%llx too big, ignoring\n",
    ^
super-ddf.c:2855:2: error: format '%llx' expects argument of type 'long long unsigned int', but argument 6 has type '__u64' [-Werror=format=]
  dprintf("%s: %x:%x config_size %llx, DDF structure is %llx blocks\n",
  ^
cc1: all warnings being treated as errors
<builtin>: recipe for target 'super-ddf.o' failed
===

Signed-off-by: <menantea@linux.vnet.ibm.com>
Signed-off-by: Michel Normand <normand@linux.vnet.ibm.com>
---
 super-ddf.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 8957c2e..bc0ce2c 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2847,13 +2847,15 @@ static void _set_config_size(struct phys_disk_entry *pde, const struct dl *dl)
 		__u64 wsp = cfs - t;
 		if (wsp > 1024*1024*2ULL && wsp > dl->size / 16) {
 			pr_err("%s: %x:%x: workspace size 0x%llx too big, ignoring\n",
-			       __func__, dl->major, dl->minor, wsp);
+			       __func__, dl->major, dl->minor,
+			       (unsigned long long)wsp);
 		} else
 			cfs = t;
 	}
 	pde->config_size = cpu_to_be64(cfs);
 	dprintf("%s: %x:%x config_size %llx, DDF structure is %llx blocks\n",
-		__func__, dl->major, dl->minor, cfs, dl->size-cfs);
+		__func__, dl->major, dl->minor,
+		(unsigned long long)cfs, (unsigned long long)(dl->size-cfs));
 }
 
 /* Add a device to a container, either while creating it or while
-- 
1.7.9.5

