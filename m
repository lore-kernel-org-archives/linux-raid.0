From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] Revert "md: raid1: use bio helper in process_checks()"
Date: Wed, 29 Mar 2017 00:13:46 +0800
Message-ID: <CACVXFVN98gJHBGUwwP1u9Yxto_ft0LNv3Z0FXY4j+NBNAz_MLQ@mail.gmail.com>
References: <20170328095029.3500369-1-arnd@arndb.de> <CACVXFVMX=0XBvSt7b-3XObw3SknPGqH9JZvT6jViYbZfzKqQEg@mail.gmail.com>
 <CAK8P3a0k9S-t1CvpcabNVJOFMWoieuSn6EEr4oB72+T=zQT=aw@mail.gmail.com>
 <CACVXFVNzGV+P9CXcyqcV0_rJVM9F7dOR3_aX2xv0GQTsMaXX6A@mail.gmail.com>
 <CAK8P3a1yV0M_3TwM2QkEKqL-teKNEcWRXuG4_GT27pM+rFoBPw@mail.gmail.com>
 <CACVXFVMWORnxVtuokRp=N1ELAk4UbkOr0n-hM2MOTbO7HLhLtw@mail.gmail.com> <CAK8P3a0NfY56C_L+ds2VOXFtdT--WrZ=CoMMmd1JTM84KoYs0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a0NfY56C_L+ds2VOXFtdT--WrZ=CoMMmd1JTM84KoYs0A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Shaohua Li <shli@kernel.org>, NeilBrown <neilb@suse.com>, Jens Axboe <axboe@fb.com>, "colyli@suse.de" <colyli@suse.de>, Guoqing Jiang <gqjiang@suse.com>, Mike Christie <mchristi@redhat.com>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Mar 28, 2017 at 11:37 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tue, Mar 28, 2017 at 5:02 PM, Ming Lei <tom.leiming@gmail.com> wrote:
>> On Tue, Mar 28, 2017 at 9:20 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Tue, Mar 28, 2017 at 1:42 PM, Ming Lei <tom.leiming@gmail.com> wrote:
>
>>> What I meant is that a future change to the function might cause
>>> another bug to go unnoticed later.
>>
>> What is the future change? And what is another bug? Please don't suppose or
>> assume anything in future.
>>
>> BTW, I don't think it is a problem, and anyone who want to change the code
>> much should understand it first, right?
>
> I did not have any specific change in mind, I was just following the
> principle from https://rusty.ozlabs.org/?p=232
>
> I tend to do a lot of fixes for warnings like this, and in general
> adding a fake initialization will lead to worse object code while
> changing the code to be easier to understand by the compiler
> will also make it easier to understand by human readers, lead
> to better object code and to being more robust against future
> changes that would have otherwise triggered a correct warning.

What gcc can't understand is the following situation:

1) int a[N];

2) for(i = 0; i < vcnt1; i++)
       a[i] = b[i];

3) for (i = 0; i < vcnt2; i++)
        c[i] = a[i];

The warning is in 3), since gcc may think vcnt2 isn't same with vcnt1, but as
I mentioned that two number is absolutely same, and shouldn't be
changed in future.

That is why I suggest to fix the warning via a[N] = {0}.

>
>>>> The following code does initialize the array well enough for future use:
>>>>
>>>>                bio_for_each_segment_all(bi, sbio, j)
>>>>                        page_len[j] = bi->bv_len;
>>>>
>>>> That is why we don't need to initialize the array explicitly, but just
>>>> for killing the warning.
>>>
>>> It's also a little less clear why that is safe than the original code:
>>> We rely on sbio->bi_vcnt to be the same as vcnt, but it requires
>>
>> That is absolutely true because all read bios in process_checks()
>> have same vector number, do you think it will be changed in future?
>
> No, I have no reason to assume it would be changed.
>
>> And what we really rely on is that RESYNC_PAGES is equal to or bigger
>> than the vector number, and that is what we can guarantee.
>>
>>> careful reading of the function to see that this is always true.
>>> gcc warns because it cannot prove this to be the case, so if
>>> something changed here, it's likely that this would also not
>>> get noticed.
>>
>> The compiler can't understand runtime behaviour, and
>> we try to let gcc check more, but that is just fine if gcc can't.
>>
>> One big purpose of this patch is to remove direct access to
>> bvec table, so it can't be reverted, or do you have better idea?
>
> From what I can tell, the following walk of the pages does not
> have to be done in reverse, so we can perhaps use a single
> bio_for_each_segment_all() (only for illustration, haven't
> thought this through completely) :
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 4d176c8abc33..e4bcc7cec8da 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2157,25 +2157,30 @@ static void process_checks(struct r1bio *r1_bio)
>                 int error = sbio->bi_error;
>                 struct page **ppages = get_resync_pages(pbio)->pages;
>                 struct page **spages = get_resync_pages(sbio)->pages;
> +               struct bio_vec *bi;
> +               int page_len[RESYNC_PAGES];
> +
>
>                 if (sbio->bi_end_io != end_sync_read)
>                         continue;
>                 /* Now we can 'fixup' the error value */
>                 sbio->bi_error = 0;
>
> -               if (!error) {
> -                       for (j = vcnt; j-- ; ) {
> -                               if (memcmp(page_address(ppages[j]),
> -                                          page_address(spages[j]),
> -                                          sbio->bi_io_vec[j].bv_len))
> -                                       break;
> -                       }
> -               } else
> -                       j = 0;
> -               if (j >= 0)
> +               if (error) {
>                         atomic64_add(r1_bio->sectors,
> &mddev->resync_mismatches);
> -               if (j < 0 || (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)
> -                             && !error)) {
> +                       bio_copy_data(sbio, pbio);
> +                       continue;
> +               }
> +
> +               bio_for_each_segment_all(bi, sbio, j) {
> +                       if (memcmp(page_address(ppages[j]),
> +                                  page_address(spages[j]),
> +                                          sbio->bi_io_vec[j].bv_len)) {

The above line should be bi->bv_len, and this way should make the array
not necessary, but still a bit ugly.

I suggest to apply the simple fix first since it is correct, then we
can refactor the code in this way
later.

Thanks,
Ming Lei
