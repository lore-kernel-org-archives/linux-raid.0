From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Booting from RAID1
Date: Mon, 21 Dec 2009 14:15:18 +0100
Message-ID: <878wcwo4d5.fsf@frosties.localdomain>
References: <E7.83.01470.A77BD2B4@cdptpa-omtalb.mail.rr.com>
	<4877c76c0912192243x5d7281begc9a94242d476a20f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0912192243x5d7281begc9a94242d476a20f@mail.gmail.com>
	(Michael Evans's message of "Sat, 19 Dec 2009 22:43:45 -0800")
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Leslie Rhorer <lrhorer@satx.rr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Evans <mjevans1983@gmail.com> writes:

> Advice point 2; which my howto should mention: For boot devices you'll
> probably want to use the 1.0 mdadm label format (not 1.1 or 1.2, which
> are the same but change where the label is stored) for just the boot
> raid 1.0 only.  It will also mention some things you should be extra
> careful about...
>
> Like mounting the bare devices in that raid set by mistake.
>
> Oh, and you'll also very likely want grub to read the /boot
> filesystem, which is why it must be on a partition followed by the
> raid header, instead of a partition containing a raid header and raid
> protected partition.  That use is OK since grub operates read-only.

How far is the support for all superblock formats in grub2?

MfG
        Goswin
