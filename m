From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] md/raid456: remove depends on CONFIG_EXPERIMENTAL
Date: Mon, 4 Mar 2013 13:13:31 -0800
Message-ID: <CAGXu5jLweh+0=fYfDFVM9MhvBCww82U89evsmK2EO6t8Zp42Dg@mail.gmail.com>
References: <20130223074001.GA5199@www.outflux.net>
	<CAA9_cmfa1hhijh4g_hSwMy_GR81rxjEFMurJwSvhBruh1R5dtw@mail.gmail.com>
	<CAGXu5jKpdVFoEvbGv3K620XDx2bjqQYeCLE511h-071XaPQUGg@mail.gmail.com>
	<20130305081102.73211ef9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130305081102.73211ef9@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Dan Williams <djbw@fb.com>, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>, Alasdair G Kergon <agk@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-raid.ids

On Mon, Mar 4, 2013 at 1:11 PM, NeilBrown <neilb@suse.de> wrote:
> On Mon, 4 Mar 2013 10:59:30 -0800 Kees Cook <keescook@chromium.org> wrote:
>
>> On Tue, Feb 26, 2013 at 5:27 PM, Dan Williams <djbw@fb.com> wrote:
>> > On Fri, Feb 22, 2013 at 11:40 PM, Kees Cook <keescook@chromium.org> wrote:
>> >> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
>> >> while now and is almost always enabled by default. As agreed during the
>> >> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
>> >>
>> >> Signed-off-by: Kees Cook <keescook@chromium.org>
>> >> Cc: Arjan van de Ven <arjan@linux.intel.com>
>> >> Cc: Dan Williams <dan.j.williams@intel.com>
>> >> Cc: Alasdair G Kergon <agk@redhat.com>
>> >> ---
>> >>  drivers/md/Kconfig |    1 -
>> >>  1 file changed, 1 deletion(-)
>> >>
>> >> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
>> >> index 7cdf359..0cc3a3d 100644
>> >> --- a/drivers/md/Kconfig
>> >> +++ b/drivers/md/Kconfig
>> >> @@ -158,7 +158,6 @@ config MULTICORE_RAID456
>> >>         bool "RAID-4/RAID-5/RAID-6 Multicore processing (EXPERIMENTAL)"
>> >>         depends on MD_RAID456
>> >>         depends on SMP
>> >> -       depends on EXPERIMENTAL
>> >
>> > In this case MULTICORE_RAID456 and the related code should go as
>> > well... now that there are patches to supersede this implementation in
>> > md-next.
>>
>> Can my original patch go through as-is for Linus's tree? Right now,
>> this is the last use of EXPERIMENTAL in v3.9-rc1. If we can drop it,
>> we can remove the config item entirely from v3.9.
>
> My pull request which removes CONFIG_MULTICORE_RAID456 completely was a little
> late and missed -rc1.  Hopefully it will appear soon.
> But if it isn't gone by -rc2, I have no objection to your patch going in then.

Ah-ha! Okay, it sounded like the other stuff was scheduled for 3.10.
If it's going into 3.9, then I'll just wait for -rc2 before pushing
the final removal patch.

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
