From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 3/6] md: raid0: Remove hash spacing and sector shift.
Date: Thu, 14 May 2009 11:30:59 +0200
Message-ID: <1242293462-4181-4-git-send-email-maan@systemlinux.org>
References: <1242293462-4181-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1242293462-4181-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: raziebe@gmail.com, linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

The "sector_shift" and "spacing" fields of struct raid0_private_data
were only used for the hash table lookups. So the removal of the
hash table allows get rid of these fields as well which simplifies
create_strip_zones() and raid0_run() quite a bit.

Signed-off-by: Andre Noll <maan@systemlinux.org>

 drivers/md/raid0.c |   63 +---------------------------------------------------
 drivers/md/raid0.h |    3 --
 2 files changed, 1 insertions(+), 65 deletions(-)
-- 
1.5.4.3

