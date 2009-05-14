From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 5/6] md: raid0: Kfree() strip_zone and devlist in create_strip_zones().
Date: Thu, 14 May 2009 11:31:01 +0200
Message-ID: <1242293462-4181-6-git-send-email-maan@systemlinux.org>
References: <1242293462-4181-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1242293462-4181-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: raziebe@gmail.com, linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

It's cleaner to kfree() these in the same function where they are
allocated. This allows to simplify raid0_run() a bit which will be
done in the next patch.

Signed-off-by: Andre Noll <maan@systemlinux.org>

 drivers/md/raid0.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)
-- 
1.5.4.3

