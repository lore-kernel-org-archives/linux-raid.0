From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: [PATCH 0/2] md: migrations for external metadata
Date: Wed, 21 Jul 2010 12:03:07 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040804E2A498E@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Neil,
I'm sending the patches for external metadata migrations.
Both md/mdadm patches are based on OLCE patches sent by 
Adam Kwolek some time ago.

The most important issues that are implemented:
1. support for non-grow reshape (OLCE patches were focused on 
   grow-reshape with new devices added)
2. mdadm critical data backup mechanism for external metadata.
   This includes:
	- new external API for handling backups
	- IMSM specific implementation for backups and checkpointing
		that uses IMSM migration record
3. compatibility issues with IMSM metadata

---

Maciej Trela (2):
      md: raid5 return new layout in mdstat while reshaping
      md: raid5: update suspend_hi during the reshape


 drivers/md/raid5.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

-- 
Maciek Trela
