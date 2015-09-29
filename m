From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 3/3] md-cluster: Perform a lazy update
Date: Wed, 30 Sep 2015 00:30:44 +0800
Message-ID: <201509300042.jyUpX6z2%fengguang.wu@intel.com>
References: <1443540089-5398-4-git-send-email-rgoldwyn@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443540089-5398-4-git-send-email-rgoldwyn@suse.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: kbuild-all@01.org, linux-raid@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

Hi Goldwyn,

[auto build test results on v4.3-rc3 -- if it's inappropriate base, please ignore]

reproduce:
  # apt-get install sparse
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/md/md.c:1480:34: sparse: cast to restricted __le64
   drivers/md/md.c:1760:40: sparse: incorrect type in assignment (different base types)
   drivers/md/md.c:1760:40:    expected unsigned long long [unsigned] [long] [long long] [usertype] <noident>
   drivers/md/md.c:1760:40:    got restricted __le64 [usertype] <noident>
   drivers/md/md.c:1835:26: sparse: incorrect type in assignment (different base types)
   drivers/md/md.c:1835:26:    expected restricted __le64 [usertype] super_offset
   drivers/md/md.c:1835:26:    got unsigned long [unsigned] [usertype] sb_start
   drivers/md/md.c:2230:43: sparse: cast to restricted __le64
>> drivers/md/md.c:2230:43: sparse: cast from restricted __le32
>> drivers/md/md.c:2199:6: sparse: symbol 'does_sb_need_changing' was not declared. Should it be static?
   drivers/md/md.c:7061:6: sparse: symbol '__md_error' was not declared. Should it be static?

Please review and possibly fold the followup patch.

vim +2230 drivers/md/md.c

  2193				sync_super(mddev, rdev);
  2194				rdev->sb_loaded = 1;
  2195			}
  2196		}
  2197	}
  2198	
> 2199	bool does_sb_need_changing(struct mddev *mddev)
  2200	{
  2201		struct md_rdev *rdev;
  2202		struct mdp_superblock_1 *sb;
  2203		int role;
  2204	
  2205		/* Find a good rdev */
  2206		rdev_for_each_rcu(rdev, mddev)
  2207			if ((rdev->raid_disk >= 0) && !test_bit(Faulty, &rdev->flags))
  2208				break;
  2209	
  2210		/* No good device found. */
  2211		if (!rdev)
  2212			return false;
  2213	
  2214		sb = page_address(rdev->sb_page);
  2215		/* Check if a device has become faulty or a spare become active */
  2216		rdev_for_each(rdev, mddev) {
  2217			role = le16_to_cpu(sb->dev_roles[rdev->desc_nr]);
  2218			/* Device activated? */
  2219			if (role == 0xffff && rdev->raid_disk >=0 && !test_bit(Faulty, &rdev->flags))
  2220				return true;
  2221			/* Device turned faulty? */
  2222			if (test_bit(Faulty, &rdev->flags) && (role < 0xfffd))
  2223				return true;
  2224		}
  2225	
  2226		/* Check if any mddev parameters have changed */
  2227		if ((mddev->dev_sectors != le64_to_cpu(sb->size)) ||
  2228				(mddev->reshape_position != le64_to_cpu(sb->reshape_position)) ||
  2229				(mddev->recovery_cp != le64_to_cpu(sb->resync_offset)) ||
> 2230				(mddev->layout != le64_to_cpu(sb->layout)) ||
  2231				(mddev->raid_disks != le32_to_cpu(sb->raid_disks)) ||
  2232				(mddev->chunk_sectors != le32_to_cpu(sb->chunksize))
  2233				 )

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
