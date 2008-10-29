From: Doug Ledford <dledford@redhat.com>
Subject: [Patch mdadm-2.6.7.1 0/3] Misc fixes for mdadm-2.6.7.1
Date: Wed, 29 Oct 2008 15:05:34 -0400
Message-ID: <cover.1225306892.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.5.6.5"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------1.5.6.5
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


This can also be pulled directly from

git://fedorapeople.org/~dledford/mdadm.git for-neil

Doug Ledford (3):
  Fix bad metadata formatting
  Fix NULL pointer oops
  Make incremental mode work with partitionable arrays

 Detail.c      |    6 +-
 Incremental.c |  136 ++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 mdopen.c      |    4 +-
 super0.c      |    5 ++-
 super1.c      |    3 +
 util.c        |    2 +-
 6 files changed, 137 insertions(+), 19 deletions(-)

--------------1.5.6.5--
