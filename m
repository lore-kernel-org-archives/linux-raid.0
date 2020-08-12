From: Vojtech Myslivec <vojtech@xmyslivec.cz>
Subject: Re: Linux RAID with btrfs stuck and consume 100 % CPU
Date: Wed, 12 Aug 2020 15:58:41 +0200
Message-ID: <43082abe-b0c8-ecaf-fc21-606df34fb5f8@xmyslivec.cz>
References: <d3fced3f-6c2b-5ffa-fd24-b24ec6e7d4be@xmyslivec.cz>
 <a070c45a-0509-e900-e3f3-98d20267c8c9@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a070c45a-0509-e900-e3f3-98d20267c8c9@cloud.ionos.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Michal Moravec <michal.moravec@logicworks.cz>, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Hello,

On 29. 07. 20 23:06, Guoqing Jiang wrote:
> On 7/22/20 10:47 PM, Vojtech Myslivec wrote:
>> 1. What should be the cause of this problem?
> 
> Just a quick glance based on the stacks which you attached, I guess it
> could be
> a deadlock issue of raid5 cache super write.
> 
> Maybe the commit 8e018c21da3f ("raid5-cache: fix a deadlock in superblock
> write") didn't fix the problem completely.  Cc Song.
> 
> And I am curious why md thread is not waked if mddev_trylock fails, you can
> give it a try but I can't promise it helps ...

Just to make sure we use RAID 6 across 6 HDD (I am not sure how RAID 5
implementation relates to RAID 6).
