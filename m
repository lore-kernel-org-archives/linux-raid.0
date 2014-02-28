From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH 0/2] imsm: fixes for platform capabilities checking
Date: Fri, 28 Feb 2014 11:29:26 +0100
Message-ID: <1393583368-31542-1-git-send-email-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

These patches correct the behavior of mdadm on Intel platforms with more
than one AHCI controller with RAID capabilities.

When only one controller had RAID mode enabled in BIOS, IMSM platform
capabilities would be detected on both controllers. In EFI mode in some
situations IMSM capabilities were not detected at all.

Artur Paszkiewicz (2):
  imsm: support for second AHCI controller in EFI mode
  imsm: improved platform capabilities checking

 platform-intel.c | 27 +++++++++++++++++++++++----
 platform-intel.h |  3 ++-
 super-intel.c    | 13 ++++++-------
 3 files changed, 31 insertions(+), 12 deletions(-)

-- 
1.8.4.5

