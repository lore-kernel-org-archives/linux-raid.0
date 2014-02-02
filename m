From: Phil Turmel <philip@turmel.org>
Subject: Re: Soft RAID and EFI systems
Date: Sun, 02 Feb 2014 17:57:23 -0500
Message-ID: <52EECD53.30802@turmel.org>
References: <CAC9WiBjSjBw8Y=cCd8bpwQhuy-1+swYVdHkBT7bynv6Hx8_6zA@mail.gmail.com> <70EFD3D5-F7AC-4359-8888-99EB6CCA9E4F@colorremedies.com> <52EEB9F2.2000607@gmail.com> <3D3B8F1A-F525-459D-95F2-9D7889C222CD@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3D3B8F1A-F525-459D-95F2-9D7889C222CD@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>, Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/02/2014 05:30 PM, Chris Murphy wrote:
> 
> On Feb 2, 2014, at 2:34 PM, Francis Moreau <francis.moro@gmail.com>
> wrote:
>> 
>> That's funny because one of the reasons I want to use UEFI firmware
>> is to get rid of grub (I don't like it and the way it has become
>> such a bloated beast): since /boot is vfat and has its own
>> partition, I prefer use a much simpler bootloader such as
>> gummyboot.

Ditching the bootloader is possible:

http://kroah.com/log/blog/2013/09/02/booting-a-self-signed-linux-kernel/

It seems to me that you should be able to create a raid1 v1.0 MD array
of your EFI support partitions, and put the combined and signed
kernel/initramfs onto it (mirrored to all member drives).

Then set the UEFI bios to try each device's ESP in turn.

Untested ... :-)

Phil
