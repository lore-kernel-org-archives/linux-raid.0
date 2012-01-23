From: Jes.Sorensen@redhat.com
Subject: [PATCH v2 0/4] add --preboot argument to mdadm/mdmon
Date: Mon, 23 Jan 2012 12:18:21 +0100
Message-ID: <1327317505-14782-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com, kay@redhat.com, harald@redhat.com, lpoetter@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

Here is v2 of the systemd/dracut fixes for preboot handling in
mdadm/mdmon. I have changed the argument over from --initrd to
--preboot as Neil suggested, as well as fixed up the minor code nits
and added documentation to the man pages.

It shows up that I didn't need to add a separate enum for the command
line arguments in mdmon since mdadm.h gets pulled in so we can reuse
those. If we find that to be an issue, we can always create a separate
one later.

Cheers,
Jes

Jes Sorensen (4):
  mdmon: Use getopt_long() to parse command line options
  Add --preboot argument to mdadm
  Add --preboot argument to mdmon
  Spawn mdmon with --preboot if mdadm was launched with --preboot

 ReadMe.c   |    5 +++++
 mdadm.8.in |   12 ++++++++++++
 mdadm.c    |   10 ++++++++++
 mdadm.h    |    3 +++
 mdmon.8    |   12 +++++++++++-
 mdmon.c    |   60 +++++++++++++++++++++++++++++++++++++++++++++++++-----------
 util.c     |   17 +++++++++++++----
 7 files changed, 103 insertions(+), 16 deletions(-)

-- 
1.7.8.3

