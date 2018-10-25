From: Eugene Syromiatnikov <esyr@redhat.com>
Subject: [PATCH RESEND 2/2] drivers/md/raid5.c: use the new spelling of
 RWH_WRITE_LIFE_NOT_SET
Date: Thu, 25 Oct 2018 23:54:52 +0200
Message-ID: <effee6298f42c044a512864bc306bb8510e0ee9d.1540504380.git.evgsyr@gmail.com>
References: <8acaf8d7-17c9-e8ec-c60a-18a011b4c34f@kernel.dk>
 <cover.1540504380.git.evgsyr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1540504380.git.evgsyr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

As it is consistent with prefixes of other write life time hints.

Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
Signed-off-by: Eugene Syromyatnikov <evgsyr@gmail.com>
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
