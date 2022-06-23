Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B9DC433EF
	for <linux-raid@archiver.kernel.org>; Thu, 23 Jun 2022 00:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344256AbiFWAxX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Jun 2022 20:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbiFWAxW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Jun 2022 20:53:22 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A4A2F033;
        Wed, 22 Jun 2022 17:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1655945588;
        bh=zmE7G8BXzie53fcxIfqxCu5irX3rAOOSehdjd779CEw=;
        h=X-UI-Sender-Class:Date:To:Cc:References:From:Subject:In-Reply-To;
        b=lQIzqMMovAM/Vhto8Zy3Wxh79WCexpmFMrsMXjrmiUedFlZohIQKdyld1GNN/JsBs
         zAjifQAz0rRm5Zr20UWIqAPYfsmIlbtlbTGeAAWpTraMj9DWQl2KN1eh2mWu3F9dV4
         z4TDei6W5J5cjsNWU0X8qvK0CUdCV9l/Ed4rhWnc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MNt0C-1oJcTb2PbE-00OJxq; Thu, 23
 Jun 2022 02:53:08 +0200
Message-ID: <bb4245e0-9cbc-f372-f027-4e86cd9a362f@gmx.com>
Date:   Thu, 23 Jun 2022 08:53:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Song Liu <song@kernel.org>, NeilBrown <neilb@suse.de>
Cc:     Doug Ledford <dledford@redhat.com>,
        Wols Lists <antlists@youngman.org.uk>,
        linux-raid <linux-raid@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <d4163d9f-8900-1ec1-ffb8-c3834c512279@gmx.com>
 <63a9cfb7-4999-d902-a7df-278e2ec37593@youngman.org.uk>
 <1704788b-fb7d-b532-4911-238e4f7fd448@gmx.com>
 <06365833-bd91-7dcf-4541-f8e15ed3bef2@youngman.org.uk>
 <87cb53c4f08cc7b18010e62b9b3178ed70e06e8d.camel@redhat.com>
 <d15f352d-41b8-8ade-4724-8370ef17db8d@gmx.com>
 <165593717589.4786.11549155199368866575@noble.neil.brown.name>
 <CAPhsuW6CZwhUVw7iE7GhTRkuQmRfu9i+O6_V2C5buTNFvZ76mA@mail.gmail.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: About the md-bitmap behavior
In-Reply-To: <CAPhsuW6CZwhUVw7iE7GhTRkuQmRfu9i+O6_V2C5buTNFvZ76mA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:69tQHBLIA3hhGMJj6K2ibTeJ8DOkEH4z2fM8Rdm8GxDfeNJDr53
 /z7LhNk0oUv+C01T55HRxwCwkWTdwMB6B6e3Y/9158pHoDt+2Ku9zS+Ai5guVgpk18alQjb
 JhSDJQc1GifsetxenRKnsO5Jufj98oJiSFvs1+vdC84xbl7l5hUpa5XH3X8cWwo0feB5VgM
 N7G5gHP6w/esMrrfIom1A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:T+ScwQdp7go=:uDeO2I9UmaBd0zb09bEzkv
 d2PJxbiZe3l9XxBYZR2QtX2L+auDRZgHf2EJl/DCWmDS1eelM+NZZ/wjoK8xAybUc5NCCT0bO
 WVYAX8vo9bQ5UQnynbIykk+twOjYWFDiolzUmvBxSejvbW6c0opHTnU2JgjzSMhk8R/JHWYDt
 zCIp9hxWg2AcJ/Rjkd7Fh0BdgePGomgv1ld5lMmDzqEo9dkzsmVCp6UmJy/s13v52rzgwzzOa
 E7rWAXvVWH/quIjd4lRrBRybDPr+Br7nsstadMjGnu6pJ3w3PS3xY1Tj5N1CJq/zbeQvgfwoF
 +cInrUMzYlygmHwLNoDF0PipHzylIiBiXMynYBdHTAdSoB9SLgCm0asn+UyqkyT/dE+yaoR3p
 LAmUKJyjZZGRPgkn21OtdOrN24ZaxCcwi47MjFYwxCAdOp7ZpaRrVl5GGzyVCvdrTzsKegh6g
 uBprajaVme10hhAy302CVmU+DD8MA6ip2mSX0/mueaEHZCWuyfszX60Mil89wzEsdMKWm4gPl
 fjvcLjDBLVulmovgg0DYPq9maoLK9PKCLiXMbfDgfBvGbAriWIFfBC26mVfi9dXcD+7HagbdJ
 AZrGFGbKp9BizyS6NlnC+g3ZCd3tWXLAUXXSWZXOG2/8+qdLH2TD8VMRU+c3GgdmHjwH/pj61
 R7C8UQocHhyTe8Ddfk3sSX3EQzbD7OLrqsOzwLYX5KNnixpl9z7joQSUipSoN86TkwVDL71Jw
 P8RehJ5VVoeUTDAd25xyCc5/xe9x+/xcebzUSCTdZhL6Jo/Zk+51+LdYqG5BzFdoh0YbSf02h
 690/XhxfGOxWKZBPvFOmx4aacWerFgdExytH1eGeiY5USpfKSbrtSFbjW1lb279sJ19O63ivO
 GIs7b2O8IipIufIcMg0EJzzsHvt7dK1rvldfTufEhyWLNT2uQqb8Tj0R+9iy0gdROfW8M/B/z
 1kkX0ZrVU6EQ5U5qTvdmWTOQB4IbUKfbbpfXWPjcQtB28AnmkranCzcFlbnBfq8rnTPPIuvYI
 fd40TZ8kqu4SoGfDzs/SfbbJd08sLruBNOOlMWKpFuMG2mOFuWba7YEtKtA0dBBSEiEY6IOri
 ZM3PM6gWeT/m+eVtTSG+zrbsYA499am1dBjlN/LN+N9HDZB6kx5NwVIrw==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022/6/23 07:00, Song Liu wrote:
> On Wed, Jun 22, 2022 at 3:33 PM NeilBrown <neilb@suse.de> wrote:
>>
>> On Wed, 22 Jun 2022, Qu Wenruo wrote:
>>>
>>> On 2022/6/22 10:15, Doug Ledford wrote:
>>>> On Mon, 2022-06-20 at 10:56 +0100, Wols Lists wrote:
>>>>> On 20/06/2022 08:56, Qu Wenruo wrote:
>>>>>>> The write-hole has been addressed with journaling already, and
>>>>>>> this will
>>>>>>> be adding a new and not-needed feature - not saying it wouldn't be
>>>>>>> nice
>>>>>>> to have, but do we need another way to skin this cat?
>>>>>>
>>>>>> I'm talking about the BTRFS RAID56, not md-raid RAID56, which is a
>>>>>> completely different thing.
>>>>>>
>>>>>> Here I'm just trying to understand how the md-bitmap works, so that
>>>>>> I
>>>>>> can do a proper bitmap for btrfs RAID56.
>>>>>
>>>>> Ah. Okay.
>>>>>
>>>>> Neil Brown is likely to be the best help here as I believe he wrote =
a
>>>>> lot of the code, although I don't think he's much involved with md-
>>>>> raid
>>>>> any more.
>>>>
>>>> I can't speak to how it is today, but I know it was *designed* to be
>>>> sync flush of the dirty bit setting, then lazy, async write out of th=
e
>>>> clear bits.  But, yes, in order for the design to be reliable, you mu=
st
>>>> flush out the dirty bits before you put writes in flight.
>>>
>>> Thank you very much confirming my concern.
>>>
>>> So maybe it's me not checking the md-bitmap code carefully enough to
>>> expose the full picture.
>>>
>>>>
>>>> One thing I'm not sure about though, is that MD RAID5/6 uses fixed
>>>> stripes.  I thought btrfs, since it was an allocation filesystem, did=
n't
>>>> have to use full stripes?  Am I wrong about that?
>>>
>>> Unfortunately, we only go allocation for the RAID56 chunks. In side a
>>> RAID56 the underlying devices still need to go the regular RAID56 full
>>> stripe scheme.
>>>
>>> Thus the btrfs RAID56 is still the same regular RAID56 inside one btrf=
s
>>> RAID56 chunk, but without bitmap/journal.
>>>
>>>>   Because it would seem
>>>> that if your data isn't necessarily in full stripes, then a bitmap mi=
ght
>>>> not work so well since it just marks a range of full stripes as
>>>> "possibly dirty, we were writing to them, do a parity resync to make
>>>> sure".
>>>
>>> For the resync part is where btrfs shines, as the extra csum (for the
>>> untouched part) and metadata COW ensures us only see the old untouched
>>> data, and with the extra csum, we can safely rebuild the full stripe.
>>>
>>> Thus as long as no device is missing, a write-intent-bitmap is enough =
to
>>> address the write hole in btrfs (at least for COW protected data and a=
ll
>>> metadata).
>>>
>>>>
>>>> In any case, Wols is right, probably want to ping Neil on this.  Migh=
t
>>>> need to ping him directly though.  Not sure he'll see it just on the
>>>> list.
>>>>
>>>
>>> Adding Neil into this thread. Any clue on the existing
>>> md_bitmap_startwrite() behavior?
>>
>> md_bitmap_startwrite() is used to tell the bitmap code that the raid
>> module is about to start writing at a location.  This may result in
>> md_bitmap_file_set_bit() being called to set a bit in the in-memory cop=
y
>> of the bitmap, and to make that page of the bitmap as BITMAP_PAGE_DIRTY=
.
>>
>> Before raid actually submits the writes to the device it will call
>> md_bitmap_unplug() which will submit the writes and wait for them to
>> complete.
>>
>> The is a comment at the top of md/raid5.c titled "BITMAP UNPLUGGING"
>> which says a few things about how raid5 ensure things happen in the
>> right order.
>>
>> However I don't think if any sort of bitmap can solve the write-hole
>> problem for RAID5 - even in btrfs.
>>
>> The problem is that if the host crashes while the array is degraded and
>> while some write requests were in-flight, then you might have lost data=
.
>> i.e.  to update a block you must write both that block and the parity
>> block.  If you actually wrote neither or both, everything is fine.  If
>> you wrote one but not the other then you CANNOT recover the data that
>> was on the missing device (there must be a missing device as the array
>> is degraded).  Even having checksums of everything is not enough to
>> recover that missing block.
>>
>> You must either:
>>   1/ have a safe duplicate of the blocks being written, so they can be
>>     recovered and re-written after a crash.  This is what journalling
>>     does.  Or
>>   2/ Only write to location which don't contain valid data.  i.e.  alwa=
ys
>>     write full stripes to locations which are unused on each device.
>>     This way you cannot lose existing data.  Worst case: that whole
>>     stripe is ignored.  This is how I would handle RAID5 in a
>>     copy-on-write filesystem.
>
> Thanks Neil for explaining this. I was about to say the same idea, but
> couldn't phrase it well.
>
> md raid5 suffers from write hole because the mapping from array-LBA to
> component-LBA is fixed.

In fact, inside one btrfs RAID56 chunk, it's the same fixed
logical->physical mapping.
Thus we still have the problem.

> As a result, we have to update the data in place.
> btrfs already has file-to-LBA mapping, so it shouldn't be too expensive =
to
> make btrfs free of write hole. (no need for maintain extra mapping, or
> add journaling).

Unfortunately, btrfs is not that flex yet.

In fact, btrfs just does its mapping in a much smaller graduality.

So in btrfs we have the following mapping scheme:
				1G	2G	3G	4G
Btrfs logical address space:  	| RAID1 | RAID5 | EMPTY |  ...

And logical address range [1G, 2G) is mapped using RAID1, using some
physical ranges from 2 devices in the pool

Logical address range [2G, 3G) is mapped using RAID5, using some
physical ranges from several devices in the pool.

Logical address range [3G, 4G) is not mapped, read/write that range
would directly lead to -EIO.

By this, you can see, btrfs is not as flex as you think.
Yes, we have file -> logical address mapping, but inside each mapped
logical address range, everything is still fixed mapping.

If we want to really make extent allocator (which currently works at
logical address level, no caring the underlying mapping at all) to avoid
partial stripe write, it's a lot of cross-layer work.

In fact, Johannes is working on an extra layer of mapping for RAID56, by
that it can be possible to do extra mapping to avoid partial write.
But that requires a lot of work, and may not even work for metadata.

Thus I'm still exploring the tried-and-true methods like
write-intent-bitmap and journal for btrfs RAID56.

Thanks,
Qu

>
> Thanks,
> Song
>
>>
>> However, I see you wrote:
>>> Thus as long as no device is missing, a write-intent-bitmap is enough =
to
>>> address the write hole in btrfs (at least for COW protected data and a=
ll
>>> metadata).
>>
>> That doesn't make sense.  If no device is missing, then there is no
>> write hole.
>> If no device is missing, all you need to do is recalculate the parity
>> blocks on any stripe that was recently written.  In md with use the
>> write-intent-bitmap.  In btrfs I would expect that you would already
>> have some way of knowing where recent writes happened, so you can
>> validiate the various checksums.  That should be sufficient to
>> recalculate the parity.  I've be very surprised if btrfs doesn't alread=
y
>> do this.
>>
>> So I'm somewhat confuses as to what your real goal is.
>>
>> NeilBrown
