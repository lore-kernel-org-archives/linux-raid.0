From: Eugene Syromiatnikov <esyr@redhat.com>
Subject: [PATCH v2 2/2] drivers/md/raid5.c: use the new spelling of
 RWH_WRITE_LIFE_NOT_SET
Date: Mon, 29 Oct 2018 21:00:54 +0100
Message-ID: <8ff5ae0a7b9dad90cac71ce468ec6856a80388b4.1540843065.git.esyr@redhat.com>
References: <cdbbf807-4df6-58c9-7d9c-2aeb1727c157@kernel.dk>
 <cover.1540843065.git.esyr@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1540843065.git.esyr@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

As it is consistent with prefixes of other write life time hints.

Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
---
 drivers/md/raid5.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e4e98f4..0bcfbd3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1139,7 +1139,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			bi->bi_iter.bi_size = STRIPE_SIZE;
 			bi->bi_write_hint = sh->dev[i].write_hint;
 			if (!rrdev)
-				sh->dev[i].write_hint = RWF_WRITE_LIFE_NOT_SET;
+				sh->dev[i].write_hint = RWH_WRITE_LIFE_NOT_SET;
 			/*
 			 * If this is discard request, set bi_vcnt 0. We don't
 			 * want to confuse SCSI because SCSI will replace payload
@@ -1192,7 +1192,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			rbi->bi_io_vec[0].bv_offset = 0;
 			rbi->bi_iter.bi_size = STRIPE_SIZE;
 			rbi->bi_write_hint = sh->dev[i].write_hint;
-			sh->dev[i].write_hint = RWF_WRITE_LIFE_NOT_SET;
+			sh->dev[i].write_hint = RWH_WRITE_LIFE_NOT_SET;
 			/*
 			 * If this is discard request, set bi_vcnt 0. We don't
 			 * want to confuse SCSI because SCSI will replace payload
-- 
2.1.4
