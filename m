From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: "Enhanced" MD code avaible for review
Date: Wed, 17 Mar 2004 21:00:02 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <405902A2.8060801@pobox.com>
References: <1AOTW-4Vx-7@gated-at.bofh.it> <1AOTW-4Vx-5@gated-at.bofh.it> <m3wu5jey76.fsf@averell.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <m3wu5jey76.fsf@averell.firstfloor.org>
To: Andi Kleen <ak@muc.de>
Cc: linux-raid@vger.kernel.org, justin_gibbs@adaptec.com, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Andi Kleen wrote:
> Sorry, Jeff, but that's just not true. While ioctls need an additional
> entry in the conversion table, they can at least easily get an
> translation handler if needed. When they are correctly designed you
> just need a single line to enable pass through the emulation.
> If you don't want to add that line to the generic compat_ioctl.h
> file you can also do it in your driver.
> 
> read/write has the big disadvantage that if someone gets the emulation
> wrong (and that happens regularly) it is near impossible to add an 
> emulation handler then, because there is no good way to hook
> into the read/write paths.
> 
> There may be valid reasons to go for read/write, but 32bit emulation
> is not one of them. In fact from the emulation perspective read/write
> should be avoided.

I'll probably have to illustrate with code, but basically, read/write 
can be completely ignorant of 32/64-bit architecture, endianness, it can 
even be network-transparent.  ioctls just can't do that.

	Jeff



