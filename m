From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH 00/12] Multiple PPL support and PPL bugfixes
Date: Thu, 28 Sep 2017 14:41:06 +0200
Message-ID: <20170928124118.23361-1-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Pawel Baldysiak <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

This patchset introduces userspace support for multiple PPLs written in a
circular buffer. It also contains few general bug fixes for PPL, and
couple of IMSM specific compatibility patches related to new PPL.

Artur Paszkiewicz (5):
  Don't abort starting the array if kernel does not support ppl
  imsm: don't skip resync when an invalid ppl header is found
  imsm: always do ppl recovery when starting a rebuilding array
  imsm: use correct map when validating ppl
  imsm: write initial ppl on a disk added for rebuild

Pawel Baldysiak (7):
  super1: Add support for multiple-ppls
  imsm: Add support for multiple ppls
  imsm: validate multiple ppls during assemble
  Zeroout whole ppl space during creation/force assemble
  imsm: switch to multiple ppls automatically during assemble
  Grow: fix switching on PPL during recovery
  imsm: Write empty PPL header if assembling regular clean array.

 Grow.c        |   3 -
 managemon.c   |  11 +++-
 mdadm.h       |   1 +
 super-intel.c | 181 ++++++++++++++++++++++++++++++++++++++++++++--------------
 super1.c      |  70 ++++++++++++++---------
 sysfs.c       |   6 +-
 util.c        |  49 ++++++++++++++++
 7 files changed, 241 insertions(+), 80 deletions(-)

-- 
2.13.5

