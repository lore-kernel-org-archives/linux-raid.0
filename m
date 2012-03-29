From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 0/6] imsm: 2TB disks/volumes support
Date: Thu, 29 Mar 2012 12:42:53 +0000
Message-ID: <3F8F31A3BFD1664EAB894D1BD6AF32B918A205C6@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Grabowski, Grzegorz" <grzegorz.grabowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Hi Neil,
this patch series provides initial support for 2TB disk and volumes for imsm metadata.
Patches 1,2 ensure correct representation and interpretation of sizes in metadata
Patch 3 refactors code a little to make calc_array_size usable for all levels
Patch 4 gives the user information about large disks/volumes support in orom
Patches 4,5 prevent creation of volume/container when not supported by orom

There are more cases to be checked, for example creation of small volume on existing container using large disks,
adding large disks to container, olce leading to large volume etc.  

[PATCH 1/6] imsm: avoid overflows for disks over 1TB
[PATCH 2/6] clear hi bits if not used after loading metadata from disk
[PATCH 3/6] simplify calculating array_blocks
[PATCH 4/6] show 2TB volumes/disks support in --detail-platform
[PATCH 5/6] check volume size in validate_geometry_imsm_orom
[PATCH 6/6] check that no disk over 2TB is used to create container when no support

platform-intel.h |    1 +
super-intel.c    |  271 +++++++++++++++++++++++++++++++++++++-----------------
util.c           |    2 +
3 files changed, 191 insertions(+), 83 deletions(-)

Regards
Anna
