From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH 0/5] imsm: support for NVMe devices and AHCI spanning
Date: Wed, 19 Nov 2014 13:53:25 +0100
Message-ID: <1416401610-16209-1-git-send-email-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

This set of patches adds support for IMSM metadata with Intel NVMe devices and
for multiple AHCI HBAs with separate and combined OROMs. This enables spanning
between AHCI HBAs if the firmware supports it. It also improves checking of
IMSM platform capabilities and printing them with detail-platform.

Artur Paszkiewicz (4):
  imsm: support for OROMs shared by multiple HBAs
  imsm: support for second and combined AHCI controllers in UEFI mode
  imsm: detail-platform improvements
  imsm: use efivarfs interface for reading UEFI variables

Pawel Baldysiak (1):
  imsm: add support for NVMe devices

 platform-intel.c | 339 +++++++++++++++++++++++++++++++++++++++----------------
 platform-intel.h |  33 +++++-
 super-intel.c    | 232 +++++++++++++++++++++++++------------
 3 files changed, 437 insertions(+), 167 deletions(-)

-- 
1.8.4.5

