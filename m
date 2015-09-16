From: Jes.Sorensen@redhat.com
Subject: [PATCH 0/1] Fix raid1 resync getting stuck
Date: Wed, 16 Sep 2015 10:20:04 -0400
Message-ID: <1442413205-9593-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, nate.dailey@stratus.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Neil,

This patch seems to do the job for us. Nate ran testing with > 500
iterations which would normally fail in less than 10.

I tried changing MaxSector to ((~(sector_t)0) >> 1) as you suggested,
but that made the raid5 code go explosive. This on the other hand
seems to do the trick.

Cheers,
Jes


Jes Sorensen (1):
  md/raid1: Avoid raid1 resync getting stuck

 drivers/md/raid1.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

-- 
2.4.3

