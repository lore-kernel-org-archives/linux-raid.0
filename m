From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH] Fix bitmap offset calculations
Date: Wed, 01 Apr 2015 09:14:36 -0500
Message-ID: <551BFD4C.2080505@suse.de>
References: <20150324162905.GA16104@shrek.lan> <20150325131502.1a947967@notabene.brown> <CAB-428mbVFcEmT_OryyGxEAhr56Uy0CODrEVEoPUPk34C45_Uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB-428mbVFcEmT_OryyGxEAhr56Uy0CODrEVEoPUPk34C45_Uw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alireza Haghdoost <alireza@cs.umn.edu>, NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Alireza,

On 04/01/2015 08:58 AM, Alireza Haghdoost wrote:
> Does it means if some one use write-intent bitmap without this patch,
> he may end-up with some unsync stripes after system crash or power
> failure and RAID resynchronization ? It seems the bitmaps does not
> record correct address of unsynced blocks due to this bug.
>
> Would you please verify this.

This is for clustered md effort only (which is in Neil's md/for-next 
tree). The regular md is unaffected.

In a clustered environment, different nodes use different bitmaps. While 
it worked for bitmaps smaller than a page (which is again a 
co-incidence), it did not work well for bitmaps which spanned multiple 
pages. Each node in the cluster has different start offsets, and the 
earlier calculation was incorrect because of conversion from bits to 
bytes was inverted.

If you were able to assemble on different nodes, you should be fine with 
respect to synchronization of unsynced blocks after a failure.

HTH,

>
> On Tue, Mar 24, 2015 at 9:15 PM, NeilBrown <neilb@suse.de> wrote:
>> On Tue, 24 Mar 2015 11:29:05 -0500 Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>>
>>> The calculations of bitmap offset is incorrect with respect to bits to bytes
>>> conversion.
>>>
>>> Also, remove an irrelevant duplicate message.
>>>
>>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>> ---
>>> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
>>> index ac79fef..e98db04 100644
>>> --- a/drivers/md/bitmap.c
>>> +++ b/drivers/md/bitmap.c
>>> @@ -575,7 +575,9 @@ re_read:
>>>
>>>                sector_div(bm_blocks,
>>>                           bitmap->mddev->bitmap_info.chunksize >> 9);
>>> -             bm_blocks = bm_blocks << 3;
>>> +             /* bits to bytes */
>>> +             bm_blocks = ((bm_blocks+7) >> 3) + sizeof(bitmap_super_t);
>>> +             /* to 4k blocks */
>>>                bm_blocks = DIV_ROUND_UP_SECTOR_T(bm_blocks, 4096);
>>>                bitmap->mddev->bitmap_info.offset += bitmap->cluster_slot * (bm_blocks << 3);
>>>                pr_info("%s:%d bm slot: %d offset: %llu\n", __func__, __LINE__,
>>> @@ -672,9 +674,6 @@ out:
>>>                        goto out_no_sb;
>>>                }
>>>                bitmap->cluster_slot = md_cluster_ops->slot_number(bitmap->mddev);
>>> -             pr_info("%s:%d bm slot: %d offset: %llu\n", __func__, __LINE__,
>>> -                     bitmap->cluster_slot,
>>> -                     (unsigned long long)bitmap->mddev->bitmap_info.offset);
>>>                goto re_read;
>>>        }
>>>
>>
>> Applied, thanks.
>>
>> NeilBrown

-- 
Goldwyn
