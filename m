From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 00/13] imsm: new imsm metadata features
Date: Thu, 22 Apr 2010 23:10:21 +0100
Message-ID: <66C59AD0932712458090B447266D638CD405E3B1@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

The following series of patches adds two new functionalities to mdadm for
Intel metadata: Volume Delete and Volume Rename.
The patches makes Linux SW RAID implementation based on imsm metadata closer
to Intel(R) Rapid Storage Technology for Windows(TM). 
Patches 1-6 contain fixes of bugs found during development and modifications
of existing code making main features easier to implement.
Patches 7-9 contain implementation of Volume Delete; ie. makes possible to
remove only one volume from container while the other one keeps running.
Patches 10-12 makes possible to change internal serial ID of volume leaving
the rest of superblock data untouched.
The last patch contains an update of manual page for above features.

[PATCH 01/13] fix: memory leak in mdmon_pid()
[PATCH 02/13] map file: Extract record update routine from map_update
[PATCH 03/13] Add mdstat_by_component
[PATCH 04/13] fix: possible segfault if current_vol does not match subarray
[PATCH 05/13] sysfs: simple write to sysfs file
[PATCH 06/13] imsm: delete subarray metadata manipulation routine
[PATCH 07/13] imsm: extension of delete subarray to handle active container
[PATCH 08/13] mdmon: enable delete subarray for managed containers
[PATCH 09/13] imsm: delete subarray: main procedure and command line support
[PATCH 10/13] imsm: rename subarray functionality
[PATCH 11/13] mdmon: enable rename subarray for managed containers
[PATCH 12/13] imsm: rename subarray: main procedure and command line support
[PATCH 13/13] manual: update for subarray delete/rename

ps. It is reworked version of patches sent earlier.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 Kill.c        |   58 ++++++++++++
 Makefile      |    4 +-
 Manage.c      |   88 +++++++++++++++++++
 ReadMe.c      |    1 +
 mapfile.c     |   31 +++++--
 mdadm.8       |   27 ++++++
 mdadm.c       |   32 ++++++-
 mdadm.h       |   35 ++++++++
 mdstat.c      |   69 ++++++++++++++--
 super-intel.c |  253 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 sysfs.c       |   21 +++++
 util.c        |  268 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 12 files changed, 864 insertions(+), 23 deletions(-)

--
Best Regards,
Przemyslaw Hawrylewicz-Czarnowski
Software Development Engineer

