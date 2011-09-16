From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 00/14] Series short description
Date: Fri, 16 Sep 2011 13:53:46 +0200
Message-ID: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

This patch series (14) implements manual reshape restart/continuation
in the following scenario:

1. Condition:
   During system boot mdadm finds array under reshape that should be
   assembled. This happens while initramfs is mounted
   (before file system pivot)

2. Scenario:
 a) Assembly procedure assembles array and runs reshape continuation
    procedure (as usual). Reshape procedure continues reshape and during
    file system pivot lost file system context and cannot control process
    using check-pointing
    To avoid this now reshape procedure detects that initramfs is mounted
    (before pivot) and reshape critical section is restored and array
    is prepared for reshape only. At this point mdadm finishes his work
    for this array and array is fully functional/accessible now.

        0001-Stop-array-reshape-when-mounted-initramfs-is-detecte.patch
        0002-Stop-container-reshape-while-using-initramfs.patch
        0003-FIX-Do-not-unblock-array-accidentally.patch
        0007-FIX-Memory-leak-during-Assembly.patch

 b) Afters system boot user manually can invoke reshape continuation.
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
    e.g. container operation can be continued on array device /and oposit/.

       0004-Add-continue-option-to-grow-command.patch
       0005-Add-Grow_continue_command.patch
       0006-Check-and-run-mdmon.patch
       0007-FIX-Memory-leak-during-Assembly.patch
       0008-Check-if-reshape-can-be-restarted.patch
       0009-Move-restore-backup-code-to-function.patch
       0010-Perform-restore-backup-for-reshape-continuation.patch
       0011-Add-possibility-to-restart-reshape-for-native-metada.patch
       0012-Early-reshape-backup-verification.patch
       0013-Check-if-md-allows-to-control-reshape.patch

3. man update:
   The last patch provides madam's man update for '--continue' grow option
       0014-Manual-update-for-continue-option.patch
BR
Adam

---

Adam Kwolek (14):
      Manual update for --continue option
      Check if md allows to control reshape
      Early reshape backup verification
      Add possibility to restart reshape for native metadata
      Perform restore backup for reshape continuation
      Move restore backup code to function
      Check if reshape can be restarted
      FIX: Memory leak during Assembly
      Check and run mdmon
      Add Grow_continue_command
      Add continue option to grow command
      FIX: Do not unblock array accidentally
      Stop container reshape while using initramfs
      Stop array reshape when mounted initramfs is detected


 Assemble.c |   39 +-------
 Grow.c     |  290 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 ReadMe.c   |    1 
 mdadm.8.in |   24 +++++
 mdadm.c    |   24 +++++
 mdadm.h    |   14 +++
 sysfs.c    |   10 ++
 util.c     |   59 ++++++++++++
 8 files changed, 419 insertions(+), 42 deletions(-)

-- 
Signature
