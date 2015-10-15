From: kbuild test robot <fengguang.wu@intel.com>
Subject: [md:devel 40/44] drivers/md/md.c:1813:33: sparse: invalid
 assignment: |=
Date: Thu, 15 Oct 2015 11:53:37 +0800
Message-ID: <201510151134.UPkvBLUi%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: kbuild-all@01.org, linux-raid@vger.kernel.org, NeilBrown <neilb@suse.com>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

tree:   git://neil.brown.name/md devel
head:   3ad01dcc5180761bf7686dd6e6fb8083ca22b913
commit: 768e16727c9b1f35a809a8068b218743fd8fb557 [40/44] MD: add new bit to indicate raid array with journal
reproduce:
        # apt-get install sparse
        git checkout 768e16727c9b1f35a809a8068b218743fd8fb557
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/md/md.c:1480:34: sparse: cast to restricted __le64
   drivers/md/md.c:1782:40: sparse: incorrect type in assignment (different base types)
   drivers/md/md.c:1782:40:    expected unsigned long long [unsigned] [long] [long long] [usertype] <noident>
   drivers/md/md.c:1782:40:    got restricted __le64 [usertype] <noident>
>> drivers/md/md.c:1813:33: sparse: invalid assignment: |=
   drivers/md/md.c:1813:33:    left side has type restricted __le32
   drivers/md/md.c:1813:33:    right side has type int
   drivers/md/md.c:1862:26: sparse: incorrect type in assignment (different base types)
   drivers/md/md.c:1862:26:    expected restricted __le64 [usertype] super_offset
   drivers/md/md.c:1862:26:    got unsigned long [unsigned] [usertype] sb_start
   drivers/md/md.c:2268:31: sparse: cast to restricted __le64
   drivers/md/md.c:2268:31: sparse: cast from restricted __le32

vim +1813 drivers/md/md.c

  1797				max_dev = rdev2->desc_nr+1;
  1798	
  1799		if (max_dev > le32_to_cpu(sb->max_dev)) {
  1800			int bmask;
  1801			sb->max_dev = cpu_to_le32(max_dev);
  1802			rdev->sb_size = max_dev * 2 + 256;
  1803			bmask = queue_logical_block_size(rdev->bdev->bd_disk->queue)-1;
  1804			if (rdev->sb_size & bmask)
  1805				rdev->sb_size = (rdev->sb_size | bmask) + 1;
  1806		} else
  1807			max_dev = le32_to_cpu(sb->max_dev);
  1808	
  1809		for (i=0; i<max_dev;i++)
  1810			sb->dev_roles[i] = cpu_to_le16(MD_DISK_ROLE_FAULTY);
  1811	
  1812		if (test_bit(MD_HAS_JOURNAL, &mddev->flags))
> 1813			sb->feature_map |= MD_FEATURE_JOURNAL;
  1814	
  1815		rdev_for_each(rdev2, mddev) {
  1816			i = rdev2->desc_nr;
  1817			if (test_bit(Faulty, &rdev2->flags))
  1818				sb->dev_roles[i] = cpu_to_le16(MD_DISK_ROLE_FAULTY);
  1819			else if (test_bit(In_sync, &rdev2->flags))
  1820				sb->dev_roles[i] = cpu_to_le16(rdev2->raid_disk);
  1821			else if (test_bit(Journal, &rdev2->flags))

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
