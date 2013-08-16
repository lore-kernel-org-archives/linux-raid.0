From: mwilck@arcor.de
Subject: [PATCH 0/6] Fixes for installation of CentOS 6 on DDF BIOS RAID
Date: Fri, 16 Aug 2013 20:21:54 +0200
Message-ID: <1376677320-12816-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

I am currently working on RHEL6/CentOS6 installation on a DDF 
BIOS RAID using MD. Currently, RHEL/CentOS will activate dmraid when 
the installer encouters DDF meta data, as most distributions do. 
I got the installation working with MD using an update image, and I
will soon publish a recipe for that.
I hope to do the same for other distributions in the future.

In the process I found some glitches that need the following
series of small patches for mdadm.

Martin Wilck (6):
  DDF: ddf_activate_spare: fix gcc -O2 uninitialized warning
  DDF: export_examine_super_ddf: print MD_DEVICES
  DDF: container_content_ddf: set safe_mode_delay > 0
  DDF: increase default value for safe_mode_delay to 4000ms
  in_initrd: fix gcc compiler error
  mdmon: allow disabling "@dmon" command name at compile time

 Makefile    |    4 +++-
 mdmon.c     |    2 ++
 super-ddf.c |   11 +++++++++--
 util.c      |    4 ++--
 4 files changed, 16 insertions(+), 5 deletions(-)

-- 
1.7.3.4
