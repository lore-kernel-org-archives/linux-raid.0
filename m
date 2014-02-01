From: Martin Wilck <mwilck@arcor.de>
Subject: Re: Soft RAID and EFI systems
Date: Sat, 01 Feb 2014 23:04:27 +0100
Message-ID: <52ED6F6B.1040108@arcor.de>
References: <CAC9WiBjSjBw8Y=cCd8bpwQhuy-1+swYVdHkBT7bynv6Hx8_6zA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBjSjBw8Y=cCd8bpwQhuy-1+swYVdHkBT7bynv6Hx8_6zA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Francis,

> For Fake RAID, I'm not sure but I would say that the bios is able to
> read the RAID metadata as well.
> For (md) Soft RAID, I don't know. I would say that the bios is
> unlikely to understand the md metadata stored in the /boot partition
> so it won't work.

there is no big difference between EFI and legacy systems in this area.
Native MD meta data isn't understood by any BIOS I've heard of.
(Well I guess you actually could try to port mdadm to the UEFI
environment and use it for booting - under UEFI it is possible to run
your own applications, in principle at least, unlike legacy BIOS).

DDF or IMSM meta data can be read and written by BIOS fake RAID under
uEFI just as well as in legacy mode. You just need to make sure that
your system vendor delivers a BIOS with all the required uEFI tools.

> If so does that mean I can't mirror /boot partition on EFI systems ?
> Maybe creating a RAID device using the whole disk (not the partition
> device) would work ?

Mirroring he whole disk is the only thing the BIOS can possibly do.
But chances are bad that it will work with MD metadata, see above.

Martin


