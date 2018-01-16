From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 0/8] Enable clustered raid testing in mdadm
Date: Tue, 16 Jan 2018 17:45:01 +0800
Message-ID: <1516095909-12968-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Hi Jes,

Since cluster-md feature has delivered and also served for SUSE distributions
in a long time, this patch-set mainly supports to test the clustered-raid1/10,
and provide simple example cases, the rest cases would be a new patch-set once
the cluster-raid frame ideas got accepted.

By now, mdadm has two suites to cover testing traditional soft-raid and cluster
raid, the new option '--testdir' would support to switch choosing which suite to
test, leave core functions in 'test' file and move other functions to its source
file under tests/ and clustermd_tests/ folder.

Thanks,
Zhilong

Zhilong Liu (8):
  mdadm/test: correct the logic operation in save_log
  mdadm/test: move some functions to new source file
  mdadm/test: enable clustermd testing under clustermd_tests/
  mdadm/test: add '--testdir=' to switch choosing test suite
  mdadm/clustermd_tests: add test case to test creating cluster-raid1
  mdadm/clustermd_tests: add test case to test grow_resize cluster-raid1
  mdadm/clustermd_tests: add test case to test creating cluster-raid10
  mdadm/clustermd_tests: add test case to test grow_resize
    cluster-raid10

 clustermd_tests/00r10_Create      |  50 +++++
 clustermd_tests/00r1_Create       |  50 +++++
 clustermd_tests/01r10_Grow_resize |  38 ++++
 clustermd_tests/01r1_Grow_resize  |  23 +++
 clustermd_tests/cluster_conf      |  43 +++++
 clustermd_tests/func.sh           | 320 ++++++++++++++++++++++++++++++++
 test                              | 380 +++-----------------------------------
 tests/func.sh                     | 348 ++++++++++++++++++++++++++++++++++
 8 files changed, 901 insertions(+), 351 deletions(-)
 create mode 100644 clustermd_tests/00r10_Create
 create mode 100644 clustermd_tests/00r1_Create
 create mode 100644 clustermd_tests/01r10_Grow_resize
 create mode 100644 clustermd_tests/01r1_Grow_resize
 create mode 100644 clustermd_tests/cluster_conf
 create mode 100644 clustermd_tests/func.sh
 create mode 100644 tests/func.sh

-- 
2.6.6

