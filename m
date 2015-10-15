From: kbuild test robot <fengguang.wu@intel.com>
Subject: [md:devel 12/62] drivers/md/md-cluster.c:943:24: sparse: incorrect
 type in assignment (different base types)
Date: Thu, 15 Oct 2015 11:32:18 +0800
Message-ID: <201510151116.GJOzuE2r%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: kbuild-all@01.org, linux-raid@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

tree:   git://neil.brown.name/md devel
head:   3ad01dcc5180761bf7686dd6e6fb8083ca22b913
commit: faeff83fa478b4dca9877d6b10a25ad252891f14 [12/62] md-cluster: make other members of cluster_msg is handled by little endian funcs
reproduce:
        # apt-get install sparse
        git checkout faeff83fa478b4dca9877d6b10a25ad252891f14
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/md/md-cluster.c:218:15: sparse: restricted __le64 degrades to integer
   drivers/md/md-cluster.c:421:49: sparse: cast to restricted __le32
   drivers/md/md-cluster.c:435:29: sparse: cast to restricted __le32
   drivers/md/md-cluster.c:442:52: sparse: cast to restricted __le32
   drivers/md/md-cluster.c:447:17: sparse: cast to restricted __le32
   drivers/md/md-cluster.c:454:52: sparse: cast to restricted __le32
   drivers/md/md-cluster.c:459:17: sparse: cast to restricted __le32
   drivers/md/md-cluster.c:574:20: sparse: incorrect type in assignment (different base types)
   drivers/md/md-cluster.c:574:20:    expected int [signed] slot
   drivers/md/md-cluster.c:574:20:    got restricted __le32 [usertype] <noident>
   drivers/md/md-cluster.c:794:19: sparse: incorrect type in assignment (different base types)
   drivers/md/md-cluster.c:794:19:    expected int [signed] type
   drivers/md/md-cluster.c:794:19:    got restricted __le32 [usertype] <noident>
   drivers/md/md-cluster.c:849:19: sparse: incorrect type in assignment (different base types)
   drivers/md/md-cluster.c:849:19:    expected int [signed] [addressable] type
   drivers/md/md-cluster.c:849:19:    got restricted __le32 [usertype] <noident>
   drivers/md/md-cluster.c:855:40: sparse: incorrect type in assignment (different base types)
   drivers/md/md-cluster.c:855:40:    expected int [signed] [addressable] [assigned] raid_slot
   drivers/md/md-cluster.c:855:40:    got restricted __le32 [usertype] <noident>
   drivers/md/md-cluster.c:888:19: sparse: incorrect type in assignment (different base types)
   drivers/md/md-cluster.c:888:19:    expected int [signed] type
   drivers/md/md-cluster.c:888:19:    got restricted __le32 [usertype] <noident>
   drivers/md/md-cluster.c:889:19: sparse: incorrect type in assignment (different base types)
   drivers/md/md-cluster.c:889:19:    expected int [signed] slot
   drivers/md/md-cluster.c:889:19:    got restricted __le32 [usertype] <noident>
   drivers/md/md-cluster.c:890:18: sparse: incorrect type in assignment (different base types)
   drivers/md/md-cluster.c:890:18:    expected unsigned long [unsigned] [usertype] low
   drivers/md/md-cluster.c:890:18:    got restricted __le64 [usertype] <noident>
   drivers/md/md-cluster.c:891:19: sparse: incorrect type in assignment (different base types)
   drivers/md/md-cluster.c:891:19:    expected unsigned long [unsigned] [usertype] high
   drivers/md/md-cluster.c:891:19:    got restricted __le64 [usertype] <noident>
   drivers/md/md-cluster.c:941:19: sparse: incorrect type in assignment (different base types)
   drivers/md/md-cluster.c:941:19:    expected int [signed] [addressable] type
   drivers/md/md-cluster.c:941:19:    got restricted __le32 [usertype] <noident>
>> drivers/md/md-cluster.c:943:24: sparse: incorrect type in assignment (different base types)
   drivers/md/md-cluster.c:943:24:    expected int [signed] [addressable] raid_slot
   drivers/md/md-cluster.c:943:24:    got restricted __le32 [usertype] <noident>
   drivers/md/md-cluster.c:986:19: sparse: incorrect type in assignment (different base types)
   drivers/md/md-cluster.c:986:19:    expected int [signed] type
   drivers/md/md-cluster.c:986:19:    got restricted __le32 [usertype] <noident>
>> drivers/md/md-cluster.c:987:24: sparse: incorrect type in assignment (different base types)
   drivers/md/md-cluster.c:987:24:    expected int [signed] raid_slot
   drivers/md/md-cluster.c:987:24:    got restricted __le32 [usertype] <noident>
   drivers/md/md-cluster.c:999:19: sparse: incorrect type in assignment (different base types)
   drivers/md/md-cluster.c:999:19:    expected int [signed] type
   drivers/md/md-cluster.c:999:19:    got restricted __le32 [usertype] <noident>
   drivers/md/md-cluster.c:1000:24: sparse: incorrect type in assignment (different base types)
   drivers/md/md-cluster.c:1000:24:    expected int [signed] raid_slot
   drivers/md/md-cluster.c:1000:24:    got restricted __le32 [usertype] <noident>

vim +943 drivers/md/md-cluster.c

   884	
   885		add_resync_info(mddev, cinfo->bitmap_lockres, lo, hi);
   886		/* Re-acquire the lock to refresh LVB */
   887		dlm_lock_sync(cinfo->bitmap_lockres, DLM_LOCK_PW);
   888		cmsg.type = cpu_to_le32(RESYNCING);
   889		cmsg.slot = cpu_to_le32(slot);
 > 890		cmsg.low = cpu_to_le64(lo);
   891		cmsg.high = cpu_to_le64(hi);
   892	
   893		return sendmsg(cinfo, &cmsg);
   894	}
   895	
   896	static int resync_finish(struct mddev *mddev)
   897	{
   898		struct md_cluster_info *cinfo = mddev->cluster_info;
   899		cinfo->resync_lockres->flags &= ~DLM_LKF_NOQUEUE;
   900		dlm_unlock_sync(cinfo->resync_lockres);
   901		return resync_info_update(mddev, 0, 0);
   902	}
   903	
   904	static int area_resyncing(struct mddev *mddev, int direction,
   905			sector_t lo, sector_t hi)
   906	{
   907		struct md_cluster_info *cinfo = mddev->cluster_info;
   908		int ret = 0;
   909		struct suspend_info *s;
   910	
   911		if ((direction == READ) &&
   912			test_bit(MD_CLUSTER_SUSPEND_READ_BALANCING, &cinfo->state))
   913			return 1;
   914	
   915		spin_lock_irq(&cinfo->suspend_lock);
   916		if (list_empty(&cinfo->suspend_list))
   917			goto out;
   918		list_for_each_entry(s, &cinfo->suspend_list, list)
   919			if (hi > s->lo && lo < s->hi) {
   920				ret = 1;
   921				break;
   922			}
   923	out:
   924		spin_unlock_irq(&cinfo->suspend_lock);
   925		return ret;
   926	}
   927	
   928	/* add_new_disk() - initiates a disk add
   929	 * However, if this fails before writing md_update_sb(),
   930	 * add_new_disk_cancel() must be called to release token lock
   931	 */
   932	static int add_new_disk(struct mddev *mddev, struct md_rdev *rdev)
   933	{
   934		struct md_cluster_info *cinfo = mddev->cluster_info;
   935		struct cluster_msg cmsg;
   936		int ret = 0;
   937		struct mdp_superblock_1 *sb = page_address(rdev->sb_page);
   938		char *uuid = sb->device_uuid;
   939	
   940		memset(&cmsg, 0, sizeof(cmsg));
 > 941		cmsg.type = cpu_to_le32(NEWDISK);
   942		memcpy(cmsg.uuid, uuid, 16);
 > 943		cmsg.raid_slot = cpu_to_le32(rdev->desc_nr);
   944		lock_comm(cinfo);
   945		ret = __sendmsg(cinfo, &cmsg);
   946		if (ret)
   947			return ret;
   948		cinfo->no_new_dev_lockres->flags |= DLM_LKF_NOQUEUE;
   949		ret = dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_EX);
   950		cinfo->no_new_dev_lockres->flags &= ~DLM_LKF_NOQUEUE;
   951		/* Some node does not "see" the device */
   952		if (ret == -EAGAIN)
   953			ret = -ENOENT;
   954		if (ret)
   955			unlock_comm(cinfo);
   956		else
   957			dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
   958		return ret;
   959	}
   960	
   961	static void add_new_disk_cancel(struct mddev *mddev)
   962	{
   963		struct md_cluster_info *cinfo = mddev->cluster_info;
   964		unlock_comm(cinfo);
   965	}
   966	
   967	static int new_disk_ack(struct mddev *mddev, bool ack)
   968	{
   969		struct md_cluster_info *cinfo = mddev->cluster_info;
   970	
   971		if (!test_bit(MD_CLUSTER_WAITING_FOR_NEWDISK, &cinfo->state)) {
   972			pr_warn("md-cluster(%s): Spurious cluster confirmation\n", mdname(mddev));
   973			return -EINVAL;
   974		}
   975	
   976		if (ack)
   977			dlm_unlock_sync(cinfo->no_new_dev_lockres);
   978		complete(&cinfo->newdisk_completion);
   979		return 0;
   980	}
   981	
   982	static int remove_disk(struct mddev *mddev, struct md_rdev *rdev)
   983	{
   984		struct cluster_msg cmsg;
   985		struct md_cluster_info *cinfo = mddev->cluster_info;
   986		cmsg.type = cpu_to_le32(REMOVE);
 > 987		cmsg.raid_slot = cpu_to_le32(rdev->desc_nr);
   988		return __sendmsg(cinfo, &cmsg);
   989	}
   990	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
