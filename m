From: mostafa kishani <mostafa.kishani@gmail.com>
Subject: Re: Implementing Global Parity Codes
Date: Sat, 3 Feb 2018 09:31:34 +0330
Message-ID: <CACm9mdUtHRc9x42UQR_jTMDAgNv+KruAQHRM7Xzq=e1XQhbKhQ@mail.gmail.com>
References: <CACm9mdUJLczo8zSB5UfU9Fd_6VK3+sGCYJYdaEaX0qW1cMLtYA@mail.gmail.com>
 <87d11o2ccd.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d11o2ccd.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Neil,

Sincere thanks for the useful information. I really appreciate your help.

Bests,
Mostafa

On Fri, Feb 2, 2018 at 8:54 AM, NeilBrown <neilb@suse.com> wrote:
> On Sat, Jan 27 2018, mostafa kishani wrote:
>
>> Dear All,
>>
>> I am going to make some modifications to RAID protocol to make it more
>> reliable for my case (for a scientific, and maybe later, industrial
>> purpose). For example, I'm going to hold a Global Parity (a parity
>> taken across the whole data stripe rather than a row) alongside normal
>> row-wise parities, to cope with an extra sector/page failure per
>> stripe. Do you have any suggestion how can I implement this with a
>> moderate effort (I mean what functions should be modified)? have any
>> of you had any similar effort?
>
> In raid5.c the is a "struct stripe_head" which represents a stripe that
> is one-page (normally 4K) wide across all devices.  All the data for any
> parity calculation can all be found in a 'stripe_head'.
> You would probably need to modify the stripe_head to represent several
> more blocks so that all the Data and Parity for any computation are
> always attached to the one stripe_head.
>
>> I also appreciate if you guide me how can I enable DEBUG mode in mdadm.
>
> I assume you mean debug mode on "md".
> mdadm is the management tool.
> md is the kernel driver.
>
> mdadm doesn't have a debug mode.
>
> md has a number of pr_debug() calls which can each be turned on or off
> independently using dynamic debugging
>
> https://www.kernel.org/doc/html/v4.15/admin-guide/dynamic-debug-howto.html
>
> To turn on all pr_debug commands in raid5.c use
>
>    echo file raid5.c +p > /sys/kernel/debug/dynamic_debug/control
>
> to turn them off again:
>
>    echo file raid5.c -p > /sys/kernel/debug/dynamic_debug/control
>
> NeilBrown
>
>>
>> Bests,
>> Mostafa
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
