From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: RE: cannot examine IMSM metadata on a disk in non-IMSM compliant
 system
Date: Tue, 22 Mar 2011 16:50:10 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D191E0AF4E@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

From 492192b1777936ccaf745aeb73f83f55c12a5a37 Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Tue, 22 Mar 2011 17:39:57 +0100
Subject: [PATCH 0/2] cannot examine IMSM metadata on a disk in non-IMSM compliant system

IMSM metadata handlers have following requirements:
- disk is attached to Intel controller (ahci or SAS)
- the whole disk set in one RAID volume belongs to the same controller
- IMSM OROM/EFI properties available

In non-IMSM system a user can always set IMSM_NO_PLATFORM=1, so above requirements need not to be met.

This series allows a user can check if there is any IMSM metadata on the disk in non-IMSM compatible system without setting IMSM_NO_PLATFORM.
Please take a look at my patches for this issue.
The patches are still under testing, only basics has been checked.

Thanks,
Marcin Labun


Marcin Labun (2):
  examine: allows to examine a disk metadata on non-metadata compliant
    systems
  super-intel: enable loading metadata from non-IMSM compliant disks

 Examine.c     |    2 ++
 mdadm.h       |    6 +++++-
 super-intel.c |   16 ++++++++++------
 util.c        |    3 +++
 4 files changed, 20 insertions(+), 7 deletions(-)

