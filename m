From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: mismatch_cnt again
Date: Sun, 08 Nov 2009 09:25:37 +1100
Message-ID: <4AF5F3E1.4060509@eyal.emu.id.au>
References: <4AF4C247.6050303@eyal.emu.id.au> <4AF4D323.6020108@panix.com>	<4AF5268D.60900@eyal.emu.id.au>	<4877c76c0911070008m789507f8h799d419287740ca5@mail.gmail.com> <87tyx6tpcb.fsf@frosties.localdomain> <4AF58B20.3000409@redhat.com> <4AF59F19.1080409@lazy.lzy> <4AF5A245.90404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF5A245.90404@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Doug,

I can only see the cron job start a check:
	echo "check" > /sys/block/$dev/md/sync_action
It does not wait for completion and does not report the count. Neither is
the count reported to the system log.

I replaced it with a script that does report.

Eyal

Doug Ledford wrote:
> On 11/07/2009 11:23 AM, Piergiorgio Sartor wrote:
>> Side note: in F11 there is this cron.weekly raid-check, but
>> nothing is reported (per email to root) in case of mismatch.
>> Is there any plan to add a such a facility?
> 
> Unless you've modified the default cron behaviour, then yes something is
> reported to the user on a mismatch.  The fact that the script goes from
> being silent to echoing a warning will result in the cron job itself
> emailing root the output of the script.

-- 
Eyal Lebedinsky	(eyal@eyal.emu.id.au)
