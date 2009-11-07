From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: mismatch_cnt again
Date: Sat, 07 Nov 2009 17:23:53 +0100
Message-ID: <4AF59F19.1080409@lazy.lzy>
References: <4AF4C247.6050303@eyal.emu.id.au> <4AF4D323.6020108@panix.com>	<4AF5268D.60900@eyal.emu.id.au>	<4877c76c0911070008m789507f8h799d419287740ca5@mail.gmail.com> <87tyx6tpcb.fsf@frosties.localdomain> <4AF58B20.3000409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF58B20.3000409@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Michael Evans <mjevans1983@gmail.com>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/07/2009 03:58 PM, Doug Ledford wrote:
[...]
> I'm very quickly starting to become dubious of the current mismatch_cnt
> implementation.  I think a kernel patch is in order and I may just work
> on that today.  Here's the deal: a non-0 mismatch count is worthless if
> you don't also tell people *where* the mismatch is so they can
> investigate it and correct it.

You're perfectly right.

And this, again, fits in the discussion of RAID-6 error
check and, potentially, repair.

Ideally the log should tell which (RAID) address has a
mismatch and, in case of RAID-6, if a specific device
could be faulty at that position.

This would be already quite a huge step forward in improving
the overall reliability of the RAID sub-system.

Side note: in F11 there is this cron.weekly raid-check, but
nothing is reported (per email to root) in case of mismatch.
Is there any plan to add a such a facility?

Thanks.

bye,

-- 

piergiorgio
