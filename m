From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 0/2] imsm: new imsm metadata features
Date: Wed, 31 Mar 2010 21:49:45 +0100
Message-ID: <66C59AD0932712458090B447266D638CD3C7EAF1@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

The following series of patches adds two new functionalities to
mdadm that makes linux raid implementation based on imsm metadata
closer to the abilities of Intel(R) Rapid Storage Technology for
Windows(R). Patches makes possible to remove one volume from
container when the other one is still running. It is also possible
to change internal serial ID of volume leaving remaining superblock
data untouched.

Patch 1/2 provides the code of subarray delete
Patch 2/2 provides the code of subarray rename.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 Kill.c        |   58 +++++++++++
 Makefile      |    4 +-
 Manage.c      |   95 +++++++++++++++++++
 ReadMe.c      |    1 +
 mapfile.c     |   31 ++++--
 mdadm.c       |   32 ++++++-
 mdadm.h       |   36 +++++++
 mdstat.c      |   86 ++++++++++++++++-
 super-intel.c |  245 +++++++++++++++++++++++++++++++++++++++++++++++-
 sysfs.c       |   21 ++++
 util.c        |  293 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 11 files changed, 883 insertions(+), 19 deletions(-)

--
Best Regards,
Przemyslaw Hawrylewicz-Czarnowski

