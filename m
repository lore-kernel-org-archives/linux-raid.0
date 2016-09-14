From: Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: Question about commit f9a67b1182e5 ("md/bitmap: clear bitmap if
 bitmap_create failed").
Date: Wed, 14 Sep 2016 22:39:18 +0200
Message-ID: <5e0b941c-1536-3242-eb26-a500e5bb4ff6@wanadoo.fr>
References: <752ab1d9-412a-149b-a241-e604040ebaff@wanadoo.fr>
 <20160913172433.GB24264@kernel.org> <57D9097C.5050202@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <57D9097C.5050202@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



Le 14/09/2016 à 10:25, Guoqing Jiang a écrit :
>
>
> On 09/13/2016 01:24 PM, Shaohua Li wrote:
>> On Mon, Sep 12, 2016 at 09:09:48PM +0200, Christophe JAILLET wrote:
>>> Hi,
>>>
>>> I'm puzzled by commit f9a67b1182e5 ("md/bitmap: clear bitmap if
>>> bitmap_create failed").
>> Hi Christophe,
>> Thank you very much to help check this!
>>
>>> Part of the commit is:
>>>
>>> @@ -1865,8 +1866,10 @@ int bitmap_copy_from_slot(struct mddev 
>>> *mddev, int
>>> slot,
>>>       struct bitmap_counts *counts;
>>>       struct bitmap *bitmap = bitmap_create(mddev, slot);
>>>
>>> -    if (IS_ERR(bitmap))
>>> +    if (IS_ERR(bitmap)) {
>>> +        bitmap_free(bitmap);
>>>           return PTR_ERR(bitmap);
>>> +    }
>>>
>>> but if 'bitmap' is an error, I think that bad things will happen in
>>> 'bitmap_free()' when, at the beginning of the function, we will 
>>> execute:
>>>
>>>      if (bitmap->sysfs_can_clear) <-----------------
>>>          sysfs_put(bitmap->sysfs_can_clear);
>
> I guess it is safe, since below part is at the beginning of bitmap_free.
>
>         if (!bitmap) /* there was no bitmap */
>                 return;

I don't share your feeling.
bitmap_create() can return ERR_PTR(-ENOMEM) or ERR_PTR(-EINVAL).

In such cases 'if (!bitmap)' will not be helpful.

Maybe it should be turned into 'if (IS_ERR_OR_NULL(bitmap))' to handle 
errors returned by bitmap_create.
Maybe just removing the call to 'bitmap_free(bitmap)' is enough.

In any case, I think that the current logic is somehow broken.

Best regards,
CJ
