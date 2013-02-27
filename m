From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] md/raid456: remove depends on CONFIG_EXPERIMENTAL
Date: Tue, 26 Feb 2013 22:03:32 -0800
Message-ID: <CAGXu5jL06MLHYtPdBXG7McS=xM7E3yjXVOy0hegQSa6BbZvi9A@mail.gmail.com>
References: <20130223074001.GA5199@www.outflux.net>
	<CAA9_cmfa1hhijh4g_hSwMy_GR81rxjEFMurJwSvhBruh1R5dtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmfa1hhijh4g_hSwMy_GR81rxjEFMurJwSvhBruh1R5dtw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <djbw@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Alasdair G Kergon <agk@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-raid.ids

On Tue, Feb 26, 2013 at 5:27 PM, Dan Williams <djbw@fb.com> wrote:
> On Fri, Feb 22, 2013 at 11:40 PM, Kees Cook <keescook@chromium.org> wrote:
>> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
>> while now and is almost always enabled by default. As agreed during the
>> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> Cc: Arjan van de Ven <arjan@linux.intel.com>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Cc: Alasdair G Kergon <agk@redhat.com>
>> ---
>>  drivers/md/Kconfig |    1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
>> index 7cdf359..0cc3a3d 100644
>> --- a/drivers/md/Kconfig
>> +++ b/drivers/md/Kconfig
>> @@ -158,7 +158,6 @@ config MULTICORE_RAID456
>>         bool "RAID-4/RAID-5/RAID-6 Multicore processing (EXPERIMENTAL)"
>>         depends on MD_RAID456
>>         depends on SMP
>> -       depends on EXPERIMENTAL
>
> In this case MULTICORE_RAID456 and the related code should go as
> well... now that there are patches to supersede this implementation in
> md-next.

Hrm, well as long as EXPERIMENTAL goes away, I'm happy. :) I sent this
most recent patch series based on what was living in linux-next, so if
that's changing, that's fine.

-Kees

-- 
Kees Cook
Chrome OS Security
