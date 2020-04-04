From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH 0/4] md: fix lockdep warning
Date: Sat,  4 Apr 2020 23:57:06 +0200
Message-ID: <20200404215711.4272-1-guoqing.jiang@cloud.ionos.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: songliubraving@fb.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids

Hi,

After LOCKDEP is enabled, we can see some deadlock issues, this patchset
makes workqueue is flushed only necessary, and the last patch is a cleanup.

Thanks,
Guoqing

Guoqing Jiang (5):
  md: add checkings before flush md_misc_wq
  md: add new workqueue for delete rdev
  md: don't flush workqueue unconditionally in md_open
  md: flush md_rdev_misc_wq for HOT_ADD_DISK case
  md: remove the extra line for ->hot_add_disk

 drivers/md/md.c | 54 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 38 insertions(+), 16 deletions(-)

-- 
2.17.1
