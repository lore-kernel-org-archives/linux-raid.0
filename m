From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Soft RAID and EFI systems
Date: Tue, 4 Feb 2014 08:13:23 -0700
Message-ID: <BEFF038F-20FE-4F52-A9BA-FB2F8A030997@colorremedies.com>
References: <CAC9WiBjSjBw8Y=cCd8bpwQhuy-1+swYVdHkBT7bynv6Hx8_6zA@mail.gmail.com> <70EFD3D5-F7AC-4359-8888-99EB6CCA9E4F@colorremedies.com> <52EEB9F2.2000607@gmail.com> <3D3B8F1A-F525-459D-95F2-9D7889C222CD@colorremedies.com> <52EECD53.30802@turmel.org> <52F0A79F.7090707@gmail.com> <52F0A976.9080306@hesbynett.no>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52F0A976.9080306@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Francis Moreau <francis.moro@gmail.com>, Phil Turmel <philip@turmel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Feb 4, 2014, at 1:48 AM, David Brown <david.brown@hesbynett.no> wrote:

> On 04/02/14 09:41, Francis Moreau wrote:
>> On 02/02/2014 11:57 PM, Phil Turmel wrote:
>>> On 02/02/2014 05:30 PM, Chris Murphy wrote:
>>>> 
>>>> On Feb 2, 2014, at 2:34 PM, Francis Moreau <francis.moro@gmail.com>
>>>> wrote:
>>>>> 
>>>>> That's funny because one of the reasons I want to use UEFI firmware
>>>>> is to get rid of grub (I don't like it and the way it has become
>>>>> such a bloated beast): since /boot is vfat and has its own
>>>>> partition, I prefer use a much simpler bootloader such as
>>>>> gummyboot.
>>> 
>>> Ditching the bootloader is possible:
>>> 
>>> http://kroah.com/log/blog/2013/09/02/booting-a-self-signed-linux-kernel/
>>> 
>> 
>> Well yeah it's possible but not currently usable IMHO. It means that you
>> need to build your own kernel, include in this kernel the initramfs
>> image and you need to redo the whole process if you want to change a
>> single option in the kernel command line.
>> 
>>> It seems to me that you should be able to create a raid1 v1.0 MD array
>>> of your EFI support partitions, and put the combined and signed
>>> kernel/initramfs onto it (mirrored to all member drives).
>> 
>> Are both v0.9 and v1.0 MD  put their metadata at the end of a partition
>> ? I thought only v0.9 would do that.
> 
> Yes, it is only 0.9 format that is at the end of the partition.

Both 0.90 and 1.00 are at the end of the partition.

On a 550MiB disk with the last offset 0x225f0000, I get the start of metadata:

0.90
225f0000

1.00
225fe000

In both cases the resulting md device sizes are identical. So if anything 1.00 is very slightly farther back than 0.90, and is a newer metadata version. The Fedora installer use metadata 1.00 along with internal bitmap when creating bootable raid1 arrays.

This mdadm warning "possible for there to be confusion about whether the superblock applies to a whole device or just the last partition" would only apply if you attempt to make whole physical drives md member devices, which then runs into GPT problems. For one the 1.00 metadata would actually reside within the last 34 sectors of the physical device which is where the backup GPT belongs. Even if you use metadata 0.90 to avoid that, you now have a primary and backup GPT that agree when there is no raid1 active, but then the primary and backup GPT disagree when it is active. So you can't have it both ways with GPT formatted disks on UEFI: both ways meaning a disk that appears valid whether md is active or not.


Chris Murphy

