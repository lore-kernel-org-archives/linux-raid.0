From: "majianpeng" <majianpeng@gmail.com>
Subject: About raid5 read error handle when raid5 was degraded.
Date: Mon, 21 May 2012 18:47:58 +0800
Message-ID: <201205211847549688311@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 Hi all:
	I readed the latest code in function :

raid5_end_read_request():
>>	else if (conf->mddev->degraded >= conf->max_degraded)
>>			printk_ratelimited(
>>				KERN_WARNING
>>				"md/raid:%s: read error not correctable "
>>				"(sector %llu on %s).\n",
>>				mdname(conf->mddev),
>>				(unsigned long long)(sh->sector
>>						     + rdev->data_offset),
>>				bdn);

If this occur,then exec md_error().In md_error(), remove this disk.
The raid5 will fail and lost all data.
Why do call rdev_set_badsector() for this situation?

														Thanks!

 				
--------------
majianpeng
2012-05-21

