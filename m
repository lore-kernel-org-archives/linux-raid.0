From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: Question about commit f9a67b1182e5 ("md/bitmap: clear bitmap if
 bitmap_create failed").
Date: Wed, 14 Sep 2016 04:25:32 -0400
Message-ID: <57D9097C.5050202@suse.com>
References: <752ab1d9-412a-149b-a241-e604040ebaff@wanadoo.fr>
 <20160913172433.GB24264@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160913172433.GB24264@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



On 09/13/2016 01:24 PM, Shaohua Li wrote:
> On Mon, Sep 12, 2016 at 09:09:48PM +0200, Christophe JAILLET wrote:
>> Hi,
>>
>> I'm puzzled by commit f9a67b1182e5 ("md/bitmap: clear bitmap if
>> bitmap_create failed").
> Hi Christophe,
> Thank you very much to help check this!
>
>> Part of the commit is:
>>
>> @@ -1865,8 +1866,10 @@ int bitmap_copy_from_slot(struct mddev *mddev, int
>> slot,
>>       struct bitmap_counts *counts;
>>       struct bitmap *bitmap = bitmap_create(mddev, slot);
>>
>> -    if (IS_ERR(bitmap))
>> +    if (IS_ERR(bitmap)) {
>> +        bitmap_free(bitmap);
>>           return PTR_ERR(bitmap);
>> +    }
>>
>> but if 'bitmap' is an error, I think that bad things will happen in
>> 'bitmap_free()' when, at the beginning of the function, we will execute:
>>
>>      if (bitmap->sysfs_can_clear) <-----------------
>>          sysfs_put(bitmap->sysfs_can_clear);

I guess it is safe, since below part is at the beginning of bitmap_free.

         if (!bitmap) /* there was no bitmap */
                 return;

> Add Guoqing.
>
> Yeah, you are right, this bitmap_free isn't required. This must be something
> slip in in the v2 patch. I'll delete that line.
>
>> However, the commit log message is really explicit and adding this call to
>> 'bitmap_free' has really been done one purpose. ("If bitmap_create returns
>> an error, we need to call either bitmap_destroy or bitmap_free to do clean
>> up, ...")
> this log is a little confusing, I thought it really means the bitmap_free called
> in bitmap_create. The V1 patch calls bitmap_destroy in bitmap_create.

I double checked v1 patch, it called bitmap_destroy once bitmap_create 
returned
error inside bitmap_copy_from_slot, also bitmap_destroy is also not 
called in
location_store once failed to create bitmap.

But since bitmap_free within bitmap_create is used to handle related 
failure,
seems we don't need the patch, and maybe we also don't need the second line
of below comments (the patch is motivated by the comment IIRC).

/*
  * initialize the bitmap structure
  * if this returns an error, bitmap_destroy must be called to do clean up
  */

Thanks,
Guoqing
