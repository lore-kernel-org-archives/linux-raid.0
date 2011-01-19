From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 0/5] Intel SAS controller support for IMSM
Date: Wed, 19 Jan 2011 17:13:20 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176EFD548@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From 90d6284900559fa62abe918c71d3d47c844dab3d Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Wed, 19 Jan 2011 17:23:53 +0100
Subject: [PATCH 0/5] Intel SAS controller support for IMSM

This series introduces support for Intel SAS controller (isci module) built in Intel(R) Patsburg
chipset. IMSM handler blocks mixing devices attached to different type of controllers in the same container.
This standard operation maintains compatibility between Linux and Windows IMSM RAID
stacks and allows for boot support from Optional ROM.
User can set IMSM_NO_PLATFORM environment variable to block the standard operation.
 


Marcin Labun (5):
  imsm platform: support for Intel(R) SAS controller.
  imsm: support for Intel(R) SAS controller in imsm handler
  imsm: prepare detail_platform_imsm to support different types of controllers
  imsm: detail_platform_imsm supports Intel SAS controller (isci driver)
  imsm: support for Intel SAS controller in get_disk_controller_domain handler

 platform-intel.c |   67 +++++++---
 platform-intel.h |   16 +++
 super-intel.c    |  366 ++++++++++++++++++++++++++++++++++++++++--------------
 3 files changed, 333 insertions(+), 116 deletions(-)

