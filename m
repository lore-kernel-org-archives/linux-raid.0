From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 00/14] OROM/EFI support for Intel SAS and AHCI controllers
 in IMSM
Date: Tue, 8 Mar 2011 15:20:20 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17A8AEC88@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From 8851572a406e938f50466a98405b10529048e766 Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Tue, 8 Mar 2011 15:24:09 +0100
Subject: [PATCH 00/14] OROM/EFI support for Intel SAS and AHCI controllers in IMSM

IMSM metadata supports retrieving RAID capabilities for:
- Intel SAS controller with Legacy OROM
- Intel SAS controller with EFI
- Intel AHCI controller with Legacy OROM
- AHCI controller with EFI
IMSM Metadata handlers constrain RAID configurations to those supported EFI/OROM for Intel AHCI or SAS controller.


Marcin Labun (11):
  probe_roms: allow to probe expansion ROMs using vendor and device id.
  Platform-intel: support for OROM SAS and AHCI controller
  imsm: remove unused parameters in function attach_hba_to_super
  imsm: detail_platform_imsm displays AHCI and SAS controller
    information
  imsm: do not publish OROM/EFI unsupported arrays
  imsm: print-out error message when volume validation fails
  imsm: add maximum number of disk validation in RAID array
  imsm: verify that component disks are attached to the same type of
    HBA
  imsm: move code for retrieving HBA to a function
  imsm: introduce SAS controller support in imsm metadata handler
  platform_intel: support for OROM OEM capabilities

Przemyslaw Czarnowski (3):
  update of imsm_orom structure
  Some guid manipulation utilities has been added.
  read platform capabilities from EFI

 platform-intel.c |  221 ++++++++++++++++++++++++++++++-----
 platform-intel.h |   39 ++++++-
 probe_roms.c     |   29 ++++-
 probe_roms.h     |    2 +-
 super-intel.c    |  339 +++++++++++++++++++++++++++++++++++++-----------------
 5 files changed, 488 insertions(+), 142 deletions(-)

