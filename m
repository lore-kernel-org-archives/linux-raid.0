From: kbuild test robot <fengguang.wu@intel.com>
Subject: [md:devel 19/30] drivers/md/raid5-cache.c:836:24: sparse:
 incompatible types in comparison expression (different address spaces)
Date: Wed, 30 Sep 2015 14:07:33 +0800
Message-ID: <201509301430.rwQczogl%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: kbuild-all@01.org, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

tree:   git://neil.brown.name/md devel
head:   c086427458276f6265b609a682651786e1281c82
commit: a62ddcf73e2fe3387dbf27280691045446be0e15 [19/30] raid5: log recovery
reproduce:
  # apt-get install sparse
  git checkout a62ddcf73e2fe3387dbf27280691045446be0e15
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/md/raid5-cache.c:836:24: sparse: incompatible types in comparison expression (different address spaces)
   drivers/md/raid5-cache.c:840:25: sparse: incompatible types in comparison expression (different address spaces)

vim +836 drivers/md/raid5-cache.c

   820				continue;
   821			addr = kmap_atomic(sh->dev[disk_index].page);
   822			checksum = crc32_le(log->uuid_checksum, addr, PAGE_SIZE);
   823			kunmap_atomic(addr);
   824			if (checksum != sh->dev[disk_index].log_checksum)
   825				goto error;
   826		}
   827	
   828		for (disk_index = 0; disk_index < sh->disks; disk_index++) {
   829			struct md_rdev *rdev, *rrdev;
   830	
   831			if (!test_and_clear_bit(R5_Wantwrite,
   832						&sh->dev[disk_index].flags))
   833				continue;
   834	
   835			/* in case device is broken */
 > 836			rdev = rcu_dereference(conf->disks[disk_index].rdev);
   837			if (rdev)
   838				sync_page_io(rdev, stripe_sect, PAGE_SIZE,
   839					     sh->dev[disk_index].page, WRITE, false);
   840			rrdev = rcu_dereference(conf->disks[disk_index].replacement);
   841			if (rrdev)
   842				sync_page_io(rrdev, stripe_sect, PAGE_SIZE,
   843					     sh->dev[disk_index].page, WRITE, false);
   844		}

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
