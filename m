From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH v2 0/9] Bad block support for IMSM metadata
Date: Tue, 29 Nov 2016 14:02:26 +0100
Message-ID: <1480424555-31509-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

This series of patches implements bad block support for IMSM metadata.

Requested changes have been applied to the first 2 patches. The whole set is
resent because the previous patches don't apply cleanly on the latest upstream
branch. An extra patch has been added which adds 4kn support for bad block log.

Regards,

Tomek

Tomasz Majchrzak (9):
  imsm: parse bad block log in metadata on startup
  imsm: write bad block log on metadata sync
  imsm: give md list of known bad blocks on startup
  imsm: record new bad block in bad block log
  imsm: clear bad block from bad block log
  imsm: clear bad blocks if disk becomes unavailable
  imsm: provide list of bad blocks for an array
  imsm: implement "--examine-badblocks" command
  imsm: 4kn support for bad block log

 super-intel.c | 640 ++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 574 insertions(+), 66 deletions(-)

-- 
1.8.3.1

