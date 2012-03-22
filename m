From: Jes.Sorensen@redhat.com
Subject: [PATCH 0/1] Avoid OOPS when reshaping raid1 to raid0
Date: Thu, 22 Mar 2012 17:15:52 +0100
Message-ID: <1332432953-30091-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: dledford@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

If one tries to reshape a raid1 into a raid0 the kernel will OOPS
because it tries to align the size of the new array to the original
chunk size. However a raid1 doesn't have the notion of chunk size, so
we end up dividing by zero and OOPSing.

Fix it by setting the existing chunk size of the raid1 being reshaped
to the new suggested chunk size.

Cheers,
Jes


Jes Sorensen (1):
  Avoid OOPS when reshaping raid1 to raid0

 drivers/md/raid0.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

-- 
1.7.7.6

