From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: Pausing md check hangs
Date: Tue, 25 Feb 2020 03:10:52 +0100
Message-ID: <15519216-347d-c355-fa1e-e1ec29f7e996@cloud.ionos.com>
References: <2ce8813c-fd3e-5e78-39ac-049ddfa79ff6@icdsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2ce8813c-fd3e-5e78-39ac-049ddfa79ff6@icdsoft.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: gnikolov@icdsoft.com, song@kernel.org
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 1/27/20 2:42 PM, Georgi Nikolov wrote:
> Hi,
> 
> I posted a kernel bug about this a month ago but it did not receive any attention: 
> https://bugzilla.kernel.org/show_bug.cgi?id=205929
> Here is a copy of the bug report and I hope that this is the correct place to discuss this:
> 
> I have a Supermicro server with 10 md raid6 arrays each consisting of 8 SATA drives. SATA drives are 
> Hitachi/HGST Ultrastar 7K4000 8T.
> When i try to pause array check with "echo idle > "/sys/block/<md_dev>/md/sync_action" it randomly 
> hangs at different md device.
> Process "mdX_raid6" is at 100% cpu usage.cat /sys/block/mdX/md/journal_mode hungs forever.

Hmm, "echo idle > /sys/block/<md_dev>/md/sync_action" can't get reconfig_mutex, but seems
it should acquire mddev->lock instead of reconfig_mutex to align with other read functions
of raid5_attrs. I think we need to change it.

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 9b6da759dca2..a961d8eed73e 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2532,13 +2532,10 @@ static ssize_t r5c_journal_mode_show(struct mddev *mddev, char *page)
         struct r5conf *conf;
         int ret;

-       ret = mddev_lock(mddev);
-       if (ret)
-               return ret;
-
+       spin_lock(&mddev->lock);
         conf = mddev->private;
         if (!conf || !conf->log) {
-               mddev_unlock(mddev);
+               spin_unlock(&mddev->lock);
                 return 0;
         }

@@ -2558,7 +2555,7 @@ static ssize_t r5c_journal_mode_show(struct mddev *mddev, char *page)
         default:
                 ret = 0;
         }
-       mddev_unlock(mddev);
+       spin_unlock(&mddev->lock);
         return ret;
  }


> 
> Here is the state at the moment of crash for one of the md devices:
> 
> root@supermicro:/sys/block/mdX/md# find -mindepth 1 -maxdepth 1 -type f|sort|grep -v 
> journal_mode|xargs -r egrep .
> ./array_size:default
> ./array_state:write-pending

MD_SB_CHANGE_PENDING was set, so md_update_sb() didn't clear it yet.

> grep: ./bitmap_set_bits: Permission denied
> ./chunk_size:524288
> ./component_size:7813895168
> ./consistency_policy:resync
> ./degraded:0
> ./group_thread_cnt:4

To narrow down the issue, I'd suggest to disable multiple raid5 workers.

> ./last_sync_action:check
> ./layout:2
> ./level:raid6
> ./max_read_errors:20
> ./metadata_version:1.2
> ./mismatch_cnt:0
> grep: ./new_dev: Permission denied
> ./preread_bypass_threshold:1
> ./raid_disks:8
> ./reshape_direction:forwards
> ./reshape_position:none
> ./resync_start:none
> ./rmw_level:1
> ./safe_mode_delay:0.204
> ./skip_copy:0
> ./stripe_cache_active:13173
> ./stripe_cache_size:8192
> ./suspend_hi:0
> ./suspend_lo:0
> ./sync_action:check

Since it was 'check' for sync_action means the array was set with RECOVERY_RUNNING,
RECOVERY_SYNC and RECOVERY_CHECK.

> ./sync_completed:3566405120 / 15627790336
> ./sync_force_parallel:0
> ./sync_max:max
> ./sync_min:1821385984
> ./sync_speed:126
> ./sync_speed_max:1000 (local)
> ./sync_speed_min:1000 (system)

The sync_speed is really low which means the system was under heavy pressure.

> 
> root@supermicro:~# cat /proc/mdstat
> Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [raid4] [raid10]
> md4 : active raid6 sdaa[2] sdab[3] sdy[0] sdae[6] sdac[4] sdad[5] sdaf[7] sdz[1]
>        46883371008 blocks super 1.2 level 6, 512k chunk, algorithm 2 [8/8] [UUUUUUUU]
>        [====>................]  check = 22.8% (1784112640/7813895168) finish=20571.7min speed=4884K/sec
> 

When check was in progress, I guess write 'idle' to sync_action was not quit in below
section. Specifically, I think it was waiting the completion of md_misc_wq, otherwise
the check should be interrupted after set MD_RECOVERY_INTR.

         if (cmd_match(page, "idle") || cmd_match(page, "frozen")) {
                 if (cmd_match(page, "frozen"))
                         set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
                 else
                         clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
                 if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
                     mddev_lock(mddev) == 0) {
                         flush_workqueue(md_misc_wq);
                         if (mddev->sync_thread) {
                                 set_bit(MD_RECOVERY_INTR, &mddev->recovery);
                                 md_reap_sync_thread(mddev);
                         }
                         mddev_unlock(mddev);



But it is not clear to me why flush_workqueue was not finished. Maybe the below could
help but I am not sure.

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4779,7 +4779,8 @@ action_store(struct mddev *mddev, const char *page, size_t len)
                 if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
                     mddev_lock(mddev) == 0) {
                         flush_workqueue(md_misc_wq);
-                       if (mddev->sync_thread) {
+                       if (mddev->sync_thread ||
+                           test_bit(MD_RECOVERY_RUNNING,&mddev->recovery)) {


Thanks,
Guoqing
