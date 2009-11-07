From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Raid Degradation best practices
Date: Sat, 07 Nov 2009 16:02:12 +0100
Message-ID: <874op6pedn.fsf@frosties.localdomain>
References: <4AF41AFB.3000302@gmail.com>
	<alpine.DEB.2.00.0911070650380.4559@p34.internal.lan>
	<4AF57257.7010207@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF57257.7010207@gmail.com> (Andrew Dunn's message of "Sat, 07
	Nov 2009 08:12:55 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Dunn <andrew.g.dunn@gmail.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, nfbrown@novell.com
List-Id: linux-raid.ids

Andrew Dunn <andrew.g.dunn@gmail.com> writes:

> I am using RAID6, on 9 WD1001FALS drives.
>
> The VERY important data is backed up to multiple external drives and
> stored at a separate location.
>
> I figured out my issue last night. I had an issue with the array where
> it was doing the silly /dev/md_d0 thing, so when I stopped that and
> started the new one I did '--assume-clean' then when I started copying
> my information back to the array multiple devices dropped out. Their
> SMART information passes just fine, so it must have been the array was
> not clean.

--assume-clean just skips the resync. If the array is actualy not
clean you just get an increased mismatch_cnt when you run a check and
bad data when a disk fails. It never causes a disk to drop out.

> This was my mistake, but in the future when I have a real drive failure
> I was curious to see how you approach that issue.

Having bitmaps helps since when a disk temporarily drops out and you
ad it back you only need to resync the bits that have changed. But
that only reduces the window where another (or a third for raid6) disk
failure is critical. If you get 3 failed disk, temporary or not, at
the same time then your raid6 breaks and you need to put the pices
back together yourself. Depending on each components state you might
have data loss or corruption.

The best thing to do is to make sure your hardware is fit and does not
just drop out for a minute.

MfG
        Goswin
