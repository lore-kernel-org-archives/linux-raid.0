From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: mismatch_cnt again
Date: Sat, 07 Nov 2009 14:51:48 +0100
Message-ID: <87tyx6tpcb.fsf@frosties.localdomain>
References: <4AF4C247.6050303@eyal.emu.id.au> <4AF4D323.6020108@panix.com>
	<4AF5268D.60900@eyal.emu.id.au>
	<4877c76c0911070008m789507f8h799d419287740ca5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0911070008m789507f8h799d419287740ca5@mail.gmail.com>
	(Michael Evans's message of "Sat, 7 Nov 2009 00:08:55 -0800")
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Michael Evans <mjevans1983@gmail.com> writes:

> Your dmesg and/or the syslog stream of the same kernel warnings/info
> should show you when and where these errors occurred.

I believe mismatch count doesn't show up in the kernel. The mismatch
count shows where data can be read clearly from the disks but the
computed parity does not match the read parity (or the mirrors
disagree). If the drive reports an actual error then the block is
recomputed and not left as mismatch.

So this would be caused by a bit flipping in ram (cpu, controler or
disk) before being written to the platter, flipping in the cable or
flipping on the platter. Or software.

I currently only have mismatches on raid1. In both cases on a device
containing swap on lvm, which I think is the culprit. Lucky me.

MfG
        Goswin
