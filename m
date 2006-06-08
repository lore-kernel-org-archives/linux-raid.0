From: Bryce <bryce@zeniv.linux.org.uk>
Subject: Re: And then there was Bryce...
Date: Thu, 08 Jun 2006 11:36:22 +0100
Message-ID: <4487FDA6.3000507@zeniv.linux.org.uk>
References: <44877242.2060803@zeniv.linux.org.uk> <4487C5F6.2080107@idgmail.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4487C5F6.2080107@idgmail.se>
Sender: linux-raid-owner@vger.kernel.org
To: Henrik Holst <henrik.holst@idgmail.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Henrik Holst wrote:
> Bryce wrote:
>   
>> Gosh, where to start,..
>>
>> Ok general setup
>>
>> I'm using  kernel version 2.6.17-rc5 and  Raid 5 over 5 500Gb SATA disks
>>     
>
> You have just upgraded to udev havn't you? :-)
>
> [snip!]
>
>   
>> Hum ho,.. I survived the horror but umm, well, I'll leave the above as
>> a story to frighten young sysadmins with.
>>     
>
> The same happened to me with eth0-2. I _could_ not for my life
> understand why I didn't get internet connect to work. But then I
> realized that eth0 and eth1 had been swapped after I upgraded to udev.
> Please advice your distribution udev documentation how to "lock down"
> scsi and network cards to specific kernel names.
>
> Regards,
> Henrik Holst
>   
Ah,.. yes,, udev has helpfully remapped where all the drives I have 
were,.. and of course I've misread the log because my brain is so 
fixated on expecting drives to be where they should

curse you UDEV!!

Phil
=--=


Move along, nothing to see here except an overstressed worker...
