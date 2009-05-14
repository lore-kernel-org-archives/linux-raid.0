From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 2/6] md: raid0: Remove hash table.
Date: Thu, 14 May 2009 11:30:58 +0200
Message-ID: <1242293462-4181-3-git-send-email-maan@systemlinux.org>
References: <1242293462-4181-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1242293462-4181-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: raziebe@gmail.com, linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

The raid0 hash table has become unused due to the changes in the
previous patch. This patch removes the hash table allocation and
setup code and kills the hash_table field of struct raid0_private_data.

Signed-off-by: Andre Noll <maan@systemlinux.org>

 drivers/md/raid0.c |   12 ------------
 drivers/md/raid0.h |    1 -
 2 files changed, 0 insertions(+), 13 deletions(-)
-- 
1.5.4.3

