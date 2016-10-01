From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 00/15] md-cluster: Fine-tuning for ten function
 implementations
Date: Sat, 1 Oct 2016 16:44:45 +0200
Message-ID: <3a03df66-92ce-20fb-17f3-fb79b9d43c8e@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <566ABCD9.1060404@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 1 Oct 2016 16:38:17 +0200

Several update suggestions were taken into account
from static source code analysis.

Markus Elfring (15):
  Use kcalloc() in lock_all_bitmaps()
  Improve another size determination in resync_info_update()
  Improve another size determination in join()
  Improve another size determination in __sendmsg()
  Improve another size determination in recv_daemon()
  Rename a jump label in recv_daemon()
  Improve another size determination in process_suspend_info()
  Improve determination of sizes in read_resync_info()
  Improve another size determination in lockres_init()
  Delete an unnecessary variable initialisation in lockres_init()
  Delete four error messages for a failed memory allocation
  Rename a jump label in area_resyncing()
  Less function calls in join() after error detection
  Less function calls in lockres_init() after error detection
  Delete unnecessary braces in unlock_all_bitmaps()

 drivers/md/md-cluster.c | 114 ++++++++++++++++++++++++------------------------
 1 file changed, 56 insertions(+), 58 deletions(-)

-- 
2.10.0
