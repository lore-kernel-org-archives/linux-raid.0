From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [mdadm PATCH 0/11] Enable OLCE for external IMSM metadata
Date: Wed, 24 Feb 2010 07:44:33 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D1016F65C1@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

The following patch series enables OLCE (On-Line Capacity Expansion) functionality for external IMSM metadata.

Please note that this patch series requires takeover functionality.

---

Adam Kwolek (11):
      OLCE: Rebuild FIX
      OLCE: Workaround for mdstat problems
      OLCE: OLCE works on whole container for IMSM
      OLCE: Add OLCE Limitations
      OLCE: use takeover to raid5 for raid0 OLCE
      OLCE: OLCE implementation
      OLCE: Prepare takeover for OLCE
      OLCE: Use takeover for add spare to Raid0
      OLCE: abuf, bbuf buffer managment fix
      OLCE: Before OLCE code cleanup and add checks
      OLCE: Add show_meta()


 mdadm/mdadm/Assemble.c       |   14 -
 mdadm/mdadm/Create.c         |   10 
 mdadm/mdadm/Detail.c         |   11 -
 mdadm/mdadm/Grow.c           |  571 ++++++++++++++++++++++++--
 mdadm/mdadm/Incremental.c    |   28 +
 mdadm/mdadm/Manage.c         |  188 +++++++--
 mdadm/mdadm/Monitor.c        |   23 +
 mdadm/mdadm/config.c         |   49 +-
 mdadm/mdadm/dlink.c          |   17 +
 mdadm/mdadm/managemon.c      |  295 +++++++++++--
 mdadm/mdadm/mapfile.c        |   23 +
 mdadm/mdadm/mdadm.h          |    1 
 mdadm/mdadm/mdmon.c          |    7 
 mdadm/mdadm/mdmon.h          |   13 +
 mdadm/mdadm/mdopen.c         |    4 
 mdadm/mdadm/mdstat.c         |   26 +
 mdadm/mdadm/monitor.c        |  164 +++++++
 mdadm/mdadm/msg.c            |   10 
 mdadm/mdadm/platform-intel.c |    9 
 mdadm/mdadm/restripe.c       |   12 -
 mdadm/mdadm/super-intel.c    |  919 ++++++++++++++++++++++++++++++++++--------
 mdadm/mdadm/sysfs.c          |   60 ++-
 mdadm/mdadm/util.c           |  187 ++++++---
 23 files changed, 2177 insertions(+), 464 deletions(-)

-- 
Adam Kwolek
