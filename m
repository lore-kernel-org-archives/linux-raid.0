From: Coly Li <i@coly.li>
Subject: Re: [RESEND PATCH] bcache: Don't reinvent the wheel but use existing
 llist API
Date: Tue, 8 Aug 2017 14:50:15 +0800
Message-ID: <1c3836c4-e930-5d7b-76cc-31a287a408a7@coly.li>
References: <1502095121-14337-1-git-send-email-byungchul.park@lge.com>
 <b37c4038-d95f-ca81-5789-825ebfc6d425@coly.li>
 <20170808041233.GR20323@X58A-UD3R>
 <d99cc72b-833d-c8b1-4c44-923cb50d5d1f@coly.li>
 <20170808060056.GS20323@X58A-UD3R>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20170808060056.GS20323@X58A-UD3R>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
To: Byungchul Park <byungchul.park@lge.com>
Cc: kent.overstreet@gmail.com, shli@kernel.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@lge.com
List-Id: linux-raid.ids

On 2017/8/8 下午2:00, Byungchul Park wrote:
> On Tue, Aug 08, 2017 at 01:28:39PM +0800, Coly Li wrote:
>>>>> +	llist_for_each_entry_safe(cl, t, reverse, list) {
>>>>
>>>> Just wondering why not using llist_for_each_entry(), or you use the
>>>> _safe version on purpose ?
>>>
>>> If I use llist_for_each_entry(), then it would change the original
>>> behavior. Is it ok?
>>>
>>
>> I feel llist_for_each_entry() keeps the original behavior, and variable
> 
> Ah.. I see. Then.. Can I change it into non-safe version? Is it still ok
> with non-safe one? I will change it at the next spin, if yes.
> 
>> 't' can be removed. Anyway, either llist_for_each_entry() or
>> llist_for_each_entry_safe() works correctly and well here. Any one you
>> use is OK to me, thanks for your informative reply :-)
> 
> I rather appriciate it.
> 

Yes, please. And you have my Acked-by :-)


-- 
Coly Li
