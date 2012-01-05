From: Jes.Sorensen@redhat.com
Subject: [PATCH 0/1] gcc-4.7 build fix
Date: Thu,  5 Jan 2012 12:16:40 +0100
Message-ID: <1325762201-23949-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

Fedora Rawhide just upgraded to gcc-4.7 which breaks the build of
mdadm due to more strict antialiasing checks.

This patch works around it by splitting the pointer calculations into
a separate line.

I don't have anything that uses ddf superblocks, but I believe the
changes are correct.

Cheers,
Jes


Jes Sorensen (1):
  Work around gcc-4.7's strict aliasing checks

 sha1.c      |    8 +++++---
 super-ddf.c |   22 ++++++++++++++--------
 2 files changed, 19 insertions(+), 11 deletions(-)

-- 
1.7.8.2

