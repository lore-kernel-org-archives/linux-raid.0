From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/4] Fix freezing multiple arrays in container during assembly
	(2)
Date: Mon, 03 Oct 2011 18:13:30 +0200
Message-ID: <20111003160839.18410.33275.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

The following series corrects freezing reshaped array in container during
assembly while other arrays are present.

The goal of the patches is to get entire assembled container (all arrays inside)
to be blocked from monitoring when reshape is in progress /exactly as when
reshape is initialized from mdadm command line/.

This time, freezing decision is taken based upon information from metadata,
not /sysfs entries. For this purpose recovery_blocked field is added to mdinfo.


Note: First patch in this series for mdadm throwing core file problem
      is resent as reminder.

BR
Adam

---

Adam Kwolek (4):
      Remove freeze() call from Grow_continue()
      imsm: Fill recovery_blocked field present in mdinfo
      Add recovery blocked field to mdinfo
      FIX: restore_backup() throws core dump


 Assemble.c    |    2 +-
 Grow.c        |   13 ++++++-------
 mdadm.h       |    7 +++++++
 super-ddf.c   |    2 ++
 super-intel.c |    6 ++++--
 super0.c      |    2 ++
 super1.c      |    2 ++
 7 files changed, 24 insertions(+), 10 deletions(-)

-- 
Signature
