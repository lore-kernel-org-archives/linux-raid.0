From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: interesting case of a hung 'recovery'
Date: Thu, 23 Feb 2017 17:17:06 +1100
Message-ID: <52ea7f37-5368-3b9d-5348-75861cc56652@eyal.emu.id.au>
References: <091a6513-1594-4a33-691a-cd1f7920d4a0@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <091a6513-1594-4a33-691a-cd1f7920d4a0@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Can one of the experts on the list please comment on the issue.

Regards,
	Eyal

On 18/02/17 23:14, Eyal Lebedinsky wrote:
> I should start by saying that this is an old fedora 19 system
>
> Executive summary: after '--add'ing a new member a 'recovery' starts but 'sync_max' is not reset.
>
> $ uname -a
> Linux e7.eyal.emu.id.au 3.14.27-100.fc19.x86_64 #1 SMP Wed Dec 17 19:36:34 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

$ sudo mdadm --version
mdadm - v4.0 - 2017-01-09

> so the issue may have been fixed since.
>
> I had a disk fail in a raid6. After some 'pending' sectors were logged I decided to do a 'check'
> around that location (set sync_min/max and echo 'check'). Sure enough it elicited disk errors,
> but the disk did not recover and it was kicked out of the array. Moreover it became unresponsive.
> It needed a power cycle so I shutdown and rebooted the machine.
>
> Not one to give up easily I tried the check again, with the same result.
> It was time to '--remove' this array member. I then '--add'ed a new disk which started a recovery.
>
> A few hours later I noticed that it slowed down. A lot. It actually did not progress at all for
> a few hours (I was away from the machine).
>
> As I was staring at the screen (for a long while) I realised that it stopped at 55.5%, and this
> number is exactly where the original 'check' failed (I still do not understand why with my bad
> memory I remembered this number).
>
> I checked 'sync_completed' and it was proper.
> I then examined 'sync_max' and it was wrong - it had the location where the very early 'check'
> failed earlier in the day. It was the same sector where it is now paused at - looks related.
>
> I decided to take a (small) risk and do
>     # echo 'max' >/sys/block/md127/md/sync_max
> at which point the recovery moved on. It should be finished in about 5 hours.
>
> I do not think that it is correct for 'sync_max' to not be set to 'max' when a new member is
> added - it surely requires a full recovery.
>
> I really hope (and expect) that this was actually fixed, but this note may help others facing
> same predicament.
>
> cheers
>

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
