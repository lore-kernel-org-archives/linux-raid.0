From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 2/3] md-cluster: Improve md_reload_sb to be less error
 prone
Date: Wed, 30 Sep 2015 00:22:26 +0800
Message-ID: <201509300044.grgBYbQp%fengguang.wu@intel.com>
References: <1443540089-5398-3-git-send-email-rgoldwyn@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443540089-5398-3-git-send-email-rgoldwyn@suse.com>
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

   drivers/md/md-cluster.c:213:15: sparse: restricted __le64 degrades to integer
>> drivers/md/md-cluster.c:424:29: sparse: cast to restricted __le32
   drivers/md/md-cluster.c:564:20: sparse: incorrect type in assignment (different base types)
   drivers/md/md-cluster.c:564:20:    expected int [signed] slot
   drivers/md/md-cluster.c:564:20:    got restricted __le32 [usertype] <noident>
   drivers/md/md-cluster.c:823:19: sparse: incorrect type in assignment (different base types)
   drivers/md/md-cluster.c:823:19:    expected int [signed] [addressable] type
   drivers/md/md-cluster.c:823:19:    got restricted __le32 [usertype] <noident>
>> drivers/md/md-cluster.c:829:40: sparse: incorrect type in assignment (different base types)
   drivers/md/md-cluster.c:829:40:    expected int [signed] [addressable] [assigned] raid_slot
   drivers/md/md-cluster.c:829:40:    got restricted __le32 [usertype] <noident>
   drivers/md/md-cluster.c:858:19: sparse: incorrect type in assignment (different base types)
   drivers/md/md-cluster.c:858:19:    expected int [signed] type
   drivers/md/md-cluster.c:858:19:    got restricted __le32 [usertype] <noident>
   drivers/md/md-cluster.c:859:19: sparse: incorrect type in assignment (different base types)
   drivers/md/md-cluster.c:859:19:    expected int [signed] slot
   drivers/md/md-cluster.c:859:19:    got restricted __le32 [usertype] <noident>
   drivers/md/md-cluster.c:860:18: sparse: incorrect type in assignment (different base types)
   drivers/md/md-cluster.c:860:18:    expected unsigned long [unsigned] [usertype] low
   drivers/md/md-cluster.c:860:18:    got restricted __le64 [usertype] <noident>
   drivers/md/md-cluster.c:861:19: sparse: incorrect type in assignment (different base types)
   drivers/md/md-cluster.c:861:19:    expected unsigned long [unsigned] [usertype] high
   drivers/md/md-cluster.c:861:19:    got restricted __le64 [usertype] <noident>
   drivers/md/md-cluster.c:880:27: sparse: incorrect type in assignment (different base types)
   drivers/md/md-cluster.c:880:27:    expected int [signed] type
   drivers/md/md-cluster.c:880:27:    got restricted __le32 [usertype] <noident>
   drivers/md/md-cluster.c:881:27: sparse: incorrect type in assignment (different base types)
   drivers/md/md-cluster.c:881:27:    expected int [signed] slot
   drivers/md/md-cluster.c:881:27:    got restricted __le32 [usertype] <noident>
   drivers/md/md-cluster.c:919:19: sparse: incorrect type in assignment (different base types)
   drivers/md/md-cluster.c:919:19:    expected int [signed] [addressable] type
   drivers/md/md-cluster.c:919:19:    got restricted __le32 [usertype] <noident>
--
   drivers/md/md.c:1480:34: sparse: cast to restricted __le64
   drivers/md/md.c:1760:40: sparse: incorrect type in assignment (different base types)
   drivers/md/md.c:1760:40:    expected unsigned long long [unsigned] [long] [long long] [usertype] <noident>
   drivers/md/md.c:1760:40:    got restricted __le64 [usertype] <noident>
   drivers/md/md.c:1835:26: sparse: incorrect type in assignment (different base types)
   drivers/md/md.c:1835:26:    expected restricted __le64 [usertype] super_offset
   drivers/md/md.c:1835:26:    got unsigned long [unsigned] [usertype] sb_start
>> drivers/md/md.c:7031:6: sparse: symbol '__md_error' was not declared. Should it be static?

Please review and possibly fold the followup patch.

vim +424 drivers/md/md-cluster.c

   408		len = snprintf(disk_uuid, 64, "DEVICE_UUID=");
   409		sprintf(disk_uuid + len, "%pU", cmsg->uuid);
   410		snprintf(raid_slot, 16, "RAID_DISK=%d", cmsg->raid_slot);
   411		pr_info("%s:%d Sending kobject change with %s and %s\n", __func__, __LINE__, disk_uuid, raid_slot);
   412		init_completion(&cinfo->newdisk_completion);
   413		set_bit(MD_CLUSTER_WAITING_FOR_NEWDISK, &cinfo->state);
   414		kobject_uevent_env(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE, envp);
   415		wait_for_completion_timeout(&cinfo->newdisk_completion,
   416				NEW_DEV_TIMEOUT);
   417		clear_bit(MD_CLUSTER_WAITING_FOR_NEWDISK, &cinfo->state);
   418	}
   419	
   420	
   421	static void process_metadata_update(struct mddev *mddev, struct cluster_msg *msg)
   422	{
   423		struct md_cluster_info *cinfo = mddev->cluster_info;
 > 424		md_reload_sb(mddev, le32_to_cpu(msg->raid_slot));
   425		dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
   426	}
   427	
   428	static void process_remove_disk(struct mddev *mddev, struct cluster_msg *msg)
   429	{
   430		struct md_rdev *rdev = md_find_rdev_nr_rcu(mddev, msg->raid_slot);
   431	
   432		if (rdev)

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
