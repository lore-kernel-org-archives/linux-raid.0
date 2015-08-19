From: kbuild test robot <fengguang.wu@intel.com>
Subject: [md:devel 47/50] drivers/md/raid5-cache.c:828:24: sparse:
 incompatible types in comparison expression (different address spaces)
Date: Wed, 19 Aug 2015 14:57:16 +0800
Message-ID: <201508191414.RqHCNHaZ%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: kbuild-all@01.org, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

tree:   git://neil.brown.name/md devel
head:   da63d1b483fa5a9604d65974eb442a110ee41e89
commit: b8c1c83f96ea61fe7fc9aa960edfc6e75b0c56a3 [47/50] raid5: log recovery
reproduce:
  # apt-get install sparse
  git checkout b8c1c83f96ea61fe7fc9aa960edfc6e75b0c56a3
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/md/raid5-cache.c:828:24: sparse: incompatible types in comparison expression (different address spaces)
   drivers/md/raid5-cache.c:832:25: sparse: incompatible types in comparison expression (different address spaces)

vim +828 drivers/md/raid5-cache.c

   812			if (!test_bit(R5_Wantwrite, &sh->dev[disk_index].flags))
   813				continue;
   814			addr = kmap_atomic(sh->dev[disk_index].page);
   815			checksum = crc32_le(log->uuid_checksum, addr, PAGE_SIZE);
   816			kunmap_atomic(addr);
   817			if (checksum != sh->dev[disk_index].log_checksum)
   818				goto error;
   819		}
   820	
   821		for (disk_index = 0; disk_index < sh->disks; disk_index++) {
   822			struct md_rdev *rdev, *rrdev;
   823			if (!test_and_clear_bit(R5_Wantwrite,
   824					&sh->dev[disk_index].flags))
   825				continue;
   826	
   827			/* in case device is broken */
 > 828			rdev = rcu_dereference(conf->disks[disk_index].rdev);
   829			if (rdev)
   830				sync_page_io(rdev, stripe_sect, PAGE_SIZE,
   831					sh->dev[disk_index].page, WRITE, false);
   832			rrdev = rcu_dereference(conf->disks[disk_index].replacement);
   833			if (rrdev)
   834				sync_page_io(rrdev, stripe_sect, PAGE_SIZE,
   835					sh->dev[disk_index].page, WRITE, false);
   836		}

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
