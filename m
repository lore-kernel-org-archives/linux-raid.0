From: Jes.Sorensen@redhat.com
Subject: [PATCH v2 0/3] support launching mdmon via systemctl
Date: Mon, 21 Jan 2013 14:22:55 +0100
Message-ID: <1358774578-2183-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com, harald@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

This is v2 of the patch to support launching mdmon via systemctl/
systemd. It now provides a command line option --systemctl, as well as
the two systemd .service files.

Cheers,
Jes


Jes Sorensen (3):
  Add support for launching mdmon via systemctl instead of fork/exec
  systemd .service files for launching mdmon via systemctl
  execl() only returns in case of error

 ReadMe.c                       |  2 ++
 mdadm.c                        |  4 ++++
 mdadm.h                        |  2 ++
 mdmon.c                        |  4 +++-
 systemd/mdmon-offroot@.service | 19 +++++++++++++++++++
 systemd/mdmon@.service         | 13 +++++++++++++
 util.c                         | 42 ++++++++++++++++++++++++++++++------------
 7 files changed, 73 insertions(+), 13 deletions(-)
 create mode 100644 systemd/mdmon-offroot@.service
 create mode 100644 systemd/mdmon@.service

-- 
1.7.11.7

