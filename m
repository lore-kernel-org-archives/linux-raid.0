From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [md PATCH 0/8] Enable OLCE for external IMSM metadata
Date: Wed, 24 Feb 2010 07:42:17 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D1016F65B7@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

The following patch series enables OLCE (On-Line Capacity Expansion) functionality for external IMSM metadata.

Please note that this patch series requires takeover functionality.
---

Adam Kwolek (8):
      OLCE: Workaround for set size problem
      OLCE: Fix for bio I/O error
      OLCE: Changes to raid5 required by raid0
      OLCE: new_dev and raid_disks changes
      OLCE: Synchronization with mdmon
      OLCE: changes to meta update md_update_sb()
      OLCE: add wait_reshape()
      OLCE: add sync_completed handler


 md/md.c    |  213 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 md/md.h    |   12 +++
 md/raid5.c |  240 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 452 insertions(+), 13 deletions(-)

--
Adam Kwolek

