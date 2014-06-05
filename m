From: hui jiao <simonjiaoh@gmail.com>
Subject: deadlock between retry_aligned_read with barrier io
Date: Thu, 5 Jun 2014 11:34:24 +0800
Message-ID: <CAEuG+XJ8EezzRVaaoHmhQRdqZZYo=4kjizc=Z+5kXvjDbBccCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

A chunk aligned read increases counter active_aligned_reads and
decreases it after sub-device handle it successfully. But when a read
error occurs,  the read redispatched by raid5d, and the
active_aligned_reads will not be decreased until we can grab a stripe
head in retry_aligned_read. Now suppose, a barrier io comes, set
conf->quiesce to 2, and wait until both active_stripes and
active_aligned_reads are zero. The retried chunk aligned read gets
stuck at get_active_stripe waiting until conf->quiesce becomes 0.
Retry_aligned_read and barrier io are waiting each other now.
One possible solution is that we ignore conf->quiesce, let the retried
aligned read finish. I reproduced this deadlock and test this patch on
centos6.0

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9cd137e..8f94929 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4378,7 +4378,7 @@ static int  retry_aligned_read(raid5_conf_t
*conf, struct bio *raid_bio)
                        /* already done this stripe */
                        continue;

-               sh = get_active_stripe(conf, sector, 0, 1, 0);
+               sh = get_active_stripe(conf, sector, 0, 1, 1);

                if (!sh) {
                        /* failed to get a stripe - must wait */

any suggestion?
