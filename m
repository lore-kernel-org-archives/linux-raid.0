From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] md/raid1: fix writebehind bio clone
Date: Wed, 19 Jul 2017 10:13:05 +0800
Message-ID: <CACVXFVN3DA_JFfsgRXJFvqqkVOz4sj3U98a6eKpe5cB3YJprDw@mail.gmail.com>
References: <90e5fed8cd2b5dff7b393de121460671ebdd1260.1500398441.git.shli@fb.com>
 <CACVXFVNkTKhGqooGNww1iqSpw1dBCsDTJ6E1QX8a_P=CACG_1A@mail.gmail.com> <20170718230437.xdlmxjzedhm4jilf@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170718230437.xdlmxjzedhm4jilf@kernel.org>
Sender: stable-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, "4.12+" <stable@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jul 19, 2017 at 7:04 AM, Shaohua Li <shli@kernel.org> wrote:
> On Wed, Jul 19, 2017 at 06:51:06AM +0800, Ming Lei wrote:
>> On Wed, Jul 19, 2017 at 1:21 AM, Shaohua Li <shli@kernel.org> wrote:
>> > From: Shaohua Li <shli@fb.com>
>> >
>> > After bio is submitted, we should not clone it as its bi_iter might be
>> > invalid by driver. This is the case of behind_master_bio. In certain
>> > situration, we could dispatch behind_master_bio immediately for the
>> > first disk and then clone it for other disks.
>>
>> If I understand it correctly, it should be caused by dispatching
>> the master bio during the loop either via flushing plug or md_wakeup_thread().
>>
>> If so, could we just add the bios into one temp pending list inside
>> the loop? Then
>> merge the temp list into conf->pending_bio_list after loop and
>> schedule to dispatch
>> them all? This way looks a bit more efficient.
>
> that's possible, but narrow_write_error will clone it after we already dispatch
> the bio, so I thought it's more clean to just clone one bio.

OK, looks fine:

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks,
Ming Lei
