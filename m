From: Andi Kleen <ak@muc.de>
Subject: Re: "Enhanced" MD code avaible for review
Date: Thu, 18 Mar 2004 02:33:17 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <m3wu5jey76.fsf@averell.firstfloor.org>
References: <1AOTW-4Vx-7@gated-at.bofh.it> <1AOTW-4Vx-5@gated-at.bofh.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1AOTW-4Vx-5@gated-at.bofh.it> (Jeff Garzik's message of "Wed,
 17 Mar 2004 20:30:12 +0100")
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-raid@vger.kernel.org, justin_gibbs@adaptec.com, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Jeff Garzik <jgarzik@pobox.com> writes:
>
> ioctl's are a pain for 32->64-bit translation layers.  Using a
> read/write interface allows one to create an interface that requires
> no translation layer -- a big deal for AMD64 and IA32e processors
> moving forward -- and it also gives one a lot more control over the
> interface.

Sorry, Jeff, but that's just not true. While ioctls need an additional
entry in the conversion table, they can at least easily get an
translation handler if needed. When they are correctly designed you
just need a single line to enable pass through the emulation.
If you don't want to add that line to the generic compat_ioctl.h
file you can also do it in your driver.

read/write has the big disadvantage that if someone gets the emulation
wrong (and that happens regularly) it is near impossible to add an 
emulation handler then, because there is no good way to hook
into the read/write paths.

There may be valid reasons to go for read/write, but 32bit emulation
is not one of them. In fact from the emulation perspective read/write
should be avoided.

-Andi

