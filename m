From: kbuild test robot <fengguang.wu@intel.com>
Subject: [md:for-next 14/48] drivers/md/md-cluster.c:190:6: sparse: symbol
 'recover_bitmaps' was not declared. Should it be static?
Date: Sat, 28 Feb 2015 07:04:37 +0800
Message-ID: <201502280727.kOhvF4kI%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: kbuild-all@01.org, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

tree:   git://neil.brown.name/md for-next
head:   5d98513a2e546337c0deb93d772eb0c988d47c1d
commit: e94987db2ed983aea4e45d22db9e17c6bbf2a623 [14/48] Initiate recovery on node failure
reproduce:
  # apt-get install sparse
  git checkout e94987db2ed983aea4e45d22db9e17c6bbf2a623
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/md/md-cluster.c:178:15: sparse: restricted __le64 degrades to integer
>> drivers/md/md-cluster.c:190:6: sparse: symbol 'recover_bitmaps' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
