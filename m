From: Xiao Ni <xni@redhat.com>
Subject: [MDADM PATCH -v5 0/1] add one mdadm test case
Date: Tue, 10 Oct 2017 19:32:51 +0800
Message-ID: <1507635172-7407-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com, zlliu@suse.com
List-Id: linux-raid.ids

Hi all

Sorry for forgeting this patch. It adds one test case for
raid5 reshape. Please review.

Xiao Ni (1):
  mdadm/test: Add one test case for raid5 reshape

 test           |  7 +++++++
 tests/02r5grow | 17 +++++++++++++++++
 2 files changed, 24 insertions(+)

-- 
2.7.4

