From: Nikola Pajkovsky <npajkovsky@suse.cz>
Subject: Re: [PATCH 0/6] md: Fine-tuning for some function implementations
Date: Wed, 03 May 2017 09:38:02 +0200
Message-ID: <87pofq75lx.fsf@suse.cz>
References: <f05bfc4e-7935-7e87-cc85-f0d9c5e3846a@users.sourceforge.net> <87efw7q6tm.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <87efw7q6tm.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>, linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids


NeilBrown <neilb@suse.com> writes:

> On Tue, May 02 2017, SF Markus Elfring wrote:
>
>> From: Markus Elfring <elfring@users.sourceforge.net>
>> Date: Tue, 2 May 2017 16:12:34 +0200
>>
>> Some update suggestions were taken into account
>> from static source code analysis.
>>
>> Markus Elfring (6):
>>   Replace seven seq_printf() calls by seq_putc()
>>   Replace 17 seq_printf() calls by seq_puts()
>
> Why does anyone care whether printf or putc/puts is used?  Really it
> doesn't matter *at* *all*.

It could matter, but this patchset does not state it all. Does not
have any perf tests and so on.

f7a5f132b447 ("proc: faster /proc/*/status")
68ba0326b4e1 ("proc: much faster /proc/vmstat")

> I don't object to the patch but if it would up to me I probably wouldn't
> bother applying it it either.
> Sometimes I just want to "print" something and I don't want to care
> whether it is a constant string or a single-byte constant string, or
> something more general.
> I see these changes as worse than white-space fixes.
>
> NeilBrown
>
>
>>   Adjust four function calls together with a variable assignment
>>   Use seq_puts() in faulty_status()
>>   Adjust six function calls together with a variable assignment in faulty_status()
>>   Add some spaces for better code readability
>>
>>  drivers/md/faulty.c | 48 ++++++++++++++++++++++----------------
>>  drivers/md/md.c     | 66 +++++++++++++++++++++++++++++------------------------
>>  2 files changed, 64 insertions(+), 50 deletions(-)
>>
>> -- 
>> 2.12.2


-- 
Nikola
