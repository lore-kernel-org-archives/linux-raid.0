From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 0/4] mdadm/test: Update for mdadm test part
Date: Wed, 19 Jul 2017 19:11:11 +0800
Message-ID: <1500462675-6463-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

1. add a new unit case for testing readonly/readwrite feature, it
   covers common metadata versions and raid levels.
2. fixed a issue reported by Xiao Ni, shell got parsing error when
   array[] has few members, so just check the array[0] is enough.
3. get rid of the useless test files.

Thanks,
Zhilong

Zhilong Liu (4):
  test/00readonly: Add unit case for testing readonly/readwrite
  mdadm/test: Fixed the condition parsing error for array[]
  mdadm/test: Get rid of tests/testdev
  mdadm/test: Get rid of tests/check

 test             |  2 +-
 tests/00readonly | 20 ++++++++++++++++++++
 tests/check      | 35 -----------------------------------
 tests/testdev    | 13 -------------
 4 files changed, 21 insertions(+), 49 deletions(-)
 create mode 100644 tests/00readonly
 delete mode 100644 tests/check
 delete mode 100644 tests/testdev

-- 
1.8.3.1

