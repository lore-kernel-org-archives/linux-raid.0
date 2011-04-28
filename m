From: Przemyslaw Czarnowski
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 0/5] Support for IMSM raid0->raid5 migration
Date: Thu, 28 Apr 2011 23:59:32 +0200
Message-ID: <20110428215751.19632.5381.stgit@gklab-128-081.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

The following series implements support for raid0->raid5 migration for IMSM
metadata. These patches also blocks opposite direction of migration.
Code mostly bases on patches sent to you by Adam Kwolek. I have incorporated
your remarks and I tested it quite extensively for comformity with IMSM
standard. I have also removed opposite direction, as it is:
* not standarized yet,
* the design is not settled with you,
* generic grow routines are not compatible with change of chunk size.

Please do not include these patches on 'master' branch, as they are supposed
to be a part of next minor mdadm version (ie. mdadm 3.2.3). I think good place
for them is 'devel-3.2'. Master should be reserved just for bug/stability fixes
for previous release.
---

Przemyslaw Czarnowski (5):
      imsm: prepare update for level migrations reshape
      imsm: fix: disable migration from raid5->raid0
      imsm: prepare memory for level migration update
      imsm: process update for raid level migrations
      imsm: add new chunk size to metadata update


 super-intel.c |  343 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 333 insertions(+), 10 deletions(-)

-- 
Best Regards,
Przemyslaw Czarnowski
