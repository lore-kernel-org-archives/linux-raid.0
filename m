From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] raid5: offload stripe handle to workqueue
Date: Thu, 21 Sep 2017 14:45:28 +0300
Message-ID: <20170921114528.zr6igl744fqd4rx3@mwanda>
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

	drivers/md/raid5.c:6658 alloc_thread_groups()
	warn: potential integer overflow from user '232 * cnt'

drivers/md/raid5.c
  6574  static ssize_t
  6575  raid5_store_group_thread_cnt(struct mddev *mddev, const char *page, size_t len)
  6576  {
  6577          struct r5conf *conf;
  6578          unsigned long new;
  6579          int err;
  6580          struct r5worker_group *new_groups, *old_groups;
  6581          int group_cnt, worker_cnt_per_group;
  6582  
  6583          if (len >= PAGE_SIZE)
  6584                  return -EINVAL;
  6585          if (kstrtoul(page, 10, &new))
                                       ^^^^
We get "new" from the user

  6586                  return -EINVAL;
  6587  
  6588          err = mddev_lock(mddev);
  6589          if (err)
  6590                  return err;
  6591          conf = mddev->private;
  6592          if (!conf)
  6593                  err = -ENODEV;
  6594          else if (new != conf->worker_cnt_per_group) {
  6595                  mddev_suspend(mddev);
  6596  
  6597                  old_groups = conf->worker_groups;
  6598                  if (old_groups)
  6599                          flush_workqueue(raid5_wq);
  6600  
  6601                  err = alloc_thread_groups(conf, new,
                                                        ^^^
and pass it to alloc_thread_groups().

  6602                                            &group_cnt, &worker_cnt_per_group,
  6603                                            &new_groups);
  6604                  if (!err) {
  6605                          spin_lock_irq(&conf->device_lock);
  6606                          conf->group_cnt = group_cnt;
  6607                          conf->worker_cnt_per_group = worker_cnt_per_group;
  6608                          conf->worker_groups = new_groups;
  6609                          spin_unlock_irq(&conf->device_lock);
  6610  
  6611                          if (old_groups)
  6612                                  kfree(old_groups[0].workers);
  6613                          kfree(old_groups);
  6614                  }

[ cut ]

  6642  static int alloc_thread_groups(struct r5conf *conf, int cnt,
                                                            ^^^^^^^
"cnt" was unsigned long but now it's an int.

  6643                                 int *group_cnt,
  6644                                 int *worker_cnt_per_group,
  6645                                 struct r5worker_group **worker_groups)
  6646  {
  6647          int i, j, k;
  6648          ssize_t size;
  6649          struct r5worker *workers;
  6650  
  6651          *worker_cnt_per_group = cnt;
  6652          if (cnt == 0) {
  6653                  *group_cnt = 0;
  6654                  *worker_groups = NULL;
  6655                  return 0;
  6656          }
  6657          *group_cnt = num_possible_nodes();
  6658          size = sizeof(struct r5worker) * cnt;
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  6659          workers = kzalloc(size * *group_cnt, GFP_NOIO);
                                  ^^^^^^^^^^^^^^^^^
These multiplications can overflow.

  6660          *worker_groups = kzalloc(sizeof(struct r5worker_group) *
  6661                                  *group_cnt, GFP_NOIO);
  6662          if (!*worker_groups || !workers) {
  6663                  kfree(workers);
  6664                  kfree(*worker_groups);
  6665                  return -ENOMEM;
  6666          }
  6667  
  6668          for (i = 0; i < *group_cnt; i++) {
  6669                  struct r5worker_group *group;

regards,
dan carpenter
