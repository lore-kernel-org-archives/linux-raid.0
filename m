From: Jes.Sorensen@redhat.com
Subject: [PATCH v3 0/4] add --offroot argument to mdadm/mdmon
Date: Wed, 25 Jan 2012 16:18:00 +0100
Message-ID: <1327504684-9219-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com, kay@redhat.com, harald@redhat.com, lpoetter@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

Here is v3, also known as the perfect<tm> version of the of the
systemd/dracut fixes for preboot/offroot/initrd handling in
mdadm/mdmon. I have changed the argument now to --offroot based on the
input I received. 

Cheers,
Jes


Jes Sorensen (4):
  mdmon: Use getopt_long() to parse command line options
  Add --offroot argument to mdadm
  Add --offroot argument to mdmon
  Spawn mdmon with --offroot if mdadm was launched with --offroot

 ReadMe.c   |    5 +++++
 mdadm.8.in |   12 ++++++++++++
 mdadm.c    |   10 ++++++++++
 mdadm.h    |    3 +++
 mdmon.8    |   12 +++++++++++-
 mdmon.c    |   59 ++++++++++++++++++++++++++++++++++++++++++++++++-----------
 util.c     |   17 +++++++++++++----
 7 files changed, 102 insertions(+), 16 deletions(-)

-- 
1.7.8.3

