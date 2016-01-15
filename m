From: Ming Lei <ming.lei@canonical.com>
Subject: Re: writeback: Stability issue (BUG) on 4.4 with writeback_percent
Date: Fri, 15 Jan 2016 11:19:08 +0800
Message-ID: <CACVXFVOKVusaPagOXn_5gye0h0gA9ACTuHWSzjZD8evbdsnXrQ@mail.gmail.com>
References: <loom.20160114T081429-882@post.gmane.org>
	<CAF1ivSY9urc58Ff6axkNrQX8hYxCZNRhAMcH6cEPyyeiBO+=MA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <CAF1ivSY9urc58Ff6axkNrQX8hYxCZNRhAMcH6cEPyyeiBO+=MA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: Miu Vlad-Cosmin <miuvlad@gmail.com>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Cc raid list.

On Fri, Jan 15, 2016 at 1:51 AM, Ming Lin <mlin@kernel.org> wrote:
> On Wed, Jan 13, 2016 at 11:22 PM, Miu Vlad-Cosmin <miuvlad@gmail.com> wrote:
>> Hello,
>>
>> In a rather basic bcache setup (one cache + mdraid backing),
>> I encounter a kernel problem related to bcache with 4.4.0.
>>
>> In order to trigger this bug, fill the cache with some dirty data.
>> When there is some dirty data, wait for the bcache_writeback to
>> start writing it to the backing device (0-3 minutes)
>> and the BUG triggers.
>>
>> Please find more info here: https://bugzilla.kernel.org/show_bug.cgi?id=110771
>>
>> [<ffffffff815822af>] make_request+0x47f/0xca0
>> [<ffffffff815a5d3d>] md_make_request+0xdd/0x220
>> [<ffffffff810c53ce>] ? pick_next_task_fair+0x12e/0x450
>> [<ffffffff81311d2e>] generic_make_request+0xce/0x1b0
>> [<ffffffff815a1b70>] write_dirty+0x60/0xb0
>> [<ffffffff810aafa7>] process_one_work+0x147/0x3d0
>> [<ffffffff810ab546>] worker_thread+0x46/0x440
>> [<ffffffff810ab500>] ? rescuer_thread+0x2d0/0x2d0
>> [<ffffffff810ab500>] ? rescuer_thread+0x2d0/0x2d0
>> [<ffffffff810afeb4>] kthread+0xc4/0xe0
>> [<ffffffff810afdf0>] ? kthread_park+0x50/0x50
>> [<ffffffff8170c85f>] ret_from_fork+0x3f/0x70
>>
>> A bisect shows "[578270bfbd2803dc7b0b03fbc2ac119efbc73195]
>> block: fix segment split" as the problem.

It is the 2nd time to report this commit as 'regression', and last time
it is because bio bounce is after splitting. The commit itself is correct
and the report should be false positive,  the real bug might be related
with bio splitting.

> [   83.436844] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
> [   83.437025] IP: [<ffffffff81309ce5>] bio_trim+0x15/0xe0

0028 should be offset of 'bio->bi_iter.bi_size', so looks 'read_bio' from
bio_clone_mddev() is NULL?

BTW,  can some write loading trigger the bug just on raid1 without bcache?

Thanks,

>
> CC Ming Lei.
>
>>
>> Anyone can confirm this ?
>>
>> Thanks,
>> Vlad
