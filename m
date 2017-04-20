From: NeilBrown <neilb@suse.com>
Subject: [mdadm PATCH 0/4] Assorted mdadm patches
Date: Thu, 20 Apr 2017 12:40:05 +1000
Message-ID: <149265560315.31004.3851231165281498425.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

These are 4 unrelated patches that I've gathered
over the last few weeks.
The last one is probably the most interesting and one
that you should probably think carefully before apply
(but I hope you'll decide in favour).

When you --assemble -or --create an array, udev immediately has a look
at the new device and might act on that content.  e.g. tell udisks it
can mount a filesystem, or tell mdadm that there is part of a RAID
array in here.

When you --assemble an array you want that to happen.
When you --create it, you don't.
udev cannot distinguish 'assemble' from 'create'.
This can be annoying.

The way I have found to tell udev about the distinction to create a
/run/udev/rules.d/01-mdadm.rules file which marks any newly appearing
md array as SYSTEMD_READY==0.  This is created before the array, and
removed once the array exisits (and hopefully has been handled by
udev).
Most udev rules which might process a newly appearing device will
avoid doing so i SYSTEMD_READY is set to 0.

Thanks,
NeilBrown


---

NeilBrown (4):
      Grow_continue_command: ensure 'content' is properly initialised.
      systemd/mdadm-last-resort: use ConditionPathExists instead of Conflicts
      Detail: ensure --export names are acceptable as shell variables.
      Create: tell udev device is not ready when first created.


 Create.c                           |    9 +++++++++
 Detail.c                           |   12 +++++++++---
 Grow.c                             |    1 +
 lib.c                              |   22 ++++++++++++++++++++++
 mdadm.h                            |    2 ++
 systemd/mdadm-last-resort@.service |    2 +-
 6 files changed, 44 insertions(+), 4 deletions(-)

--
Signature

