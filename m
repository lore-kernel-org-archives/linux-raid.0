From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 013/100] bcache: fix input overflow to writeback_rate_minimum
Date: Fri, 18 Oct 2019 18:03:58 -0400
Message-ID: <20191018220525.9042-13-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Coly Li <colyli@suse.de>

[ Upstream commit dab71b2db98dcdd4657d151b01a7be88ce10f9d1 ]

dc->writeback_rate_minimum is type unsigned integer variable, it is set
via sysfs interface, and converte from input string to unsigned integer
by d_strtoul_nonzero(). When the converted input value is larger than
UINT_MAX, overflow to unsigned integer happens.

This patch fixes the overflow by using sysfs_strotoul_clamp() to
convert input string and limit the value in range [1, UINT_MAX], then
the overflow can be avoided.

Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 5bb81e564ce88..3e8d1f1b562f8 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -289,7 +289,9 @@ STORE(__cached_dev)
 	sysfs_strtoul_clamp(writeback_rate_p_term_inverse,
 			    dc->writeback_rate_p_term_inverse,
 			    1, UINT_MAX);
-	d_strtoul_nonzero(writeback_rate_minimum);
+	sysfs_strtoul_clamp(writeback_rate_minimum,
+			    dc->writeback_rate_minimum,
+			    1, UINT_MAX);
 
 	sysfs_strtoul_clamp(io_error_limit, dc->error_limit, 0, INT_MAX);
 
-- 
2.20.1
