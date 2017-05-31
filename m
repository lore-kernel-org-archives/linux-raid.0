From: Jia-Ju Bai <baijiaju1990@163.com>
Subject: [PATCH] bcache: Fix a sleep-in-atomic bug
Date: Wed, 31 May 2017 15:23:40 +0800
Message-ID: <1496215420-15819-1-git-send-email-baijiaju1990@163.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
Sender: linux-bcache-owner@vger.kernel.org
To: kent.overstreet@gmail.com, shli@kernel.org, axboe@fb.com, mchristi@redhat.com, git@linux.ewheeler.net, colyli@suse.de, akpm@linux-foundation.org, wangyijing@huawei.com, mingo@kernel.org, mhocko@suse.com
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@163.com>
List-Id: linux-raid.ids

The driver may sleep under a spin lock, and the function call path is:
journal_wait_for_write (acquire the lock by spin_lock)
  closure_sync
    schedule --> may sleep

To fix it, the lock is released before "closure_sync", and the lock is 
acquired again after this function.

Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
---
 drivers/md/bcache/journal.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 1198e53..ad47c36 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -724,6 +724,7 @@ static struct journal_write *journal_wait_for_write(struct cache_set *c,
 			btree_flush_write(c);
 		}
 
+		spin_unlock(&c->journal.lock);
 		closure_sync(&cl);
 		spin_lock(&c->journal.lock);
 		wait = true;
-- 
1.7.9.5
