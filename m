From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Bug#567468: md homehost
Date: Wed, 24 Feb 2010 14:13:53 +0100
Message-ID: <87y6iilqsu.fsf@frosties.localdomain>
References: <20100218052145.GA7178@lapse.rw.madduck.net>
	<20100218163448.0d3f3107@notabene.brown>
	<20100219004237.GC25162@lapse.rw.madduck.net>
	<20100219091619.GA2964@lazy.lzy>
	<20100221174007.GB19058@lapse.rw.madduck.net>
	<20100221201304.GB2570@lazy.lzy>
	<20100222091632.GE2641@lapse.rw.madduck.net>
	<20100223133028.279e0174@notabene.brown>
	<20100223062700.GB19666@lapse.rw.madduck.net>
	<87635opfwb.fsf@frosties.localdomain>
	<20100223081636.GD19730@lapse.rw.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100223081636.GD19730@lapse.rw.madduck.net> (martin f. krafft's
	message of "Tue, 23 Feb 2010 09:16:37 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: 567468@bugs.debian.org, Neil Brown <neilb@suse.de>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Daniel Reurich <daniel@centurion.net.nz>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

martin f krafft <madduck@debian.org> writes:

> also sprach Goswin von Brederlow <goswin-v-b@web.de> [2010.02.23.0831 +0100]:
>> Both filesystems and LVM have UUIDs. Does dm-crypt / LUKS have one
>> too?
>
> LVM already identifies PVs using UUIDs, so if you are using
> anything-on-LVM-on-md, you need not worry about device names anyway.
>
> dm-crypt currently needs to be told explicitly to use a base device
> using /dev/disk/by-uuid if you want it to be flexible.
>
> The only issue homehost protects against, I think, is machines that
> use /dev/md0 directly from grub.conf or fstab.

grub.cfg (grub2) uses UUID for grub itself. But the kernel can be bootet
with root=/dev/md0. But in that case where does it get the homehost from
and since when does kernel raid autoconfig have a homehost?

Any other case you have an initramfs that can use LABEL or UUID. Same
for fstab.

MfG
        Goswin
