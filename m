From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 1/6] md: raid0: Replace hash table lookup by looping over all strip_zones.
Date: Thu, 14 May 2009 11:30:57 +0200
Message-ID: <1242293462-4181-2-git-send-email-maan@systemlinux.org>
References: <1242293462-4181-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1242293462-4181-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: raziebe@gmail.com, linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

The number of strip_zones of a raid0 array is bounded by the number of
drives in the array and is in fact much smaller for typical setups. For
example, any raid0 array containing identical disks will have only
a single strip_zone.

Therefore, the hash tables which are used for quickly finding the
strip_zone that holds a particular sector are of questionable value
and add quite a bit of unnecessary complexity.

This patch replaces the hash table lookup by equivalent code which
simply loops over all strip zones to find the zone that holds the
given sector.

Subsequent cleanup patches will remove the hash table structure.

Signed-off-by: Andre Noll <maan@systemlinux.org>

 drivers/md/raid0.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)
-- 
1.5.4.3

