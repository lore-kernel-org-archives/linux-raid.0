From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Linux mdadm superblock question.
Date: Mon, 15 Feb 2010 17:24:30 -0800
Message-ID: <4B79F3CE.5030907@zytor.com>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>	<4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com>	<4B77044B.1020609@zytor.com> <20100216112708.4a863f86@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100216112708.4a863f86@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Michael Evans <mjevans1983@gmail.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On 02/15/2010 04:27 PM, Neil Brown wrote:
> 
> When mdadm defaults to 1.0 for a RAID1 it prints a warning to the effect that
> the array might not be suitable to store '/boot', and requests confirmation.
> 
> So I assume that the people who are having this problem either do not read,
> or are using some partitioning tool that runs mdadm under the hood using
> "--run" to avoid the need for confirmation.  It would be nice to confirm if
> that was the case, and find out what tool is being used.

My guess is that they are using the latter.  However, some of it is
probably also a matter of not planning ahead, or not understanding the
error message.  I'll forward one email privately (don't want to forward
a private email to a list.)

> If an array is not being used for /boot (or /) then I still think that 1.1 is
> the better choice as it removes the possibility for confusion over partition
> tables.
> 
> I guess I could try defaulting to 1.2 in a partition, and 1.1 on a
> whole-device.  That might be a suitable compromise.

In some ways, 1.1 is even more toxic on a whole-device, since that means
that it is physically impossible to boot off of it -- the hardware will
only ever read the first sector (MBR).

> How do people cope with XFS??

There are three options:

a) either don't boot from it (separate /boot);
b) use a bootloader which installs in the MBR and
hopefully-unpartitioned disk areas (e.g. Grub);
c) use a nonstandard custom MBR.

Neither (b) or (c), of course, allow for chainloading from another OS
install and thus are bad for interoperability.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
