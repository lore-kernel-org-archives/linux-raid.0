From: Nate Dailey <nate.dailey@stratus.com>
Subject: raid1: freeze_array/wait_all_barriers deadlock
Date: Fri, 13 Oct 2017 14:32:27 -0400
Message-ID: <2e2fb33a-12a6-763a-bd8e-8dc4aa05fc13@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I hit the following deadlock:

PID: 1819   TASK: ffff9ca137dd42c0  CPU: 35 COMMAND: "md125_raid1"
  #0 [ffffaba8c988fc18] __schedule at ffffffff8df6a84d
  #1 [ffffaba8c988fca8] schedule at ffffffff8df6ae86
  #2 [ffffaba8c988fcc0] freeze_array at ffffffffc017d866 [raid1]
  #3 [ffffaba8c988fd20] handle_read_error at ffffffffc017fda1 [raid1]
  #4 [ffffaba8c988fdd0] raid1d at ffffffffc01807d0 [raid1]
  #5 [ffffaba8c988fea0] md_thread at ffffffff8ddc2e92
  #6 [ffffaba8c988ff08] kthread at ffffffff8d8af739
  #7 [ffffaba8c988ff50] ret_from_fork at ffffffff8df70485

PID: 7812   TASK: ffff9ca11f451640  CPU: 3 COMMAND: "md125_resync"
  #0 [ffffaba8cb5d3b38] __schedule at ffffffff8df6a84d
  #1 [ffffaba8cb5d3bc8] schedule at ffffffff8df6ae86
  #2 [ffffaba8cb5d3be0] _wait_barrier at ffffffffc017cc81 [raid1]
  #3 [ffffaba8cb5d3c40] raid1_sync_request at ffffffffc017db5e [raid1]
  #4 [ffffaba8cb5d3d10] md_do_sync at ffffffff8ddc9799
  #5 [ffffaba8cb5d3ea0] md_thread at ffffffff8ddc2e92
  #6 [ffffaba8cb5d3f08] kthread at ffffffff8d8af739
  #7 [ffffaba8cb5d3f50] ret_from_fork at ffffffff8df70485

The second one is actually raid1_sync_request -> close_sync -> wait_all_barriers.

The problem is that wait_all_barriers increments all nr_pending buckets, but 
those have no corresponding nr_queued. If freeze_array is called in the middle 
of wait_all_barriers, it hangs waiting for nr_pending and nr_queued to line up. 
This never happens because an in-progress _wait_barrier also gets stuck due to 
the freeze.

This was originally hit organically, but I was able to make it easier by 
inserting a 10ms delay before each _wait_barrier_call in wait_all_barriers, and 
a 4 sec delay before handle_read_error's call to freeze_array. Then, I start 2 
dd processes reading from a raid1, start up a check, and pull a disk. Usually 
within 2 or 3 pulls I can hit the deadlock.

I came up with a change that seems to avoid this, by manipulating nr_queued in 
wait/allow_all_barriers (not suggesting that this is the best way, but it seems 
safe at least):

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f3f3e40dc9d8..e34dfda1c629 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -994,8 +994,11 @@ static void wait_all_barriers(struct r1conf *conf)
  {
      int idx;

-    for (idx = 0; idx < BARRIER_BUCKETS_NR; idx++)
+    for (idx = 0; idx < BARRIER_BUCKETS_NR; idx++) {
          _wait_barrier(conf, idx);
+        atomic_inc(&conf->nr_queued[idx]);
+        wake_up(&conf->wait_barrier);
+    }
  }

  static void _allow_barrier(struct r1conf *conf, int idx)
@@ -1015,8 +1018,10 @@ static void allow_all_barriers(struct r1conf *conf)
  {
      int idx;

-    for (idx = 0; idx < BARRIER_BUCKETS_NR; idx++)
+    for (idx = 0; idx < BARRIER_BUCKETS_NR; idx++) {
+        atomic_dec(&conf->nr_queued[idx]);
          _allow_barrier(conf, idx);
+    }
  }

  /* conf->resync_lock should be held */

