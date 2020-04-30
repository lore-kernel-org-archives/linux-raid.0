From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH v2] Detail: adding sync status for cluster device
Date: Thu, 30 Apr 2020 13:09:46 -0400
Message-ID: <22b8afdb-1b90-70c0-d017-76bd86eb99bf@trained-monkey.org>
References: <20200427161438.20296-1-lidong.zhong@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200427161438.20296-1-lidong.zhong@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Lidong Zhong <lidong.zhong@suse.com>, linux-raid@vger.kernel.org
Cc: guoqing.jiang@cloud.ionos.com
List-Id: linux-raid.ids

On 4/27/20 12:14 PM, Lidong Zhong wrote:
> On the node with /proc/mdstat is
> 
> Personalities : [raid1]
> md0 : active raid1 sdb[4] sdc[3] sdd[2]
>       1046528 blocks super 1.2 [3/2] [UU_]
>         recover=REMOTE
>       bitmap: 1/1 pages [4KB], 65536KB chunk
> 
> Let's change the 'State' of 'mdadm -Q -D' accordingly
> State : clean, degraded
> With this patch, it will be
> State : clean, degraded, recovering (REMOTE)
> 
> Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>
> Acked-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

I already applied a version of this patch, what is new in the v2? Can
you send an incremental patch on top of the current git tree?

Thanks,
Jes
