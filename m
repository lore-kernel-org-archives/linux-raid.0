From: Jes.Sorensen@redhat.com
Subject: [PATCH 0/4] add --initrd argument to mdadm/mdmon
Date: Tue, 17 Jan 2012 11:48:46 +0100
Message-ID: <1326797330-4488-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com, kay@redhat.com, harald@redhat.com, lpoetter@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

In order to resolve the problem with reboots hanging on systems with /
on an IMSM RAID, systemd needs to be able to see that a given mdadm
and mdmon process was launched from the initramfs, and allow it to
survive until it gets back to there, so it can unmount the root
filesystem safely.

These patches introduces the --initrd argument to mdadm which makes it
change the first character of argv[0] to '@' to match the convention
set by systemd.

In addition I also changed mdmon to use getopt_long to make it easier
to add more command line arguments to it. Note that I went through
great effort to preserve the behavior, even though the old code did
some somewhat dodgy stuff using changing the arvg buffer pointing to
the '--all' argument.

Comments?

Thanks,
Jes

Jes Sorensen (4):
  mdmon: Use getopt_long() to parse command line options
  Add --initrd argument to mdadm
  Add --initrd argument to mdmon
  Spawn mdmon with --initrd if mdadm was launched with --initrd

 ReadMe.c |    3 ++
 mdadm.c  |   11 ++++++++++
 mdadm.h  |    3 ++
 mdmon.c  |   64 +++++++++++++++++++++++++++++++++++++++++++++++++++----------
 util.c   |   17 ++++++++++++---
 5 files changed, 83 insertions(+), 15 deletions(-)

-- 
1.7.8.3

