From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: Soft RAID and EFI systems
Date: Sun, 02 Feb 2014 22:39:31 +0100
Message-ID: <52EEBB13.5040803@gmail.com>
References: <CAC9WiBjSjBw8Y=cCd8bpwQhuy-1+swYVdHkBT7bynv6Hx8_6zA@mail.gmail.com> <52ED6F6B.1040108@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52ED6F6B.1040108@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Martin,

On 02/01/2014 11:04 PM, Martin Wilck wrote:
> Hi Francis,
> 
>> For Fake RAID, I'm not sure but I would say that the bios is able to
>> read the RAID metadata as well.
>> For (md) Soft RAID, I don't know. I would say that the bios is
>> unlikely to understand the md metadata stored in the /boot partition
>> so it won't work.
> 
> there is no big difference between EFI and legacy systems in this area.

Well  the main difference I can see is that EFI firmwares access a
filesystem where as BIOS doesn't in order to load  the bootloader.

In the case of BIOS you can still rely on a bootloader such as grub to
access a partition with MD RAID on it.

Thanks

