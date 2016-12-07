From: Coly Li <colyli@suse.de>
Subject: Re: raid0 vs. mkfs
Date: Wed, 7 Dec 2016 20:03:11 +0800
Message-ID: <d1bc8201-7b4e-e85a-c1dc-b00c325ec23e@suse.de>
References: <56c83c4e-d451-07e5-88e2-40b085d8681c@scylladb.com>
 <87oa108a1x.fsf@notabene.neil.brown.name>
 <286a5fc1-eda3-0421-a88e-b03c09403259@scylladb.com>
 <87inr880au.fsf@notabene.neil.brown.name>
 <df73ebc4-9b78-09b5-022b-089c30dea17c@scylladb.com>
 <87d1he7zv9.fsf@notabene.neil.brown.name>
 <33bb250a-4dfd-0acc-9958-30fdac10918c@scylladb.com>
 <ccf447df-e7b5-0a08-7753-67ee4ad574ef@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ccf447df-e7b5-0a08-7753-67ee4ad574ef@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Avi Kivity <avi@scylladb.com>, NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-raid.ids

On 2016/12/7 下午7:50, Coly Li wrote:
> On 2016/11/30 上午6:45, Avi Kivity wrote:
>> On 11/29/2016 11:14 PM, NeilBrown wrote:
> [snip]
> 
>>>> So I disagree that all the work should be pushed to the merging layer.
>>>> It has less information to work with, so the fewer decisions it has to
>>>> make, the better.
>>> I think that the merging layer should be as efficient as it reasonably
>>> can be, and particularly should take into account plugging.  This
>>> benefits all callers.
>>
>> Yes, but plugging does not mean "please merge anything you can until the
>> unplug".
>>
>>> If it can be demonstrated that changes to some of the upper layers bring
>>> further improvements with acceptable costs, then certainly it is good to
>>> have those too.
>>
>> Generating millions of requests only to merge them again is
>> inefficient.  It happens in an edge case (TRIM of the entirety of a very
>> large RAID), but it already caused on user to believe the system
>> failed.  I think the system should be more robust than that.
> 
> Neil,
> 
> As my understand, if a large discard bio received by
> raid0_make_request(), for example it requests to discard chunk 1 to 24
> on a raid0 device built by 4 SSDs. This large discard bio will be split
> and written to each SSD as the following layout,
> 
> SSD1: C1,C5,C9,C13,C17,C21
> SSD2: C2,C6,C10,C14,C18,C22
> SSD3: C3,C7,C11,C15,C19,C23
> SSD4: C4,C8,C12,C16,C20,C24
> 
> Current raid0 code will call generic_make_request() for 24 times for
> each split bio. But it is possible to calculate the final layout of each
> split bio, so we can combine all the bios into four per-SSD large bio,
> like this,
> 
> bio1 (on SSD1): C{1,5,9,13,17,21}
> bio2 (on SSD2): C{2,6,10,14,18,22}
> bio3 (on SSD3): C{3,7,11,15,19,23}
> bio4 (on SSD4): C{4,8,12,16,20,24}
> 
> Now we only need to call generic_make_request() for 4 times. Rebuild the
> per-device discard bios is more efficient in raid0 code then in block
> layer. There are some reasons that I know,
> - there are splice timeout, block layer cannot merge all split bio into
> one large bio before time out.
> - rebuilt per-device bio in raid0 is just by a few calculation, block
> layer does merge on queue with list operations, it is slower.
> - raid0 code knows its on disk layout, so rebuild per-device bio is
> possible here. block layer has no idea on raid0 layout, it can only do
> request merge.
> 
> Avi,
> 
> I compose a prototype patch, the code is not simple, indeed it is quite
> complicated IMHO.
> 
> I do a little research, some NVMe SSDs support whole device size
> DISCARD, also I observe mkfs.xfs sends out a raid0 device size DISCARD
> bio to block layer. But raid0_make_request() only receives 512KB size
> DISCARD bio, block/blk-lib.c:__blkdev_issue_discard() splits the
> original large bio into 512KB small bios, the limitation is from
> q->limits.discard_granularity.
> 
> At this moment, I don't know why a q->limits.discard_granularity is
> 512KB even the underlying SSD supports whole device size discard. We
> also need to fix q->limits.discard_granularity, otherwise
> block/blk-lib.c:__blkdev_issue_discard() still does an inefficient loop
> to split the original large discard bio into smaller ones and sends them
> to raid0 code by next_bio().
> 
> I also CC this email to linux-block@vger.kernel.org to ask for help. My
> question is, if a NVMe SSD supports whole-device-size DISCARD, is
> q->limits.discard_granularity still necessary ?
> 
> Here I also attach my prototype patch as a proof of concept, it is
> runnable with Linux 4.9-rc7.

Aha! It is not limits.discard_granularity, it is
limits.max_discard_sectors. Which is set in raid0.c:raid0_run() by
blk_queue_max_discard_sectors(). Here limits.maxZ_discard_sectors is set
to raid0 chunk size. Interesting ....

And, linux-block@vger.kernel.org, please ignore my noise.

Coly
