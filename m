From: Coly Li <colyli@suse.de>
Subject: Re: [RFC PATCH 1/2] RAID1: a new I/O barrier implementation to remove
 resync window
Date: Wed, 30 Nov 2016 15:19:46 +0800
Message-ID: <a3be4c59-9ed1-069d-72ab-3f9950a52360@suse.de>
References: <1479765241-15528-1-git-send-email-colyli@suse.de>
 <58369819.1070203@suse.com> <0bfdd1c7-5953-a282-dd37-3a8595c90844@suse.de>
 <583E7392.9020308@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <583E7392.9020308@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>, Neil Brown <neilb@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-raid.ids

On 2016/11/30 下午2:37, Guoqing Jiang wrote:
> 
> 
> On 11/28/2016 03:33 PM, Coly Li wrote:
>> In raid1_sync_request(), I see,
>> conf->cluster_sync_low = mddev->curr_resync_completed;
>> conf->cluster_sync_high = conf->cluster_sync_low +
>> CLUSTER_RESYNC_WINDOW_SECTORS;
>>
>> Is it possible that LBA range [conf->cluster_sync_low,
>> conf->cluster_sync_high] goes across the border of a barrier unit size ?
> 
> Not pretty sure about it, but since cluster's resync window is 32M which is
> less than BARRIER_UNIT_SECTOR_SIZE, I guess it would not cause trouble.

Thanks for the hint. So BARRIER_UNIT_SECTOR_SIZE is 32MB aligned,
cluster's resync window won't go across the boundary.


Coly
