From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: [PATCH 00/10] mdadm: reshape for external metadata
Date: Wed, 21 Jul 2010 12:16:30 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040804E2A49B3@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The following series implements:
 - non-grow reshape for external metadata
 - support for backup operations for external metadata
 - IMSM-specific implementation for critical data backups and 
	checkpointing using IMSM migration record

---

Maciej Trela (10):
      mdadm: second_map enhancement for imsm_get_map()
      mdadm: read chunksize and layout from mdstat
      mdadm: support non-grow reshape for external meta
      mdadm: Add IMSM migration record to intel_super
      mdadm: add backup methods to superswitch
      mdadm: support restore_stripes() from the given buffer
      Add mdadm->mdmon sync_max command message
      mdadm: support backup operations for imsm
      mdadm: support grow operation for external meta
      mdadm: migration restart for external meta


 Assemble.c    |    8 +
 Grow.c        |  325 +++++++++++++++++++++++--
 Makefile      |    4 
 managemon.c   |   78 +++++-
 mdadm.h       |   31 ++
 mdmon.h       |    6 
 mdstat.c      |   11 +
 monitor.c     |   76 ++++++
 msg.c         |   33 ++-
 msg.h         |    2 
 restripe.c    |   17 +
 super-intel.c |  738 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 util.c        |   18 +
 13 files changed, 1258 insertions(+), 89 deletions(-)  mode change 100644 => 100755 super-intel.c

--
Maciek Trela
