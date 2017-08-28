From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 0/5] mdadm/test: Update for mdadm test part
Date: Mon, 28 Aug 2017 17:24:26 +0800
Message-ID: <1503912271-6463-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Hi, Jes;
  Here update trivial fixes for test part, add new test case
for readonly/readwrite feature and get rid of unused files.

Thanks,
Zhilong

Zhilong Liu (5):
  mdadm/bitmap: examine-bitmap failed when bitmap is external mode
  mdadm/test: use the first element of array as parsing condition
  mdadm/test: get rid of the tests/testdev
  mdadm/test: get rid of tests/check
  mdadm/test: add new testcase for testing readonly/readwrite

 bitmap.c         | 13 ++++++++-----
 test             |  2 +-
 tests/00readonly | 22 ++++++++++++++++++++++
 tests/check      | 35 -----------------------------------
 tests/testdev    | 13 -------------
 5 files changed, 31 insertions(+), 54 deletions(-)
 create mode 100644 tests/00readonly
 delete mode 100644 tests/check
 delete mode 100644 tests/testdev

-- 
2.6.6

