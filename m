From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: [PATCH v3] md: improve io stats accounting
Date: Fri, 3 Jul 2020 10:33:49 +0200
Message-ID: <aea49756-c6f6-a4a3-3e23-9928e0878c80@cloud.ionos.com>
References: <20200702142926.4419-1-artur.paszkiewicz@intel.com>
 <CAPhsuW5eMPMH1HcMXi67Ci0rbWhVyiuLodVZB_oaGbrR7abTJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW5eMPMH1HcMXi67Ci0rbWhVyiuLodVZB_oaGbrR7abTJQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 7/2/20 11:25 PM, Song Liu wrote:
> On Thu, Jul 2, 2020 at 7:29 AM Artur Paszkiewicz
> <artur.paszkiewicz@intel.com> wrote:
>> Use generic io accounting functions to manage io stats. There was an
>> attempt to do this earlier in commit 18c0b223cf99 ("md: use generic io
>> stats accounting functions to simplify io stat accounting"), but it did
>> not include a call to generic_end_io_acct() and caused issues with
>> tracking in-flight IOs, so it was later removed in commit 74672d069b29
>> ("md: fix md io stats accounting broken").
>>
>> This patch attempts to fix this by using both bio_start_io_acct() and
>> bio_end_io_acct(). To make it possible, a struct md_io is allocated for
>> every new md bio, which includes the io start_time. A new mempool is
>> introduced for this purpose. We override bio->bi_end_io with our own
>> callback and call bio_start_io_acct() before passing the bio to
>> md_handle_request(). When it completes, we call bio_end_io_acct() and
>> the original bi_end_io callback.
>>
>> This adds correct statistics about in-flight IOs and IO processing time,
>> interpreted e.g. in iostat as await, svctm, aqu-sz and %util.
>>
>> It also fixes a situation where too many IOs where reported if a bio was
>> re-submitted to the mddev, because io accounting is now performed only
>> on newly arriving bios.
>>
>> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> Thanks Artur and Guoqing!
>
> I run quick test with this. Seems it only adds proper statistics to
> raid5 array, but
> not to raid0 array. Is this expected?

Because bio_endio is not called, and it is same for linear and faulty.
I think we have to  clone bio for them ..., then it is better to do the
job in the personality layer.

1. For md-multipath, raid1 and raid10, track start time by change the
multipath_bh, r1bio and r10bio.

2. For raid5, override the bi_end_io like this.

3. Then other personalities have to clone bio ...

Thanks,
Guoqing
