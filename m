From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 00/19] mdadm/clustermd_tests: update the testing part
Date: Fri,  2 Feb 2018 14:10:44 +0800
Message-ID: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, gqjiang@suse.com, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Hi Jes,

This patch-set mainly focus on improving test part and adding some new
test cases for cluster-md.

Improving:
1. filter the r10(raid10) from raid1 in raidtype, because the cluster-md
test cases named r10 as contraction rule.
2. adding disk metadata in save_log() if found working array.
3. adding do_clean() in do_test() to ensure each case only capture its own
test logs.
4. adding prompt in --zero-superblock part of man-page. It should be careful
to call --zero when operating clustered raids.

Cluster-md new cases:
1. cover testing switch bitmap among 'clustered', 'none' and 'internal' mode
against clustered raid1/10.
2. cover testing switch resync/recovery against clustered raid1/10.
3. cover testing manage mode(add/add-spare/re-add) against raid1/10.
4. add testing grow mode(add) against raid1, currently it's not supported by
clustered raid10.


Thanks,
Zhilong

Zhilong Liu (19):
  mdadm/test: improve filtering r10 from raid1 in raidtype
  mdadm/test: add disk metadata infos in save_log
  mdadm/test: add do_clean to ensure each case only catch its own
    testlog
  mdadm/clustermd_tests: add nobitmap in check
  mdadm/clustermd_tests: delete meaningless commands in check
  manpage: add prompt in --zero-superblock against clustered raid
  clustermd_tests: add test case to test switching bitmap against
    cluster-raid1
  clustermd_tests: add test case to test switching bitmap against
    cluster-raid10
  clustermd_tests: add test case to test grow_add against cluster-raid1
  clustermd_tests: add test case to test manage_add against
    cluster-raid1
  clustermd_tests: add test case to test manage_add against
    cluster-raid10
  clustermd_tests: add test case to test manage_add-spare against
    cluster-raid1
  clustermd_tests: add test case to test manage_add-spare against
    cluster-raid10
  clustermd_tests: add test case to test manage_re-add against
    cluster-raid1
  clustermd_tests: add test case to test manage_re-add against
    cluster-raid10
  clustermd_tests: add test case to test switch-resync against
    cluster-raid1
  clustermd_tests: add test case to test switch-resync against
    cluster-raid10
  clustermd_tests: add test case to test switch-recovery against
    cluster-raid1
  clustermd_tests: add test case to test switch-recovery against
    cluster-raid10

 clustermd_tests/01r10_Grow_bitmap-switch | 51 ++++++++++++++++++++++++
 clustermd_tests/01r1_Grow_add            | 68 ++++++++++++++++++++++++++++++++
 clustermd_tests/01r1_Grow_bitmap-switch  | 51 ++++++++++++++++++++++++
 clustermd_tests/02r10_Manage_add         | 33 ++++++++++++++++
 clustermd_tests/02r10_Manage_add-spare   | 30 ++++++++++++++
 clustermd_tests/02r10_Manage_re-add      | 18 +++++++++
 clustermd_tests/02r1_Manage_add          | 33 ++++++++++++++++
 clustermd_tests/02r1_Manage_add-spare    | 30 ++++++++++++++
 clustermd_tests/02r1_Manage_re-add       | 18 +++++++++
 clustermd_tests/03r10_switch-recovery    | 21 ++++++++++
 clustermd_tests/03r10_switch-resync      | 18 +++++++++
 clustermd_tests/03r1_switch-recovery     | 21 ++++++++++
 clustermd_tests/03r1_switch-resync       | 18 +++++++++
 clustermd_tests/func.sh                  | 20 ++++++++--
 mdadm.8.in                               |  4 ++
 test                                     |  6 +--
 tests/func.sh                            | 10 ++++-
 17 files changed, 441 insertions(+), 9 deletions(-)
 create mode 100644 clustermd_tests/01r10_Grow_bitmap-switch
 create mode 100644 clustermd_tests/01r1_Grow_add
 create mode 100644 clustermd_tests/01r1_Grow_bitmap-switch
 create mode 100644 clustermd_tests/02r10_Manage_add
 create mode 100644 clustermd_tests/02r10_Manage_add-spare
 create mode 100644 clustermd_tests/02r10_Manage_re-add
 create mode 100644 clustermd_tests/02r1_Manage_add
 create mode 100644 clustermd_tests/02r1_Manage_add-spare
 create mode 100644 clustermd_tests/02r1_Manage_re-add
 create mode 100644 clustermd_tests/03r10_switch-recovery
 create mode 100644 clustermd_tests/03r10_switch-resync
 create mode 100644 clustermd_tests/03r1_switch-recovery
 create mode 100644 clustermd_tests/03r1_switch-resync

-- 
2.6.6

