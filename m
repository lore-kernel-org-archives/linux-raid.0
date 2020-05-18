From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH V2 0/2] Fix build issues
Date: Mon, 18 May 2020 21:31:06 +0200
Message-ID: <20200518193108.26102-1-guoqing.jiang@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids

Hi Jes,

Hopefully this version addresses your comments.

V2 Changes:
1. copy the whole license from util.c to uuid.c
2. check the return value of read correctly

Thanks,
Guoqing

Guoqing Jiang (2):
  uuid.c: split uuid stuffs from util.c
  restripe: fix ignoring return value of ‘read’

 Makefile   |   6 +--
 restripe.c |  10 ++++-
 util.c     |  87 -----------------------------------------
 uuid.c     | 112 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 124 insertions(+), 91 deletions(-)
 create mode 100644 uuid.c

-- 
2.17.1
