From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH 0/4] IMSM: Add support for 4Kn sector size drives
Date: Thu, 10 Nov 2016 15:28:14 +0100
Message-ID: <1478788098-32041-1-git-send-email-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Pawel Baldysiak <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

This patch set adds support for IMSM with 4Kn sector size drives
First patch adds the generic function for receiving sector size,
rest are IMSM specific.
Internal calculation are still based on 512-bytes sector,
variables are converted during read/write from/to member drive.
Mixing of devices with different sector size is not allowed.

Pawel Baldysiak (4):
  Add function for getting member drive sector size
  IMSM: Read and store device sector size
  IMSM: Add support for 4Kn sector size drives
  IMSM: 4Kn drives support - adapt general migration record

 mdadm.h       |   1 +
 super-intel.c | 315 +++++++++++++++++++++++++++++++++++++++++++++-------------
 super1.c      |   3 +-
 util.c        |  16 +++
 4 files changed, 265 insertions(+), 70 deletions(-)

-- 
2.7.4

