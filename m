From: Paul van der Vlis <paul@vandervlis.nl>
Subject: Re: Wrong device name after hot-swap
Date: Sat, 23 Jan 2016 00:15:35 +0100
Message-ID: <n7ud6o$b1f$1@ger.gmane.org>
References: <n7u8gr$1bv$1@ger.gmane.org> <56A2ACB4.6060808@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56A2ACB4.6060808@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Op 22-01-16 om 23:27 schreef Phil Turmel:
> On 01/22/2016 04:55 PM, Paul van der Vlis wrote:
>> Hello,
>>
>> I want to put bigger disks into my server. What I want to do is replace
>> the first disk, rebuild the raid, replace the second disk, rebuild the
>> raid. The machine has two disks, sda and sdb.
>>
>> But, when I replace a disk, it gets a new device name. E.g. /dev/sdb
>> becomes /dev/sdc. After a reboot it's good again, but I prefer not to
>> reboot this machine!
>>
>> Is there a way to get the correct device name?
> 
> No.  Device names are assigned in the order they are encountered after
> boot, and that order is not guaranteed by the kernel.  You should never
> depend on those names.
> 
> When a device name is fully disconnected, modern kernels will recycle
> the name at the next opportunity.  

Correct, I see that with USB-sticks.

> You must be using a hotplug-enabled
> driver.  For most motherboards, turning on "AHCI" mode in the BIOS on
> those sata ports is all you need.

I have that. I am using an Intel chipset:

00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset
Family SATA AHCI Controller (rev 05)

>> When not:
>> Is it maybe an idea too add the wrong device name to the md-device?
>> mdadm /dev/md0 -a /dev/sdc1
>> Then replace /dev/sda what becomes /dev/sdd:
>> mdadm /dev/md0 -a /dev/sdd1
>> Then restore grub on both disks (with "--recheck" ??)
>> But what will happen after a reboot later? Will the md-device be
>> restored with the old names?
> 
> MD stores signatures in the devices it uses that identify them for later
> assembly.  It does not depend on the device name, though it is recorded
> in the superblock as a "last connected as" kind of indicator.

So I can do it as described above?

> In general, you should not rely on device names in your system
> configuration.  UUIDs and filesystem labels were implemented
> specifically to avoid this problem.

So far I know I cannot configure anywhere a disk UUID or a filesytem
label to a MD-device.

It feels wrong when I add /dev/sdc1 to the raid, when the name is
normally /dev/sdb1. But maybe it's no problem, because the device name
is not impartant while booting from an MD-device.

With regards,
Paul van der VLis.



-- 
Paul van der Vlis Linux systeembeheer Groningen
https://www.vandervlis.nl/

