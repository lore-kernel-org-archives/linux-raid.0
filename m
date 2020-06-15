From: Yufen Yu <yuyufen@huawei.com>
Subject: Re: [PATCH v4 01/15] md/raid456: covert macro define of STRIPE_* as
 members of struct r5conf
Date: Mon, 15 Jun 2020 15:17:40 +0800
Message-ID: <277990d4-f4b9-ab5e-1707-b0c529b86674@huawei.com>
References: <20200612114220.13126-1-yuyufen@huawei.com>
 <20200612114220.13126-2-yuyufen@huawei.com>
 <00ffbcfe-1cc1-470b-d1a7-718e09f4f922@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <00ffbcfe-1cc1-470b-d1a7-718e09f4f922@redhat.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, guoqing.jiang@cloud.ionos.com, houtao1@huawei.com
List-Id: linux-raid.ids



On 2020/6/14 10:28, Xiao Ni wrote:
> Hi Yufen
> 
> It looks like there is something wrong. I try to apply these patches based on latest upstream, but it fails.
> 
> [xni@xiao md]$ git am big-page/\[PATCH\ v4\ 01_15\]\ md_raid456\:\ covert\ macro\ define\ of\ STRIPE_\*\ as\ members\ of\ struct\ r5conf\ -\ Yufen\ Yu\ \<yuyufen@huawei.com\>\ -\ 2020-06-12\ 1942.eml
> Applying: md/raid456: covert macro define of STRIPE_* as members of struct r5conf
> error: patch failed: drivers/md/raid5.c:2267
> error: drivers/md/raid5.c: patch does not apply
> Patch failed at 0001 md/raid456: covert macro define of STRIPE_* as members of struct r5conf
> The copy of the patch that failed is found in: .git/rebase-apply/patch
> [xni@xiao md]$ cat .git/config
> snip..
> [remote "origin"]
>      url = https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git
> [xni@xiao md]$ git branch
>    master
> * md-next
> 

Sorry for this. I have forgotten to rebase my own development branch
with latest upstream. I will solve it in next version.

Thanks,
Yufen
