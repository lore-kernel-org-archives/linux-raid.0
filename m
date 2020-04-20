From: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>
Subject: Re: Setup Recommendation on UEFI/GRUB/RAID1/LVM
Date: Mon, 20 Apr 2020 14:01:13 +0200
Message-ID: <d9d23909-5b5d-6778-fcab-bb9e6dab33aa@peter-speer.de>
References: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
 <5E95C698.1030307@youngman.org.uk>
 <13a3bc12-67f7-46d5-7e6a-c6880ace4b1c@peter-speer.de>
 <5E95F461.50209@youngman.org.uk> <87lfmtemqf.fsf@esperi.org.uk>
 <f3139daa-37d5-a965-d204-0ef5d9fe4f3f@peter-speer.de>
 <87eesito1v.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87eesito1v.fsf@esperi.org.uk>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 20.04.20 13:05, Nix wrote:
>> Is there any reason why one could not have another entry for each disk (8 entries in this example in total instead of the 4 being
>> listed) like:
>>
>> Boot000B* Current kernel HD(1,GPT,b6697409-a6ec-470d-994c-0d4828d08861,0x800,0x200000)/File(\efi\nix\old.efi)
>>
>> and so on to support booting the old kernel in case something went wrong?

> None! I have one entry each for old/stable kernel on the current disk,
> but it just gets quite verbose and repetitive with six disks, and the
> two (other disks, old kernels) serve different purposes: I'm going to
> want to boot off another disk if the kernel works but something went
> wrong with the disk, and I'm going to want to boot an old kernel if the
> kernel has gone wrong, in which case probably the disk is fine and I can
> just boot off the current disk. If I find when booting a new kernel that
> it breaks the disk and I have to boot an old kernel off another disk,
> I'll just use the EFI shell to do it. :)

I guess I got the idea. Need to dive deeper using EFI shell, but this 
sounds like a smart solution even there is no grub, managing the 
kernels, thanks.
