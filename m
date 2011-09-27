From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/8] Reshape restart after filesystem pivot
Date: Tue, 27 Sep 2011 14:04:30 +0200
Message-ID: <20110927115845.4890.49289.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

This patch series (8) implements manual reshape restart/continuation
in the following scenario:

1. Condition:
   During system boot mdadm finds array under reshape that should be
   assembled. This happens while initramfs is mounted
   (before file system pivot)

2. Scenario:
 a) Assembly procedure assembles array and runs reshape continuation
    procedure (as usual). Reshape procedure continues reshape and during
    file system pivot lost file system context and mdadm cannot control
    reshape process using check-pointing
    To avoid this, reshape procedure is informed via '--freeze-reshape' option
    that currently system is in initrd phase (before file system pivot).
    Reshape restores critical section and prepares array for later reshape
    continuation (sets reshape position read from metadata checkpoint).
    At this moment mdadm finishes his work. Array is fully functional/accessible now.

    0001-Do-not-continue-reshape-during-initrd-phase.patch

 b) After system boot, user can manually invoke reshape continuation.
    New mdadm option '--continue' for grow command was added.
    This allows for reshape continuation. mdadm for reshape continuation
    uses parameters read from metadata. Command line can looks as follows:

      mdadm -G --continue device_name [--backup-file=file_name]

      where:
          device_name : device that reshape should be continued on
                        e.g. /dev/md/container_name or /dev/md/raid_name
          backup-file : optional parameter required when backup-file
                        was use previously for reshape execution


   For external metadata mdadm takes carry for metadata compatibility
   e.g. container operation can be continued on array device /and opposite/.

     0002-Add-continue-option-to-grow-command.patch
     0003-Do-not-restart-reshape-if-it-is-started-already.patch
     0004-Set-correct-reshape-restart-position.patch
     0005-Move-code-to-get_data_disks-function.patch
     0006-Verify-reshape-restart-position.patch

3. man update:
   The last 2 patches provides madam's man update for '--freeze-reshape' and
   '--continue' options.

     0007-Manual-update-for-continue-option.patch
     0008-Manual-update-for-continue-option.patch

Note: This series requires patch for throwing core dump by restore_backup() function:
     0001-FIX-restore_backup-throws-core-dump.patch

BR
Adam
    

---

Adam Kwolek (8):
      Manual update for --continue option
      Manual update for --continue option
      Verify reshape restart position
      Move code to get_data_disks() function
      Set correct reshape restart position
      Do not restart reshape if it is started already
      Add continue option to grow command
      Do not continue reshape during initrd phase


 Assemble.c    |   12 ++-
 Grow.c        |  236 ++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 Incremental.c |   16 ++--
 ReadMe.c      |    2 
 mdadm.8.in    |   40 ++++++++++
 mdadm.c       |   47 +++++++++--
 mdadm.h       |   25 +++++-
 util.c        |   10 ++
 8 files changed, 341 insertions(+), 47 deletions(-)

-- 
Signature
