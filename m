From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH 0/2] Bad block notification
Date: Tue, 24 Jan 2017 13:03:37 +0100
Message-ID: <1485259419-2308-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, Jes.Sorensen@redhat.com, jes.sorensen@gmail.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

At the moment there is no way to be notified that bad blocks have been found on
a disk. It is only possible to check manually with 'mdadm --examine-badblocks'.
User might not be aware there is a bad block for a long period. If another disk
in the array fails, data is lost.

These patches add a new event to the kernel and mdadm in order to send
notification on the first bad block on a disk. I have chosen to do it only for
first bad block as I think it's sufficient indication that the drive requires
replacement.

Tomasz Majchrzak (1):
  md: add bad block flag to disk state

 drivers/md/md.c                | 2 ++
 include/uapi/linux/raid/md_p.h | 1 +
 2 files changed, 3 insertions(+)

Tomasz Majchrzak (1):
  Monitor: add new event BadBlocks

 Monitor.c  | 14 +++++++++-----
 md_p.h     |  1 + 
 mdadm.8.in | 10 ++++++++--
 3 files changed, 18 insertions(+), 7 deletions(-)

-- 
1.8.3.1

