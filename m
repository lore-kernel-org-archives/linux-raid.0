From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 0/5] imsm: validate the number of imsm volumes per controller
Date: Fri, 13 Jan 2012 11:19:48 +0000
Message-ID: <F9123E44003394499FDD2B17C60621D4075DB6@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: "neilb@suse.de" <neilb@suse.de>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

Subject: [PATCH 0/5] imsm: validate the number of imsm volumes per controller
                                                            
    IMSM OROM/EFI limits number of volumes per controller. Volumes
    above the limit are blocked in OROM. mdadm should follow OROM limitations
    in this area. Therefore 
    - we need to count number of volumes on the devices
    attached to SATA (ahci driver) or SAS (isci) controller. Adding a new volume
    must be blocked if the number of volumes on devices attached to the given
    controller is exceeded.      
    - we need to block activation of a volume if the number of active volume devices
    devices attached to the given controller is exceeded.      

Marcin Labun (5):
  imsm: load_super_imsm_all function refactoring
  imsm: load_imsm_super_all supports loading metadata from the device
    list
  imsm: validate the number of imsm volumes per controller
  imsm: display fd in error trace when when store_imsm_mpb failes
  imsm: verify maximum supported active volumes in assembly

 Assemble.c    |    3 +-
 Grow.c        |    6 +-
 Incremental.c |    3 +-
 mdadm.h       |    1 +
 super-intel.c |  689 +++++++++++++++++++++++++++++++++++++++++++++++++++------
 util.c        |    1 +
 6 files changed, 633 insertions(+), 70 deletions(-)

