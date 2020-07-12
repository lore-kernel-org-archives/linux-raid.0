From: antlists <antlists@youngman.org.uk>
Subject: Re: [PATCH v5 01/16] md/raid456: covert macro define of STRIPE_* as
 members of struct r5conf
Date: Sun, 12 Jul 2020 23:55:14 +0100
Message-ID: <61fe17a6-1c2c-7f95-eba7-167d8d0d30c2@youngman.org.uk>
References: <20200702120628.777303-1-yuyufen@huawei.com>
 <20200702120628.777303-2-yuyufen@huawei.com>
 <CAPhsuW7cSue8BtWhmWMgOTjw42ChTm4cM+gApj_s02rq=YGRkQ@mail.gmail.com>
 <3bf71b7a-b457-c5e4-34df-bdea5cf2abc3@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3bf71b7a-b457-c5e4-34df-bdea5cf2abc3@molgen.mpg.de>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Paul Menzel <pmenzel@molgen.mpg.de>, Song Liu <song@kernel.org>, Yufen Yu <yuyufen@huawei.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Hou Tao <houtao1@huawei.com>
List-Id: linux-raid.ids

On 02/07/2020 19:23, Paul Menzel wrote:
> Dear Yufen,
> 
> 
> Am 02.07.20 um 20:15 schrieb Song Liu:
>> On Thu, Jul 2, 2020 at 5:05 AM Yufen Yu <yuyufen@huawei.com> wrote:
>>>
>>> We covert STRIPE_SIZE, STRIPE_SHIFT and STRIPE_SECTORS to stripe_size,
>>> stripe_shift and stripe_sectors as members of struct r5conf. Then each
>>> raid456 array can config different stripe_size. This patch is prepared
>>> for following configurable stripe_size.
>>>
>>> Simply replace word STRIPE_ with conf->stripe_ and add 'conf' argument
>>> for function stripe_hash_locks_hash() and r5_next_bio() to get 
>>> stripe_size.
>>> After that, we initialize stripe_size into setup_conf().
>>>
>>> Signed-off-by: Yufen Yu <yuyufen@huawei.com>
>>
>> This patch looks good. Please fix the warning found by the kernel test 
>> bot.
>> Also a nitpick below.
> 
> Please also fix the typo *covert* to *Convert* in the commit message 
> summary, and maybe use *to* instead of *as*.

Actually, if I understand the Pidgin correctly, "as" is correct grammar. 
"to" just doesn't work for me ...
> 
>  > Convert macro define of STRIPE_* to members of struct r5conf
> 
Cheers,
Wol
