From: linuxraid@valli.org
Subject: Re: Can't boot from Adaptec 2010s
Date: Wed, 14 Jan 2004 00:50:18 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <14863.194.153.176.133.1074037818.squirrel@mail.valli.org>
References: <34861.194.153.178.110.1073979704.squirrel@mail.valli.org>
     <1074016834.4776.342.camel@persist.az.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1074016834.4776.342.camel@persist.az.mvista.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry, I don't have installed redhat. It is a debian woody 3.0
with kernel 2.4.24 (self-compiled). It is not a problem of the kernel.
I think it is a problem of the bootloader (lilo version 22.2)
or something...
The bootflag is set to the /boot partition and the MBR is written
by lilo (/sbin/lilo -v)
At the time we boot via bootdisk. this works fine for the moment.
(The kernel on the bootdisk is the same; it works great!)
Thanks valli

> It could be that your root disk doesn't have an MBR record or that your
> RAID adaptor doesn't have the boot loader on it.  Have you tried a
> different distro such as redhat?
>
> Thanks
> -steve
>
> On Tue, 2004-01-13 at 00:41, linuxraid@valli.org wrote:
>> Hello all,
>> I successfully installed my linux (Debian with a 2.4.24 vanilla kernel)
>> on my Fujitsu Siemens Primergy TX200 server containing a 2010s (Raid 1).
>>
>> The only problem i have is that I can't boot from my raid. When I boot
>> from bootdisks the raid works fine!
>> My bootloader is lilo. The bootpartition on my disks has a ext3
>> filesystem.
>> When I boot the machine I can't see nothing from lilo, the machine just
>> hangs.
>> (The PhoenixBios recognizes 'I2O OSM' as a HardDrive)
>>
>> What could be the problem?
>>
>> Thanx for answering
>> valli
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
>
