From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 1/2] bcache: silence static checker warning
Date: Wed, 28 Jun 2017 14:47:07 +0300
Message-ID: <20170628114707.5oy4wmslmrethlzn@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@fb.com>
Cc: Shaohua Li <shli@kernel.org>, Eric Wheeler <git@linux.ewheeler.net>, Ming Lei <tom.leiming@gmail.com>, NeilBrown <neilb@suse.com>, Coly Li <colyli@suse.de>, Yijing Wang <wangyijing@huawei.com>, Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.com>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

In olden times, closure_return() used to have a hidden return built in.
We removed the hidden return but forgot to add a new return here.  If
"c" were NULL we would oops on the next line, but fortunately "c" is
never NULL.  Let's just remove the if statement.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 8352fad765f6..78004c54f4f6 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1374,9 +1374,6 @@ static void cache_set_flush(struct closure *cl)
 	struct btree *b;
 	unsigned i;
 
-	if (!c)
-		closure_return(cl);
-
 	bch_cache_accounting_destroy(&c->accounting);
 
 	kobject_put(&c->internal);
