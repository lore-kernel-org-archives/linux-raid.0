From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: switching root fs '/' to boot from RAID1 with grub
Date: Sun, 04 Nov 2007 00:28:54 -0400
Message-ID: <472D4A86.3090700@tmr.com>
References: <20071030210721.386ca2fa@absurd> <1193781699.10336.585.camel@firewall.xsintricity.com> <472A0D7A.4040807@zytor.com> <472B51F0.3080605@panix.com> <472D3A1C.800@tmr.com> <472D402D.6040900@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <472D402D.6040900@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: berk walker <berk@panix.com>, Doug Ledford <dledford@redhat.com>, Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

H. Peter Anvin wrote:
> Bill Davidsen wrote:
>>>>
>>> Depends how "bad" the drive is.  Just to align the thread on this -  
>>> If the boot sector is bad - the bios on newer boxes will skip to the 
>>> next one.  But if it is "good", and you boot into garbage - - could 
>>> be Windows.. does it crash?
>>
>> Right, if the drive is dead almost every BIOS will fail over, if the 
>> read gets a CRC or similar most recent BIOS will fail over, but if an 
>> error-free read returns bad data, how can the BIOS know.
>>
>
> Unfortunately the Linux boot format doesn't contain any sort of 
> integrity check.  Otherwise the bootloader could catch this kind of 
> error and throw a failure, letting the next disk boot (or another 
> kernel.)

I don't understand your point, unless there's a Linux bootloader in the 
BIOS it will boot whatever 512 bytes are in sector 0. So if that's crap 
it doesn't matter what it would do if it was valid, some other bytes 
came off the drive instead. Maybe Windows, since there seems to be an 
option in Windows to check the boot sector on boot and rewrite it if it 
isn't the WinXP one.  One of my offspring has that problem, dual boot 
system, every time he boots Windows he has to boot from rescue and 
reinstall grub.

I think he could install grub in the partition, make that the active 
partition, and the boot would work, but he tried and only type FAT or 
VFAT seem to boot, active or not.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

