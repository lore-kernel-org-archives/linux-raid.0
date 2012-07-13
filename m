From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: [PATCH V1] raidd5:Only move IO_THRESHOLD stripes from delay_list
 to hold_list once.
Date: Fri, 13 Jul 2012 16:56:18 -0700
Message-ID: <CAA9_cmcLEYeu9VaVTgVW=CX+JvTyA_ubAmrAkpQdxGmRkGj_3A@mail.gmail.com>
References: <201207131831085787372@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201207131831085787372@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: Neil Brown <neilb@suse.de>, Paul Menzel <paulepanter@users.sourceforge.net>, linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

[ adding Shaohua ]

On Fri, Jul 13, 2012 at 3:31 AM, majianpeng <majianpeng@gmail.com> wrote:
> To improve write perfomance by decreasing the preread stripe,only move
> IO_THRESHOLD stripes from delay_list to hold_list once.
>
> Using the follow command:
> dd if=/dev/zero of=/dev/md0 bs=2M count=52100.
>
> At default condition: speed is 95MB/s.
> At the condition of preread_bypass_threshold was equal zero:speed is 105MB/s.
> Using this patch:speed is 123MB/s.
>
> If preread_bypass_threshold was zero,the performance will be better,but
> not better than this patch.
> I think maybe two reason:
> 1:If bio is REQ_SYNC
> 2:In function __get_priority_stripe():
>>> } else if (!list_empty(&conf->hold_list) &&
>>>                 ((conf->bypass_threshold &&
>>>                   conf->bypass_count > conf->bypass_threshold) ||
>>>                  atomic_read(&conf->pending_full_writes) == 0)) {
> Preread_bypass_threshold is one condition of getting stripe from
> hold_list.So only control the number of hold_list can get better
> performance.

So this is a pretty obvious tradeoff of increased latency for improved
throughput.  Any idea how much this change affects latency?
Especially in the fast device case?
