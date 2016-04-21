From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 09/13] md-cluster: always setup in-memory bitmap
Date: Thu, 21 Apr 2016 15:00:35 +0800
Message-ID: <201604211452.TEhZl8El%fengguang.wu@intel.com>
References: <1461218294-4960-10-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461218294-4960-10-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: kbuild-all@01.org, shli@kernel.org, neilb@suse.de, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

Hi,

[auto build test WARNING on v4.6-rc4]
[also build test WARNING on next-20160420]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Guoqing-Jiang/The-latest-patches-for-md-cluster/20160421-140507


coccinelle warnings: (new ones prefixed by >>)

>> drivers/md/bitmap.c:2049:6-11: WARNING: NULL check before freeing functions like kfree, debugfs_remove, debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider reorganizing relevant code to avoid passing NULL values.

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
