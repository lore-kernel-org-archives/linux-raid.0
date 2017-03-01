From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH 04/14] md-cluster: add mddev into struct md_cluster_info
Date: Wed, 1 Mar 2017 10:49:33 +0800
Message-ID: <58B636BD.5080301@suse.com>
References: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
 <1487906124-20107-5-git-send-email-gqjiang@suse.com>
 <20170228180625.rxdbizl7thpif566@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170228180625.rxdbizl7thpif566@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.de
List-Id: linux-raid.ids



On 03/01/2017 02:06 AM, Shaohua Li wrote:
> On Fri, Feb 24, 2017 at 11:15:14AM +0800, Guoqing Jiang wrote:
>> Store "struct mddev *mddev" in md_cluster_info,
>> then we can get mddev inside lock_token in next
>> patch.
> Please merge this to the patch which requires the mddev. Don't think we need a
> separate patch.
>   

I will merge it.

Thanks,
Guoqing
