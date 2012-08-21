From: Dan Williams <djbw@fb.com>
Subject: Re: Re: raid5: When add stripe_head to inactive_list, it should
 remove hash.
Date: Tue, 21 Aug 2012 09:43:45 -0700
Message-ID: <CAA9_cmejVHOsW=u3WMusGSK8+CMiU978=kP5PVkxQO9T7VP1hA@mail.gmail.com>
References: <201208181053324376710@gmail.com>
	<201208201617046561993@gmail.com>
	<CAA9_cmePBesqWEpTfFOnajLuG355Po3X+52TpEvLoRD=DhCBFQ@mail.gmail.com>
	<201208211114430154301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201208211114430154301@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jianpeng Ma <majianpeng@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Aug 20, 2012 at 8:14 PM, Jianpeng Ma <majianpeng@gmail.com> wrote:
> On 2012-08-21 01:51 Dan Williams <djbw@fb.com> Wrote:
>>On Mon, Aug 20, 2012 at 1:17 AM, Jianpeng Ma <majianpeng@gmail.com> wrote:
>>> I think step4 maybe return ioerror.But it's success.
>>
>>You would need to check that stripe0 got recycled between step2 and
>>step3.  If not then the uptodate stripe is in the cache and the read
>>can be serviced from the cached data.
>>
>>...which seems to be the case because of:
>>
>>> [19277.585936] locked=0 uptodate=4 to_read=0 to_write=0 failed=1 failed_num=3,-1
>>
>
> Thanks! If stripe had a cache function.I think the chunk_aligned_read should use it for small read situation.

But the stripe cache is not meant to be a read cache as it would be
duplicating what the page cache offers.  Most aligned reads are likely
to miss the stripe cache so adding a lookup for every read would be
mostly wasted overhead.

--
Dan
