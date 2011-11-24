From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 00/11] Degradation during reshape
Date: Thu, 24 Nov 2011 13:17:10 +0100
Message-ID: <20111124121516.5254.48774.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

The following series implements support for array degradation during reshape.

Series mostly fixes problems in handling degradation during reshape 
in imsm metadata .

Main common problem that last patch resolves is is lack of BBM support.
md on disk failure reports BBM event to user space and waits for an answer.
The side effect of this action is stopping reshape process. The last patch
/together with md patch sent separately/ allows for disabling BBM mechanism.
This is similar as native metadata v0.9 works.

BR
Adam

---

Adam Kwolek (11):
      Disable BBM when it is not supported
      imsm: FIX: Check maximum allowed degradation level in recover_backup_imsm()
      imsm: FIX: Check maximum allowed degradation level in open_backup_targets()
      imsm: FIX: Function rework - imsm_count_failed()
      imsm: FIX: Manage second map state on array degradation
      imsm: FIX: Restore critical section on degraded array
      imsm: FIX: Remove single map state limitation in getinfo
      imsm: FIX: Finalize degraded migration
      imsm: FIX: Do not end migration when missing drive is handled
      imsm: FIX: Mark both maps on degradation while migrating
      imsm: FIX: Return longer map for failure setting


 Assemble.c    |    2 
 Manage.c      |    3 -
 managemon.c   |    3 -
 mdadm.h       |    4 +
 super-intel.c |  323 +++++++++++++++++++++++++++++++++++++++++++++------------
 sysfs.c       |    7 +
 util.c        |    2 
 7 files changed, 268 insertions(+), 76 deletions(-)

-- 
Signature
