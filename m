From: renyl <yilongx.ren@intel.com>
Subject: [PATCH mdadm] raid6check.c: fix "misleading-indentation" error
Date: Tue, 25 Oct 2016 13:41:17 +0800
Message-ID: <1477374077-4195-1-git-send-email-yilongx.ren@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: LKP <lkp@eclists.intel.com>, Yilong Ren <yilongx.ren@intel.com>, NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From: Yilong Ren <yilongx.ren@intel.com>

To fix the following error info:

root@vm-lkp-nex04-8G-7 /tmp/mdadm# make test
cc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" -DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" -DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DNO_COROSYNC -DNO_DLM -DVERSION=\"3.4-43-g1dcee1c\" -DVERS_DATE="\"06th April 2016\"" -DUSE_PTHREADS -DBINDIR=\"/sbin\"  -c -o raid6check.o raid6check.c
raid6check.c: In function 'manual_repair':
raid6check.c:267:4: error: this 'else' clause does not guard... [-Werror=misleading-indentation]
    else
    ^~~~
raid6check.c:269:5: note: ...this statement, but the latter is misleadingly indented as if it is guarded by the 'else'
     printf("Repairing D(%d) and P\n", failed_data);
     ^~~~~~
cc1: all warnings being treated as errors
<builtin>: recipe for target 'raid6check.o' failed
make: *** [raid6check.o] Error 1
root@vm-lkp-nex04-8G-7 /tmp/mdadm# 


Cc: NeilBrown <neilb@suse.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
Cc: LKP <lkp@eclists.intel.com>
Signed-off-by: Yilong Ren <yilongx.ren@intel.com>
---
 raid6check.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/raid6check.c b/raid6check.c
index ad7ffe7..acfc9a3 100644
--- a/raid6check.c
+++ b/raid6check.c
@@ -264,9 +264,10 @@ int manual_repair(int chunk_size, int syndrome_disks,
 			int failed_data;
 			if (failed_slot1 == -1)
 				failed_data = failed_slot2;
-			else
+			else {
 				failed_data = failed_slot1;
 				printf("Repairing D(%d) and P\n", failed_data);
+			}
 			raid6_datap_recov(syndrome_disks+2, chunk_size,
 					  failed_data, (uint8_t**)blocks, 1);
 		} else {
-- 
2.1.4

