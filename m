From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 00/12] md-cluster: code improvement, fixs and new feature
Date: Fri, 10 Jul 2015 16:54:01 +0800
Message-ID: <1436518453-12660-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: rgoldwyn@suse.de, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

This series mostly do the following jobs:

1. code improvement
	0001-md-cluster-use-pU-to-print-UUIDs.patch
	0006-md-cluster-add-the-error-check-if-failed-to-get-dlm-.patch
	0008-md-cluster-remove-the-unused-sb_lock.patch
	0009-md-cluster-add-missed-lockres_free.patch
	0010-md-cluster-only-call-complete-cinfo-completion-when-.patch
	0011-md-cluster-Read-the-disk-bitmap-sb-and-check-if-it-n.patch
	0012-md-cluster-handle-error-situations-more-precisely-in.patch
2. fixs some dlm issues and crash problem
	0004-md-cluster-fix-deadlock-issue-on-message-lock.patch
	0005-md-cluster-init-completion-within-lockres_init.patch
	0007-md-cluster-init-suspend_list-and-suspend_lock-early-.patch
3. new feature - When node A stop an array while the array is doing resync,
we need let another node B to take over the resync task.
	0002-md-cluster-split-recover_slot-for-future-code-reuse.patch
	0003-md-cluster-transfer-the-resync-ownership-to-another-.patch

Guoqing Jiang (12):
  md-cluster: use %pU to print UUIDs
  md-cluster: split recover_slot for future code reuse
  md-cluster: transfer the resync ownership to another node
  md-cluster: fix deadlock issue on message lock
  md-cluster: init completion within lockres_init
  md-cluster: add the error check if failed to get dlm lock
  md-cluster: init suspend_list and suspend_lock early in join
  md-cluster: remove the unused sb_lock
  md-cluster: add missed lockres_free
  md-cluster: only call complete(&cinfo->completion) when node join
    cluster
  md-cluster: Read the disk bitmap sb and check if it needs recovery
  md-cluster: handle error situations more precisely in lockres_init

 Documentation/md-cluster.txt |   4 +-
 drivers/md/md-cluster.c      | 162 +++++++++++++++++++++++++++++--------------
 drivers/md/md.c              |   6 +-
 3 files changed, 114 insertions(+), 58 deletions(-)

-- 
1.7.12.4

