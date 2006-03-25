From: Brad Campbell <brad@wasp.net.au>
Subject: [PATCH] Add stripe cache entries to raid6 sysfs
Date: Sat, 25 Mar 2006 16:47:24 +0400
Message-ID: <44253BDC.3020609@wasp.net.au>
References: <442528D7.1050302@wasp.net.au> <44252ACE.9020706@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44252ACE.9020706@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Raid-6 did not create sysfs entries for stripe cache

Signed-off-by: Brad Campbell <brad@wasp.net.au>

---
diff -u vanilla/linux-2.6.16/drivers/md/raid6main.c linux-2.6.16/drivers/md/raid6main.c
--- vanilla/linux-2.6.16/drivers/md/raid6main.c 2006-03-20 09:53:29.000000000 +0400
+++ linux-2.6.16/drivers/md/raid6main.c 2006-03-25 16:35:05.000000000 +0400
@@ -2148,6 +2148,7 @@
         }

         /* Ok, everything is just fine now */
+        sysfs_create_group(&mddev->kobj, &raid6_attrs_group);
         mddev->array_size =  mddev->size * (mddev->raid_disks - 2);

         mddev->queue->unplug_fn = raid6_unplug_device;
---

-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
