From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: RAID 1 and grub
Date: Sun, 03 Feb 2008 16:26:23 +0100
Message-ID: <47A5DD1F.4010306@rabbit.us>
References: <47A0F4DC.9030005@sauce.co.nz> <72dbd3150801301641n2801846cgc2f3bc04aa842baf@mail.gmail.com> <47A13379.50703@sauce.co.nz> <47A5E04E.4050403@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A5E04E.4050403@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Richard Scobie <richard@sauce.co.nz>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Bill Davidsen wrote:
> Richard Scobie wrote:
>> A followup for the archives:
>>
>> I found this document very useful:
>>
>> http://lists.us.dell.com/pipermail/linux-poweredge/2003-July/008898.html
>>
>> After modifying my grub.conf to refer to (hd0,0), reinstalling grub on 
>> hdc with:
>>
>> grub> device (hd0) /dev/hdc
>>
>> grub> root (hd0,0)
>>
>> grub> (hd0)
>>
>> and rebooting with the bios set to boot off hdc, everything burst back 
>> into life.
>>
>> I shall now be checking all my Fedora/Centos RAID1 installs for grub 
>> installed on both drives.
> 
> Have you actually tested this by removing the first hd and booting? 
> Depending on the BIOS I believe that the fallback drive will be called 
> hdc by the BIOS but will be hdd in the system. That was with RHEL3, but 
> worth testing.
> 

The line:

grub> device (hd0) /dev/hdc

simply means "treat /dev/hdc as the first _bios_ hard disk in the system". 
This way when grub writes to the MBR of hd0, it will be in fact writing to 
/dev/hdc. The reason the drive must be referenced as hd0 (and not hd2) is 
because grub enuerates drives according to the bios, and therefore the drive 
from which the bios is currently booting is _always_ hd0.

