Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF64C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 23 Jun 2022 00:39:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359797AbiFWAjr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Jun 2022 20:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359064AbiFWAjm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Jun 2022 20:39:42 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1F52ED61;
        Wed, 22 Jun 2022 17:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1655944772;
        bh=vLpKTrmS6oa6LCiYTQGoPDnQJpWLDwlxmUUni+bFXRI=;
        h=X-UI-Sender-Class:Date:To:Cc:References:From:Subject:In-Reply-To;
        b=JqVgcu/g84WkbGtqj3NQLRhEuroqBn0SUJDtK0QCTi2C+nUllx43XQL4eXJcgtqQM
         0qp6nVh8Omfo2615k4vA1Xzzim/p84KUb5tuhaTG8Lc29LwLJTaGVqC0eTjWqykFMu
         t54B7gGgeqT0jG8w4B7XJlByhhbXT5RDeJeFVhlU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MZCfJ-1o8Jk50E9B-00V5Ae; Thu, 23
 Jun 2022 02:39:32 +0200
Message-ID: <a09d6a24-6e1a-0243-ea4c-ac6d6127b69d@gmx.com>
Date:   Thu, 23 Jun 2022 08:39:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     NeilBrown <neilb@suse.de>
Cc:     Doug Ledford <dledford@redhat.com>,
        Wols Lists <antlists@youngman.org.uk>,
        linux-raid@vger.kernel.org,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <d4163d9f-8900-1ec1-ffb8-c3834c512279@gmx.com>
 <63a9cfb7-4999-d902-a7df-278e2ec37593@youngman.org.uk>
 <1704788b-fb7d-b532-4911-238e4f7fd448@gmx.com>
 <06365833-bd91-7dcf-4541-f8e15ed3bef2@youngman.org.uk>
 <87cb53c4f08cc7b18010e62b9b3178ed70e06e8d.camel@redhat.com>
 <d15f352d-41b8-8ade-4724-8370ef17db8d@gmx.com>
 <165593717589.4786.11549155199368866575@noble.neil.brown.name>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: About the md-bitmap behavior
In-Reply-To: <165593717589.4786.11549155199368866575@noble.neil.brown.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:jZO022q0p/WKLNmFsWNLX1A5px/1kvQlq3HC7XSs1QhASvl4TzT
 bORBnCb2gQjg6o/oF8arQMFS7P2Bipu/fPYSny1nL3stbrshkPmDbSZhzE+2uosGz6U1394
 /bZ5A63WZsfzqnsD0GPxjeHxAX/rF4WsL6K8OCrefBzU5y/s5Wjm3gGTWzX5kdmlfW0UvA6
 nBDF0EGXkeS1SU/y3ER8w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ho3CdDmJppM=:vKThbL5vjS7noccLsyM/WF
 XvGK/WktJU5qrL49VZBXsBtvSFjPdZp7kZtHk5pPWxQTBWxMRO9BgA9kOc9d1T0wjfqK2nTVV
 xSy8VNLcqGURfUGVUbJsXrUt/tjkWRaWzQBDiXVvp61w9G1MwNcaWFcy5NV0rrlpi3LYCmguO
 gTYL8twvbDhyry3WwOoxENxLFtkji/wC9NUvAv3itwt1PnkUGno/ExfspsUNitm1Yg30pfHUG
 1JnHSrCM91aBtr4lQ8N4Pzka8oH1FLWUxalaFD0q5r8XYciWk6OcSPjIh7QjfyK4/iFDOAIUA
 OlJMUQ0URUVo6tkwxHBN5Qv31VyZ+0dYdqQuztamxbAq2XCmmh9UPYCHTRt/lvhDdyQctUdhq
 RBY1QhkcOPaxqDHosDQhVFUTzdYcH1WIgIiSV+Z7eCMq0uDI8Rj4PXdBQsWMsDudMM/cHEBOu
 4B25CiNQ0UUBrhdjrGDNF7VO1FlDEwsCoSejAd+5G2CPLhFfTS7mDVkv1w3Zxbortf9SKeloz
 Mze9YlDG/afk+CT2MtByT/oB2VcTf3yYS5sWDog30UitmVdQvMlIVn2snAKo/HBdOaoCFNRDw
 4J8U/akOt10oUGZ1//mom9bTnyTulrf/AoaOSsFPMi/7vCq+usLT01n1lceJV2F4Nus6obMVY
 PQzmPy4Nu+TXBev7RVEhedt8pQGZJQw8H8Ts9hWr14vcj17xIpAg4FZmqtDt5oLmbf72IGKJC
 6IoN8ZbxX7Y9JXG9LFXX74oerv1XdqAp1xOHJ3vQhGhu35S/4HT7ZIV2Fxb1fB+UH37RTZ5fq
 lUFR6+hBZcBWE9sSR5xPh8BVsZKcihPxRhRxSgxBUYrgKW/xqbtjdy53COnhQF4uPqB2k8qNH
 TWtjRD74j8u8YYTOUtI/sQpLNP8mTRxpw5+8fXQXY7fNBNS4g34MYWTpTKpoF2niT4SioQ/g1
 qb4XmkhvrY9VY0d5N9BbGrPouMpkY19WYcEG6SNITpPWb8iMtK1L5f5b4LIbKDNeaNl+JABdQ
 KSFojnHo+RzBLueBdlN1y3CufP1Djn16zIN8ku736nPxDjbvAFoHf3afSeiMGfZ+TQkiGs1Vc
 LfT4zl3zR6ik6mxrU0t9EHdyORndX0CEIRc1nq0os8i/KSpj3s6Urft7g==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022/6/23 06:32, NeilBrown wrote:
> On Wed, 22 Jun 2022, Qu Wenruo wrote:
>>
>> On 2022/6/22 10:15, Doug Ledford wrote:
>>> On Mon, 2022-06-20 at 10:56 +0100, Wols Lists wrote:
>>>> On 20/06/2022 08:56, Qu Wenruo wrote:
>>>>>> The write-hole has been addressed with journaling already, and
>>>>>> this will
>>>>>> be adding a new and not-needed feature - not saying it wouldn't be
>>>>>> nice
>>>>>> to have, but do we need another way to skin this cat?
>>>>>
>>>>> I'm talking about the BTRFS RAID56, not md-raid RAID56, which is a
>>>>> completely different thing.
>>>>>
>>>>> Here I'm just trying to understand how the md-bitmap works, so that
>>>>> I
>>>>> can do a proper bitmap for btrfs RAID56.
>>>>
>>>> Ah. Okay.
>>>>
>>>> Neil Brown is likely to be the best help here as I believe he wrote a
>>>> lot of the code, although I don't think he's much involved with md-
>>>> raid
>>>> any more.
>>>
>>> I can't speak to how it is today, but I know it was *designed* to be
>>> sync flush of the dirty bit setting, then lazy, async write out of the
>>> clear bits.  But, yes, in order for the design to be reliable, you mus=
t
>>> flush out the dirty bits before you put writes in flight.
>>
>> Thank you very much confirming my concern.
>>
>> So maybe it's me not checking the md-bitmap code carefully enough to
>> expose the full picture.
>>
>>>
>>> One thing I'm not sure about though, is that MD RAID5/6 uses fixed
>>> stripes.  I thought btrfs, since it was an allocation filesystem, didn=
't
>>> have to use full stripes?  Am I wrong about that?
>>
>> Unfortunately, we only go allocation for the RAID56 chunks. In side a
>> RAID56 the underlying devices still need to go the regular RAID56 full
>> stripe scheme.
>>
>> Thus the btrfs RAID56 is still the same regular RAID56 inside one btrfs
>> RAID56 chunk, but without bitmap/journal.
>>
>>>   Because it would seem
>>> that if your data isn't necessarily in full stripes, then a bitmap mig=
ht
>>> not work so well since it just marks a range of full stripes as
>>> "possibly dirty, we were writing to them, do a parity resync to make
>>> sure".
>>
>> For the resync part is where btrfs shines, as the extra csum (for the
>> untouched part) and metadata COW ensures us only see the old untouched
>> data, and with the extra csum, we can safely rebuild the full stripe.
>>
>> Thus as long as no device is missing, a write-intent-bitmap is enough t=
o
>> address the write hole in btrfs (at least for COW protected data and al=
l
>> metadata).
>>
>>>
>>> In any case, Wols is right, probably want to ping Neil on this.  Might
>>> need to ping him directly though.  Not sure he'll see it just on the
>>> list.
>>>
>>
>> Adding Neil into this thread. Any clue on the existing
>> md_bitmap_startwrite() behavior?
>
> md_bitmap_startwrite() is used to tell the bitmap code that the raid
> module is about to start writing at a location.  This may result in
> md_bitmap_file_set_bit() being called to set a bit in the in-memory copy
> of the bitmap, and to make that page of the bitmap as BITMAP_PAGE_DIRTY.
>
> Before raid actually submits the writes to the device it will call
> md_bitmap_unplug() which will submit the writes and wait for them to
> complete.

Ah, that's the missing piece, thank you very much for pointing this out.

Looks like I'm not familiar with that unplug part at all.

Great to learn something new.

>
> The is a comment at the top of md/raid5.c titled "BITMAP UNPLUGGING"
> which says a few things about how raid5 ensure things happen in the
> right order.
>
> However I don't think if any sort of bitmap can solve the write-hole
> problem for RAID5 - even in btrfs.
>
> The problem is that if the host crashes while the array is degraded and
> while some write requests were in-flight, then you might have lost data.
> i.e.  to update a block you must write both that block and the parity
> block.  If you actually wrote neither or both, everything is fine.  If
> you wrote one but not the other then you CANNOT recover the data that
> was on the missing device (there must be a missing device as the array
> is degraded).  Even having checksums of everything is not enough to
> recover that missing block.

However btrfs also has COW, this ensure after crash, we will only try to
read the old data (aka, the untouched part).

E.g.
btrfs uses 64KiB as stripe size.
O =3D Old data
N =3D New writes

	0	32K	64K
D1	|OOOOOOO|NNNNNNN|
D2	|NNNNNNN|OOOOOOO|
P	|NNNNNNN|NNNNNNN|

In above case, no matter if the new write reaches disks, as long as the
crash happens before we update all the metadata and superblock (which
implies a flush for all involved devices), the fs will only try to read
the old data.

So at this point, our data read on old data is still correct.
But the parity no longer matches, thus degrading our ability to tolerate
device lost.

With write-intent bitmap, we know this full stripe has something out of
sync, so we can re-calculate the parity.

Although, all above condition needs two things:

- The new write is CoWed.
   It's mandatory for btrfs metadata, so no problem. But for btrfs data,
   we can have NODATACOW (also implies NDOATASUM), and in that case,
   corruption will be unavoidable.

- The old data should never be changed
   This means, the device can not disappear during the recovery.
   If powerloss + device missing happens, this will not work at all.

>
> You must either:
>   1/ have a safe duplicate of the blocks being written, so they can be
>     recovered and re-written after a crash.  This is what journalling
>     does.  Or

Yes, journal would be the next step to handle NODATACOW case and device
missing case.

>   2/ Only write to location which don't contain valid data.  i.e.  alway=
s
>     write full stripes to locations which are unused on each device.
>     This way you cannot lose existing data.  Worst case: that whole
>     stripe is ignored.  This is how I would handle RAID5 in a
>     copy-on-write filesystem.

That is something we considered in the past, but considering even now we
still have space reservation problems sometimes, I doubt such change
would cause even more problems than it can solve.

>
> However, I see you wrote:
>> Thus as long as no device is missing, a write-intent-bitmap is enough t=
o
>> address the write hole in btrfs (at least for COW protected data and al=
l
>> metadata).
>
> That doesn't make sense.  If no device is missing, then there is no
> write hole.
> If no device is missing, all you need to do is recalculate the parity
> blocks on any stripe that was recently written.

That's exactly what we need and want to do.

>  In md with use the
> write-intent-bitmap.  In btrfs I would expect that you would already
> have some way of knowing where recent writes happened, so you can
> validiate the various checksums.
> That should be sufficient to
> recalculate the parity.  I've be very surprised if btrfs doesn't already
> do this.

That's the problem, we previously completely rely on COW, thus there is
no such facility like write-intent-bitmap at all.

After a powerloss, btrfs knows nothing about previous crash, and
completely rely on csum + COW + duplication to correct any error at read
time.

It's completely fine for RAID1 based profiles, but not for RAID56.

>
> So I'm somewhat confuses as to what your real goal is.

Yep, the btrfs RAID56 is missing something very basic, thus I guess
that's causing the confusion.

Thanks,
Qu

>
> NeilBrown
