From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] raid5-ppl: PPL support for disks with write-back cache
 enabled
Date: Thu, 21 Dec 2017 00:35:21 +0800
Message-ID: <201712210051.48XorsHT%fengguang.wu@intel.com>
References: <1513604700-1826-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1513604700-1826-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: kbuild-all@01.org, linux-raid@vger.kernel.org, shli@kernel.org, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

Hi Tomasz,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v4.15-rc4 next-20171220]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Tomasz-Majchrzak/raid5-ppl-PPL-support-for-disks-with-write-back-cache-enabled/20171220-181528
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)


vim +635 drivers/md/raid5-ppl.c

   619	
   620	static void ppl_do_flush(struct ppl_io_unit *io)
   621	{
   622		struct ppl_log *log = io->log;
   623		struct ppl_conf *ppl_conf = log->ppl_conf;
   624		struct r5conf *conf = ppl_conf->mddev->private;
   625		int raid_disks = conf->raid_disks;
   626		int flushed_disks = 0;
   627		int i;
   628	
   629		atomic_set(&io->pending_flushes, raid_disks);
   630	
   631		for_each_set_bit(i, &log->disk_flush_bitmap, raid_disks) {
   632			struct md_rdev *rdev;
   633	
   634			rcu_read_lock();
 > 635			rdev = rcu_dereference(conf->disks[i].rdev);
   636			if (rdev && test_bit(Faulty, &rdev->flags))
   637				rdev = NULL;
   638			rcu_read_unlock();
   639	
   640			if (rdev) {
   641				struct bio *bio;
   642				char b[BDEVNAME_SIZE];
   643	
   644				bio = bio_alloc_bioset(GFP_NOIO, 0, ppl_conf->flush_bs);
   645				bio_set_dev(bio, rdev->bdev);
   646				bio->bi_private = io;
   647				bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
   648				bio->bi_end_io = ppl_flush_endio;
   649	
   650				pr_debug("%s: dev: %s\n", __func__,
   651					 bio_devname(bio, b));
   652	
   653				submit_bio(bio);
   654				flushed_disks++;
   655			}
   656		}
   657	
   658		log->disk_flush_bitmap = 0;
   659	
   660		for (i = flushed_disks ; i < raid_disks; i++) {
   661			if (atomic_dec_and_test(&io->pending_flushes))
   662				ppl_io_unit_finished(io);
   663		}
   664	}
   665	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
