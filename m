From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH 0/2] Fix build issues
Date: Fri, 15 May 2020 15:40:24 +0200
Message-ID: <20200515134026.8084-1-guoqing.jiang@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids

Hi Jes,

The first patch resolve the build issue of 'make raid6check', and the second
one is for the issue which appeared during 'make everything'. Maybe it is
better to resolve the issues before release 4.2.

BTW, compile test only.

Thanks,
Guoqing

Guoqing Jiang (2):
  uuid: split uuid.c from util.c
  restripe: fix ignoring return value of ‘read’

 Makefile   |  6 ++--
 restripe.c |  6 +++-
 util.c     | 87 ---------------------------------------------------
 uuid.c     | 92 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 100 insertions(+), 91 deletions(-)
 create mode 100644 uuid.c

-- 
2.17.1
