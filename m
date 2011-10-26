From: Jes.Sorensen@redhat.com
Subject: [PATCH 01/13] count_active() catch malloc() failure
Date: Wed, 26 Oct 2011 17:30:14 +0200
Message-ID: <1319643026-11501-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1319643026-11501-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1319643026-11501-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Incremental.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index c21c971..35f0ce7 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -756,6 +756,10 @@ static int count_active(struct supertype *st, struct mdinfo *sra,
 
 			best = calloc(raid_disks, sizeof(int));
 			devmap = calloc(raid_disks * numdevs, 1);
+			if (!best || !devmap) {
+				fprintf(stderr, Name ": out of memory.\n");
+				exit(1);
+			}
 
 			st->ss->getinfo_super(st, &info, devmap);
 		}
-- 
1.7.6.4

