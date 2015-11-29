From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH Resend V2 2/2] md-cluster: Protect communication with
 mutexes (fwd)
Date: Sun, 29 Nov 2015 07:39:43 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1511290738570.2065@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: neilb@suse.com, linux-raid@vger.kernel.org, rgoldwyn@suse.com, kbuild-all@01.org
List-Id: linux-raid.ids

Looks suspicious.  Please check.

julia

---------- Forwarded message ----------
Date: Sun, 29 Nov 2015 09:17:12 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: kbuild@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH Resend V2 2/2] md-cluster: Protect communication with
    mutexes

CC: kbuild-all@01.org
In-Reply-To: <1448787432-4138-2-git-send-email-gqjiang@suse.com>
TO: Guoqing Jiang <gqjiang@suse.com>
CC: neilb@suse.com
CC: linux-raid@vger.kernel.org, rgoldwyn@suse.com

Hi Guoqing,

[auto build test WARNING on: md/for-next]
[also build test WARNING on: next-20151127]
[cannot apply to: v4.4-rc2]

url:    https://github.com/0day-ci/linux/commits/Guoqing-Jiang/md-cluster-Defer-MD-reloading-to-mddev-thread/20151129-085944
base:   git://neil.brown.name/md for-next
:::::: branch date: 17 minutes ago
:::::: commit date: 17 minutes ago

>> drivers/md/md-cluster.c:530:2-8: preceding lock on line 526

git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 7cd1e0cb4a84f8dd6ab7bfdb4a2e1d4eda66ad6d
vim +530 drivers/md/md-cluster.c

4664680c Goldwyn Rodrigues 2014-06-07  520  	struct md_cluster_info *cinfo = thread->mddev->cluster_info;
4664680c Goldwyn Rodrigues 2014-06-07  521  	struct dlm_lock_resource *ack_lockres = cinfo->ack_lockres;
4664680c Goldwyn Rodrigues 2014-06-07  522  	struct dlm_lock_resource *message_lockres = cinfo->message_lockres;
4664680c Goldwyn Rodrigues 2014-06-07  523  	struct cluster_msg msg;
b5ef5678 Guoqing Jiang     2015-07-10  524  	int ret;
4664680c Goldwyn Rodrigues 2014-06-07  525  
7cd1e0cb Guoqing Jiang     2015-11-29 @526  	mutex_lock(&cinfo->recv_mutex);
4664680c Goldwyn Rodrigues 2014-06-07  527  	/*get CR on Message*/
4664680c Goldwyn Rodrigues 2014-06-07  528  	if (dlm_lock_sync(message_lockres, DLM_LOCK_CR)) {
4664680c Goldwyn Rodrigues 2014-06-07  529  		pr_err("md/raid1:failed to get CR on MESSAGE\n");
4664680c Goldwyn Rodrigues 2014-06-07 @530  		return;
4664680c Goldwyn Rodrigues 2014-06-07  531  	}
4664680c Goldwyn Rodrigues 2014-06-07  532  
4664680c Goldwyn Rodrigues 2014-06-07  533  	/* read lvb and wake up thread to process this message_lockres */

:::::: The code at line 530 was first introduced by commit
:::::: 4664680c389828928efc61ce3d2cf2c65ad35c97 Communication Framework: Receiving

:::::: TO: Goldwyn Rodrigues <rgoldwyn@suse.com>
:::::: CC: Goldwyn Rodrigues <rgoldwyn@suse.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
