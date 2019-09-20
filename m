From: Eugene Syromiatnikov <esyr@redhat.com>
Subject: [PATCH v3 3/3] drivers/md/raid5-ppl.c: use the new spelling of
 RWH_WRITE_LIFE_NOT_SET
Date: Fri, 20 Sep 2019 17:58:34 +0200
Message-ID: <1632a3b1118b53d1ebebfcff2ea635681819c467.1568994792.git.esyr@redhat.com>
References: <cover.1568994791.git.esyr@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1568994791.git.esyr@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

As it is consistent with prefixes of other write life time hints.

Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
---
 drivers/md/raid5-ppl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 18a4064..cab5b13 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -1404,7 +1404,7 @@ int ppl_init_log(struct r5conf *conf)
 	atomic64_set(&ppl_conf->seq, 0);
 	INIT_LIST_HEAD(&ppl_conf->no_mem_stripes);
 	spin_lock_init(&ppl_conf->no_mem_stripes_lock);
-	ppl_conf->write_hint = RWF_WRITE_LIFE_NOT_SET;
+	ppl_conf->write_hint = RWH_WRITE_LIFE_NOT_SET;
 
 	if (!mddev->external) {
 		ppl_conf->signature = ~crc32c_le(~0, mddev->uuid, sizeof(mddev->uuid));
-- 
2.1.4
