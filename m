From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: md homehost
Date: Tue, 23 Feb 2010 08:31:16 +0100
Message-ID: <87635opfwb.fsf@frosties.localdomain>
References: <20100218044004.GC5136@lapse.rw.madduck.net>
	<20100218161012.704b43a6@notabene.brown>
	<20100218052145.GA7178@lapse.rw.madduck.net>
	<20100218163448.0d3f3107@notabene.brown>
	<20100219004237.GC25162@lapse.rw.madduck.net>
	<20100219091619.GA2964@lazy.lzy>
	<20100221174007.GB19058@lapse.rw.madduck.net>
	<20100221201304.GB2570@lazy.lzy>
	<20100222091632.GE2641@lapse.rw.madduck.net>
	<20100223133028.279e0174@notabene.brown>
	<20100223062700.GB19666@lapse.rw.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100223062700.GB19666@lapse.rw.madduck.net> (martin f. krafft's
	message of "Tue, 23 Feb 2010 07:27:00 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, 567468@bugs.debian.org, Daniel Reurich <daniel@centurion.net.nz>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

martin f krafft <madduck@madduck.net> writes:

> also sprach Neil Brown <neilb@suse.de> [2010.02.23.0330 +0100]:
>> The problem to protect against is any consequence of rearranging
>> devices while the host is off, including attaching devices that
>> previously were attached to a different computer.
>
> How often does this happen, and how grave/dangerous are the effects?
>
>> But if '/' is mounted by a name in /dev/md/, I want to be sure
>> mdadm puts the correct array at that name no matter what other
>> arrays might be visible.
>
> Of course it would be nice if this happened, but wouldn't it be
> acceptable to assume that if someone swaps drives between machines
> that they ought to know how to deal with the consequences, or at
> least be ready to tae additional steps to make sure the system still
> boots as desired?
>
> Even if the wrong array appeared as /dev/md0 and was mounted as root
> device, is there any actual problem, other than inconvenience?
> Remember that the person who has previously swapped the drives is
> physically in front of (or behind ;)) the machine.
>
> I am unconvinced. I think we should definitely switch to using
> filesystem-UUIDs over device names, and that is the only real
> solution to the problem, no?

Both filesystems and LVM have UUIDs. Does dm-crypt / LUKS have one too?

MfG
        Goswin


