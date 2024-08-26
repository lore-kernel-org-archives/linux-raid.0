Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298484A11;
	Mon, 26 Aug 2024 01:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724636337; cv=none; b=R6MeEAg5LlE07VoM//6CoLD10LVHlk+oXrOi55b4wk7w1HJI6ry7lKXsoA53tTccFQ6M0u1qaH4DsHZrHlnoERU8OpmjdbGUvRizbHoWfXakE7axgbTrwL6Kpu0BaUvHSMHL1YqhwGPVGCP0b+/JuvQemCZBNsQCcxmPYop9FO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724636337; c=relaxed/simple;
	bh=6hyBKcdC0UIiBRttpghAfcsV1qVoomodcFUI8mNFo68=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=NirRT/tNoGI5UDWLSUFmkdmSV7Z54LU/addVDhujD9ELkomYCECOISGxjzY95KhsKXY0EL9FaDag+7RVfehL5YRP4wVcnSfYZQecFKJm1foirV/qDfl60NxWxliRTw5pt08tG+PAFBy/H6Tz3RaN/eGs/qu0V2fWqTjBVpQYa7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WsYH03TRNz4f3kvq;
	Mon, 26 Aug 2024 09:38:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CB8071A0359;
	Mon, 26 Aug 2024 09:38:51 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCHr4Wn3MtmIfXrCg--.7030S3;
	Mon, 26 Aug 2024 09:38:48 +0800 (CST)
Subject: Re: [PATCH md-6.12 05/41] md/md-bitmap: add 'sync_size' into struct
 md_bitmap_stats
To: kernel test robot <lkp@intel.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 song@kernel.org, mariusz.tkaczyk@linux.intel.com, l@damenly.org,
 xni@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240822024718.2158259-6-yukuai1@huaweicloud.com>
 <202408230544.w18wb47U-lkp@intel.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <fc5f783f-2d2b-4066-2a46-c4ed761e661b@huaweicloud.com>
Date: Mon, 26 Aug 2024 09:38:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <202408230544.w18wb47U-lkp@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHr4Wn3MtmIfXrCg--.7030S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGFWDtry5AFy7Jw15Zr1DZFb_yoW5urWrpF
	1UCw1Ykr1rJ3y0va12g39rZa4rtws8XFy3GF18Gw1Y9F9FvF9xJr4xKF43Ar9I9r9xGFWr
	Xr9xXr98uw1UXaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUZYFZUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/08/23 6:07, kernel test robot Ð´µÀ:
> Hi Yu,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on device-mapper-dm/for-next]
> [also build test WARNING on linus/master v6.11-rc4 next-20240822]
> [cannot apply to song-md/md-next]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Yu-Kuai/md-raid1-use-md_bitmap_wait_behind_writes-in-raid1_read_request/20240822-110233
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
> patch link:    https://lore.kernel.org/r/20240822024718.2158259-6-yukuai1%40huaweicloud.com
> patch subject: [PATCH md-6.12 05/41] md/md-bitmap: add 'sync_size' into struct md_bitmap_stats
> config: x86_64-randconfig-121-20240822 (https://download.01.org/0day-ci/archive/20240823/202408230544.w18wb47U-lkp@intel.com/config)
> compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240823/202408230544.w18wb47U-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202408230544.w18wb47U-lkp@intel.com/
> 
> sparse warnings: (new ones prefixed by >>)
>>> drivers/md/md-bitmap.c:2106:26: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned long sync_size @@     got restricted __le64 [usertype] sync_size @@
>     drivers/md/md-bitmap.c:2106:26: sparse:     expected unsigned long sync_size
>     drivers/md/md-bitmap.c:2106:26: sparse:     got restricted __le64 [usertype] sync_size

So this is actually the old code behavior. I'll fix this. :)

Thanks,
Kuai

>     drivers/md/md-bitmap.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/xarray.h, ...):
>     include/linux/page-flags.h:235:46: sparse: sparse: self-comparison always evaluates to false
>     include/linux/page-flags.h:235:46: sparse: sparse: self-comparison always evaluates to false
> 
> vim +2106 drivers/md/md-bitmap.c
> 
>    2096	
>    2097	int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
>    2098	{
>    2099		struct bitmap_counts *counts;
>    2100		bitmap_super_t *sb;
>    2101	
>    2102		if (!bitmap)
>    2103			return -ENOENT;
>    2104	
>    2105		sb = kmap_local_page(bitmap->storage.sb_page);
>> 2106		stats->sync_size = sb->sync_size;
>    2107		kunmap_local(sb);
>    2108	
>    2109		counts = &bitmap->counts;
>    2110		stats->missing_pages = counts->missing_pages;
>    2111		stats->pages = counts->pages;
>    2112	
>    2113		stats->events_cleared = bitmap->events_cleared;
>    2114		stats->file = bitmap->storage.file;
>    2115	
>    2116		return 0;
>    2117	}
>    2118	EXPORT_SYMBOL_GPL(md_bitmap_get_stats);
>    2119	
> 

