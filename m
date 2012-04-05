From: Przemyslaw Czarnowski
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 0/4] Imsm OROM compatibility/boot support fixes
Date: Thu, 05 Apr 2012 17:28:12 +0200
Message-ID: <20120405152553.19851.48052.stgit@linux.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

This series of patches contain fixes regarding OROM and mdadm compatibility
connected with handling of recovery/degraded states and missing disks.
OROM behaves little differently when it marks disk as missing (see description
of patches for details)
Last one in the series does not allow to modify metadata (in particular does
not finish migration) on disks when array is set to read only by kernel
(eg. during restart of system, when root partition lies on raid device).

---

Przemyslaw Czarnowski (4):
      imsm: monitor: do not finish migration if there are no failed disks
      imsm: clean up missing disks if there are any left after migration
      imsm: avoid double change of serial number of missing device
      imsm: monitor: do not finish recovery, when raid goes to read-only


 monitor.c     |    1 +
 super-intel.c |   33 ++++++++++++++++++++++++---------
 2 files changed, 25 insertions(+), 9 deletions(-)

