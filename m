From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: read perfomance patchset
Date: Mon, 19 Jun 2006 17:02:28 +0300
Message-ID: <5d96567b0606190702k36466d35x856da3610ea11862@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Neil hello

if i am not mistaken here:

in first instance of :   if(bi) ...
               ...

you return without setting to NULL

+static struct bio *remove_bio_from_retry(raid5_conf_t *conf)
+{
+       struct bio *bi;
+
+       bi = conf->retry_read_aligned;
+       if (bi) {
-->               return bi;
-->               conf->retry_read_aligned = NULL;
+       }
+       bi = conf->retry_read_aligned_list;
+       if(bi) {
+               conf->retry_read_aligned = bi->bi_next;
+               bi->bi_next = NULL;
+               bi->bi_phys_segments = 1; /* biased count of active stripes */
+               bi->bi_hw_segments = 0; /* count of processed stripes */
+       }
+
+       return bi;
+}

-- 
Raz
