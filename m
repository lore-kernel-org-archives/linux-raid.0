From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: Soft RAID and EFI systems
Date: Tue, 04 Feb 2014 09:53:09 +0100
Message-ID: <52F0AA75.2030006@gmail.com>
References: <CAC9WiBjSjBw8Y=cCd8bpwQhuy-1+swYVdHkBT7bynv6Hx8_6zA@mail.gmail.com> <70EFD3D5-F7AC-4359-8888-99EB6CCA9E4F@colorremedies.com> <52EEB9F2.2000607@gmail.com> <3D3B8F1A-F525-459D-95F2-9D7889C222CD@colorremedies.com> <52EECD53.30802@turmel.org> <52F0A79F.7090707@gmail.com> <52F0A976.9080306@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52F0A976.9080306@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>, Phil Turmel <philip@turmel.org>, Chris Murphy <lists@colorremedies.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/04/2014 09:48 AM, David Brown wrote:
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
> Yes, it is only 0.9 format that is at the end of the partition.  This
> means that a plain raid1 mirror (with as many disks as you like, as long
> as they are simple mirrors and not raid10) looks just like a normal
> partition for other tools.  As long as it is read-only, tools that are
> not raid-aware can use it.  For example, grub and lilo can happily boot
> from a 0.9 metadata raid1 array just like from a normal partition.
> (Actually, modern grub understands a lot of md raid formats.)  The same
> thing should apply to EFI, as long as it does not attempt to write to
> the partition.
> 

hmm I need to check if EFI specifies that the ESP is never written by
the firmware. If not it might be risky to rely on it.

