From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 00/10] Pre-migration patch series
Date: Thu, 02 Dec 2010 09:18:41 +0100
Message-ID: <20101202080818.4639.38119.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

This is bunch of patches that I've pull from my OLCE/Migration tree and I believe that
they can be applied before we apply main feature (I'm curently going for some rework after your feedback).

This series is for some behaviours of mdadm that I've forund so far. 
Mainly they are bugs that are present in code or behaviour that I've observe using takeover (i.e. geo map fix).
Some of them are not visible at this moment, when we reshape big arrays (i.e. wait functions fixes) etc.


---

Adam Kwolek (10):
      FIX: wait_backup() sometimes hungs
      FIX: Honor !reshape state on wait_reshape() entry
      FIX: sync_completed_fd handler has to be closed
      FIX: Do not use layout for raid4 and raid0 while geo map computing
      FIX: open backup file for reshape as function
      Add spares to raid0 array using takeover
      Add support to skip slot configuration
      FIX: Add error code for raid_disks set
      FIX: Problem with removing array after takeover
      FIX: Cannot exit monitor after takeover


 Grow.c      |  137 +++++++++++++++++++++++++++++++++++++----------------------
 Manage.c    |  120 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 managemon.c |    1 
 mdadm.h     |    8 +++
 monitor.c   |   16 +++++++
 msg.c       |    8 +++
 restripe.c  |    5 ++
 sysfs.c     |    3 +
 8 files changed, 242 insertions(+), 56 deletions(-)

-- 
BR
Adam Kwolek
