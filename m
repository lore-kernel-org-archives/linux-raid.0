From: Xiao Ni <xni@redhat.com>
Subject: [MDADM PATCH 0/2] /dev/md0 can't be released immediatly
Date: Tue, 19 Sep 2017 14:06:45 +0800
Message-ID: <1505801207-10096-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, jes.sorensen@gmail.com
List-Id: linux-raid.ids

Hi all

The device node /dev/md0 can't be released immediatly after the command
mdadm -S /dev/md0 or mdadm -Ss.

We should give enough time to udev to handle udev events.

Xiao Ni (2):
  Close mdfd before returning main function
  Give enough time to udev to handle events

 Create.c |  2 +-
 mdadm.c  | 16 ++++++++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

-- 
2.7.4

