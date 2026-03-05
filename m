Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C403624BF
	for <linux-raid@vger.kernel.org>; Thu,  5 Mar 2026 22:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772751027; cv=none; b=OwwzpJWIPGDLfZ+DYhdwCyYxO7LSHeDaN8V6LBrE3CQwaWgJTM8mMcO7RFYFJxjDbc8J2a3LtWyM176Ps8lR2bCSx9djZcsND7fqbLBA7XoVNuBoEj5SV+e/yasQVYH3aBjdLKV3TCVWP0X+7TKGfwaZ3+9tcilIk4kBq5P1W5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772751027; c=relaxed/simple;
	bh=AXcQLqJR6MHEFQyxqAUlhup/MYRqwrCOoZI2iZsqhss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E5MyHKjZenW212NNIlnEDyLyus7bJyisKI4S/HfYMGNaBwbcDALmLi7/8aJcVbANUzM3jKYc08PzTBZpqGHqkSEm1jV0K2q9u50w7UEfd/5wfw+D20y9BgG2gcdSkFa+64FkDjkhQfBqJQZvURWXaQt8aJF2jokMzXlGRQJlo9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W9MIqkrR; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W9MIqkrR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772751025; x=1804287025;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AXcQLqJR6MHEFQyxqAUlhup/MYRqwrCOoZI2iZsqhss=;
  b=W9MIqkrRCOKs/PG01uz0FgczwYWGcWYSOeydy9Ul/y6Z1x7hDOB79Q+Z
   60UuFXgThLlvk2MBcICxHHqZxOwZt8nfpWREPSQnQ7HSknNt9raPcSV1b
   z7Ffj5sTQt3a56qR5BSPzqH6BYhYOC5Jv2BhyAEWmQMOWHwUM/pPqiU6x
   8/q7DYwIpDJu6MM7gLLmTvkzfwJlHDJ57xdwdinWmwBq4Ep7CGpoNqMWJ
   3qGmqbgSD1Stu6cj0yDzbcBTiQRI8/4juVhgB8U/vth0wAwpWi8IfUYHm
   UbIEBfCUnUbVC+BaoS1f6FGg2moKP1de9aWx/nf97ZiuSWpi1epqaI/vJ
   A==;
X-CSE-ConnectionGUID: h0YCM+hxQ1aFK0BKR8kvwQ==
X-CSE-MsgGUID: xzJnFAQJQzejKu1csCnpeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="76456766"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="76456766"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 14:50:24 -0800
X-CSE-ConnectionGUID: ol+cioCtR0SOYCvxEP96cw==
X-CSE-MsgGUID: 1SKehThuSAC5/DeLfDGq7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="223313262"
Received: from lkp-server01.sh.intel.com (HELO 058beb05654c) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 05 Mar 2026 14:50:21 -0800
Received: from kbuild by 058beb05654c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vyHWL-00000000021-3UOl;
	Thu, 05 Mar 2026 22:50:17 +0000
Date: Fri, 6 Mar 2026 06:50:09 +0800
From: kernel test robot <lkp@intel.com>
To: Su Yue <glass.su@suse.com>, linux-raid@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, song@kernel.org, xni@redhat.com,
	linan122@huawei.com, yukuai@fnnas.com, heming.zhao@suse.com,
	l@damenly.org, Su Yue <glass.su@suse.com>
Subject: Re: [PATCH 1/3] md: restore bitmap/location to fix wrong bitmap
 offset while growing
Message-ID: <202603060614.AZY6J9w9-lkp@intel.com>
References: <20260303033731.83885-2-glass.su@suse.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303033731.83885-2-glass.su@suse.com>

Hi Su,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v7.0-rc2 next-20260305]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Su-Yue/md-restore-bitmap-location-to-fix-wrong-bitmap-offset-while-growing/20260303-114108
base:   linus/master
patch link:    https://lore.kernel.org/r/20260303033731.83885-2-glass.su%40suse.com
patch subject: [PATCH 1/3] md: restore bitmap/location to fix wrong bitmap offset while growing
config: i386-randconfig-051-20260305 (https://download.01.org/0day-ci/archive/20260306/202603060614.AZY6J9w9-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260306/202603060614.AZY6J9w9-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603060614.AZY6J9w9-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: drivers/md/md.o: in function `md_alloc':
>> drivers/md/md.c:6376:(.text+0xb36c): undefined reference to `md_sysfs_create_common_group'


vim +6376 drivers/md/md.c

  6276	
  6277	struct mddev *md_alloc(dev_t dev, char *name)
  6278	{
  6279		/*
  6280		 * If dev is zero, name is the name of a device to allocate with
  6281		 * an arbitrary minor number.  It will be "md_???"
  6282		 * If dev is non-zero it must be a device number with a MAJOR of
  6283		 * MD_MAJOR or mdp_major.  In this case, if "name" is NULL, then
  6284		 * the device is being created by opening a node in /dev.
  6285		 * If "name" is not NULL, the device is being created by
  6286		 * writing to /sys/module/md_mod/parameters/new_array.
  6287		 */
  6288		static DEFINE_MUTEX(disks_mutex);
  6289		struct mddev *mddev;
  6290		struct gendisk *disk;
  6291		int partitioned;
  6292		int shift;
  6293		int unit;
  6294		int error;
  6295	
  6296		/*
  6297		 * Wait for any previous instance of this device to be completely
  6298		 * removed (mddev_delayed_delete).
  6299		 */
  6300		flush_workqueue(md_misc_wq);
  6301	
  6302		mutex_lock(&disks_mutex);
  6303		mddev = mddev_alloc(dev);
  6304		if (IS_ERR(mddev)) {
  6305			error = PTR_ERR(mddev);
  6306			goto out_unlock;
  6307		}
  6308	
  6309		partitioned = (MAJOR(mddev->unit) != MD_MAJOR);
  6310		shift = partitioned ? MdpMinorShift : 0;
  6311		unit = MINOR(mddev->unit) >> shift;
  6312	
  6313		if (name && !dev) {
  6314			/* Need to ensure that 'name' is not a duplicate.
  6315			 */
  6316			struct mddev *mddev2;
  6317			spin_lock(&all_mddevs_lock);
  6318	
  6319			list_for_each_entry(mddev2, &all_mddevs, all_mddevs)
  6320				if (mddev2->gendisk &&
  6321				    strcmp(mddev2->gendisk->disk_name, name) == 0) {
  6322					spin_unlock(&all_mddevs_lock);
  6323					error = -EEXIST;
  6324					goto out_free_mddev;
  6325				}
  6326			spin_unlock(&all_mddevs_lock);
  6327		}
  6328		if (name && dev)
  6329			/*
  6330			 * Creating /dev/mdNNN via "newarray", so adjust hold_active.
  6331			 */
  6332			mddev->hold_active = UNTIL_STOP;
  6333	
  6334		disk = blk_alloc_disk(NULL, NUMA_NO_NODE);
  6335		if (IS_ERR(disk)) {
  6336			error = PTR_ERR(disk);
  6337			goto out_free_mddev;
  6338		}
  6339	
  6340		disk->major = MAJOR(mddev->unit);
  6341		disk->first_minor = unit << shift;
  6342		disk->minors = 1 << shift;
  6343		if (name)
  6344			strcpy(disk->disk_name, name);
  6345		else if (partitioned)
  6346			sprintf(disk->disk_name, "md_d%d", unit);
  6347		else
  6348			sprintf(disk->disk_name, "md%d", unit);
  6349		disk->fops = &md_fops;
  6350		disk->private_data = mddev;
  6351	
  6352		disk->events |= DISK_EVENT_MEDIA_CHANGE;
  6353		mddev->gendisk = disk;
  6354		error = add_disk(disk);
  6355		if (error)
  6356			goto out_put_disk;
  6357	
  6358		kobject_init(&mddev->kobj, &md_ktype);
  6359		error = kobject_add(&mddev->kobj, &disk_to_dev(disk)->kobj, "%s", "md");
  6360		if (error) {
  6361			/*
  6362			 * The disk is already live at this point.  Clear the hold flag
  6363			 * and let mddev_put take care of the deletion, as it isn't any
  6364			 * different from a normal close on last release now.
  6365			 */
  6366			mddev->hold_active = 0;
  6367			mutex_unlock(&disks_mutex);
  6368			mddev_put(mddev);
  6369			return ERR_PTR(error);
  6370		}
  6371	
  6372		/*
  6373		 * md_sysfs_remove_common_group is not needed because mddev_delayed_delete
  6374		 * calls kobject_put(&mddev->kobj) if mddev is to be deleted.
  6375		 */
> 6376		if (md_sysfs_create_common_group(mddev))
  6377			pr_warn("md: cannot register common bitmap attributes for %s\n",
  6378				mdname(mddev));
  6379	
  6380		kobject_uevent(&mddev->kobj, KOBJ_ADD);
  6381		mddev->sysfs_state = sysfs_get_dirent_safe(mddev->kobj.sd, "array_state");
  6382		mddev->sysfs_level = sysfs_get_dirent_safe(mddev->kobj.sd, "level");
  6383		mutex_unlock(&disks_mutex);
  6384		return mddev;
  6385	
  6386	out_put_disk:
  6387		put_disk(disk);
  6388	out_free_mddev:
  6389		mddev_free(mddev);
  6390	out_unlock:
  6391		mutex_unlock(&disks_mutex);
  6392		return ERR_PTR(error);
  6393	}
  6394	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
