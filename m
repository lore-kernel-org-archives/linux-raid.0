From: Martin Wilck <mwilck@arcor.de>
Subject: Re: Soft RAID and EFI systems
Date: Sun, 02 Feb 2014 22:56:29 +0100
Message-ID: <4499b1ec-87b5-4808-a796-3ec61853ed0d@email.android.com>
References: <CAC9WiBjSjBw8Y=cCd8bpwQhuy-1+swYVdHkBT7bynv6Hx8_6zA@mail.gmail.com> <52ED6F6B.1040108@arcor.de> <52EEBB13.5040803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52EEBB13.5040803@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2. Februar 2014 22:39:31 MEZ, Francis Moreau <francis.moro@gmail.com> wrote:
>Hi Martin,
>
>On 02/01/2014 11:04 PM, Martin Wilck wrote:
>> Hi Francis,
>> 
>>> For Fake RAID, I'm not sure but I would say that the bios is able to
>>> read the RAID metadata as well.
>>> For (md) Soft RAID, I don't know. I would say that the bios is
>>> unlikely to understand the md metadata stored in the /boot partition
>>> so it won't work.
>> 
>> there is no big difference between EFI and legacy systems in this
>area.
>
>Well  the main difference I can see is that EFI firmwares access a
>filesystem where as BIOS doesn't in order to load  the bootloader.

The EFI BIOS needs a driver to access the RAID array. But so does the legacy BIOS for accessing the MBR.

If you really want to do RAID on partitions, you can put your md-capable EFI boot loader on the EFI system partition. It will work just like in the legacy case. The UEFI partition itself  is of course non-uRAID in this setup, but the same holds for your legacy MBR.

Martin

>
>In the case of BIOS you can still rely on a bootloader such as grub to
>access a partition with MD RAID on it.
>
>Thanks


-- 

