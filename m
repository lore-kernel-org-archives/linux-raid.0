From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: raid5: offload stripe handle to workqueue
Date: Tue, 15 Jul 2014 18:49:45 +0300
Message-ID: <20140715154945.GA29698@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Shaohua Li,

The patch 851c30c9badf: "raid5: offload stripe handle to workqueue"
from Aug 28, 2013, leads to the following static checker warning:

	drivers/md/raid5.c:5554 alloc_thread_groups()
	warn: integer overflows in allocation

drivers/md/raid5.c
  5537  static int alloc_thread_groups(struct r5conf *conf, int cnt,
                                                            ^^^^^^^
"cnt" comes from the user as an unsigned long in
raid5_store_group_thread_cnt() but we truncate it to int here.  It would
be cleaner if the types were the same through out.

  5538                                 int *group_cnt,
  5539                                 int *worker_cnt_per_group,
  5540                                 struct r5worker_group **worker_groups)
  5541  {
  5542          int i, j, k;
  5543          ssize_t size;
  5544          struct r5worker *workers;
  5545  
  5546          *worker_cnt_per_group = cnt;
  5547          if (cnt == 0) {
  5548                  *group_cnt = 0;
  5549                  *worker_groups = NULL;
  5550                  return 0;
  5551          }
  5552          *group_cnt = num_possible_nodes();
  5553          size = sizeof(struct r5worker) * cnt;
                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Integer overflow #1.

  5554          workers = kzalloc(size * *group_cnt, GFP_NOIO);
                                  ^^^^^^^^^^^^^^^^^
Integer overflow #2.

  5555          *worker_groups = kzalloc(sizeof(struct r5worker_group) *
  5556                                  *group_cnt, GFP_NOIO);


TODO-list: 2014-07-14: raid5: integer overflows in alloc_thread_groups()

regards,
dan carpenter
