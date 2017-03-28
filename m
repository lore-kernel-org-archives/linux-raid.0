From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] Revert "md: raid1: use bio helper in process_checks()"
Date: Tue, 28 Mar 2017 23:02:34 +0800
Message-ID: <CACVXFVMWORnxVtuokRp=N1ELAk4UbkOr0n-hM2MOTbO7HLhLtw@mail.gmail.com>
References: <20170328095029.3500369-1-arnd@arndb.de> <CACVXFVMX=0XBvSt7b-3XObw3SknPGqH9JZvT6jViYbZfzKqQEg@mail.gmail.com>
 <CAK8P3a0k9S-t1CvpcabNVJOFMWoieuSn6EEr4oB72+T=zQT=aw@mail.gmail.com>
 <CACVXFVNzGV+P9CXcyqcV0_rJVM9F7dOR3_aX2xv0GQTsMaXX6A@mail.gmail.com> <CAK8P3a1yV0M_3TwM2QkEKqL-teKNEcWRXuG4_GT27pM+rFoBPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a1yV0M_3TwM2QkEKqL-teKNEcWRXuG4_GT27pM+rFoBPw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Shaohua Li <shli@kernel.org>, NeilBrown <neilb@suse.com>, Jens Axboe <axboe@fb.com>, "colyli@suse.de" <colyli@suse.de>, Guoqing Jiang <gqjiang@suse.com>, Mike Christie <mchristi@redhat.com>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Mar 28, 2017 at 9:20 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tue, Mar 28, 2017 at 1:42 PM, Ming Lei <tom.leiming@gmail.com> wrote:
>> On Tue, Mar 28, 2017 at 7:35 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Tue, Mar 28, 2017 at 12:44 PM, Ming Lei <tom.leiming@gmail.com> wrote:
>>>> On Tue, Mar 28, 2017 at 5:49 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>>>> Commit 60928a91b0b3 ("md: raid1: use bio helper in process_checks()")
>>>>> is probably correct, but I get a new compile-time warning after
>>>>> it, and have trouble understanding what it fixes:
>>>>>
>>>>> drivers/md/raid1.c: In function 'sync_request_write':
>>>>> drivers/md/raid1.c:2172:9: error: 'page_len$' may be used uninitialized in this function [-Werror=maybe-uninitialized]
>>>>>      if (memcmp(page_address(ppages[j]),
>>>>>          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>>>          page_address(spages[j]),
>>>>>          ~~~~~~~~~~~~~~~~~~~~~~~~
>>>>>          page_len[j]))
>>>>>          ~~~~~~~~~~~~
>>>>> drivers/md/raid1.c:2160:7: note: 'page_len$' was declared here
>>>>>    int page_len[RESYNC_PAGES];
>>>>>        ^~~~~~~~
>>>>>
>>>>> This reverts it to resolve the warning.
>>>>
>>>> Please try the following patch:
>>>>
>>>>  https://lkml.org/lkml/2017/3/28/126
>>>
>>>
>>> That patch will certainly shut up the warning, but will also prevent
>>> the compiler from warning when the function gets changed in some
>>> way that actually leads to an uninitialized use of the page_len array,
>>
>> Why do you think that it leads to an uninitialized use of the page_len array?
>
> What I meant is that a future change to the function might cause
> another bug to go unnoticed later.

What is the future change? And what is another bug? Please don't suppose or
assume anything in future.

BTW, I don't think it is a problem, and anyone who want to change the code
much should understand it first, right?

>
>> The following code does initialize the array well enough for future use:
>>
>>                bio_for_each_segment_all(bi, sbio, j)
>>                        page_len[j] = bi->bv_len;
>>
>> That is why we don't need to initialize the array explicitly, but just
>> for killing the warning.
>
> It's also a little less clear why that is safe than the original code:
> We rely on sbio->bi_vcnt to be the same as vcnt, but it requires

That is absolutely true because all read bios in process_checks()
have same vector number, do you think it will be changed in future?

And what we really rely on is that RESYNC_PAGES is equal to or bigger
than the vector number, and that is what we can guarantee.

> careful reading of the function to see that this is always true.
> gcc warns because it cannot prove this to be the case, so if
> something changed here, it's likely that this would also not
> get noticed.

The compiler can't understand runtime behaviour, and
we try to let gcc check more, but that is just fine if gcc can't.

One big purpose of this patch is to remove direct access to
bvec table, so it can't be reverted, or do you have better idea?


Thanks,
Ming Lei
