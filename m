From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH V3 0/2] Fix build issues
Date: Mon, 18 May 2020 23:53:34 +0200
Message-ID: <20200518215336.29000-1-guoqing.jiang@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids

Hi Jes,

A new version per your comment, let me know if I still missed something.

V3 Change:
1. check the return value of lseek

V2 Changes:
1. copy the whole license from util.c to uuid.c
2. check the return value of read correctly

Thanks,
Guoqing

Guoqing Jiang (2):
  uuid.c: split uuid stuffs from util.c
  restripe: fix ignoring return value of ‘read’ and lseek

 Makefile   |   6 +--
 restripe.c |  12 +++++-
 util.c     |  87 -----------------------------------------
 uuid.c     | 112 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 125 insertions(+), 92 deletions(-)
 create mode 100644 uuid.c

-- 
2.17.1
