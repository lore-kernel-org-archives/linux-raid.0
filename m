From: kbuild test robot <fengguang.wu@intel.com>
Subject: [md:devel 41/50] drivers/md/md.c:1663:33: sparse: restricted __le32
 degrades to integer
Date: Wed, 19 Aug 2015 14:51:59 +0800
Message-ID: <201508191457.WvmoxqAc%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: kbuild-all@01.org, NeilBrown <neilb@suse.com>, Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

tree:   git://neil.brown.name/md devel
head:   da63d1b483fa5a9604d65974eb442a110ee41e89
commit: 1a8a1e097abc6d2787ef6f2e915d5f18d42a1e6c [41/50] MD: add a new disk role to present write journal device
reproduce:
  # apt-get install sparse
  git checkout 1a8a1e097abc6d2787ef6f2e915d5f18d42a1e6c
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/md/md.c:1501:34: sparse: cast to restricted __le64
>> drivers/md/md.c:1663:33: sparse: restricted __le32 degrades to integer
   drivers/md/md.c:1794:40: sparse: incorrect type in assignment (different base types)
   drivers/md/md.c:1794:40:    expected unsigned long long [unsigned] [long] [long long] [usertype] <noident>
   drivers/md/md.c:1794:40:    got restricted __le64 [usertype] <noident>
   drivers/md/md.c:1872:26: sparse: incorrect type in assignment (different base types)
   drivers/md/md.c:1872:26:    expected restricted __le64 [usertype] super_offset
   drivers/md/md.c:1872:26:    got unsigned long [unsigned] [usertype] sb_start
   drivers/md/md.c:8980:39: sparse: restricted __le64 degrades to integer

vim +1663 drivers/md/md.c

  1647		}
  1648		if (mddev->level != LEVEL_MULTIPATH) {
  1649			int role;
  1650			if (rdev->desc_nr < 0 ||
  1651			    rdev->desc_nr >= le32_to_cpu(sb->max_dev)) {
  1652				role = MD_DISK_ROLE_SPARE;
  1653				rdev->desc_nr = -1;
  1654			} else
  1655				role = le16_to_cpu(sb->dev_roles[rdev->desc_nr]);
  1656			switch(role) {
  1657			case MD_DISK_ROLE_SPARE: /* spare */
  1658				break;
  1659			case MD_DISK_ROLE_FAULTY: /* faulty */
  1660				set_bit(Faulty, &rdev->flags);
  1661				break;
  1662			case MD_DISK_ROLE_JOURNAL: /* journal device */
> 1663				if (!(sb->feature_map & MD_FEATURE_JOURNAL)) {
  1664					/* journal device without journal feature */
  1665					printk(KERN_WARNING
  1666					  "md: journal device provided without "
  1667					  "journal feature, ignoring the device\n");
  1668					return -EINVAL;
  1669				}
  1670				set_bit(Journal, &rdev->flags);
  1671				break;

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
