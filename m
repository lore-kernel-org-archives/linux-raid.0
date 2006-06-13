From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: And then there was Bryce...
Date: Tue, 13 Jun 2006 14:38:50 -0400
Message-ID: <448F063A.6010408@tmr.com>
References: <44877242.2060803@zeniv.linux.org.uk> <4487C5F6.2080107@idgmail.se> <4487FDA6.3000507@zeniv.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4487FDA6.3000507@zeniv.linux.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Bryce <bryce@zeniv.linux.org.uk>
Cc: Henrik Holst <henrik.holst@idgmail.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bryce wrote:

> Henrik Holst wrote:
>
>> Bryce wrote:
>>  
>>
>>> Gosh, where to start,..
>>>
>>> Ok general setup
>>>
>>> I'm using  kernel version 2.6.17-rc5 and  Raid 5 over 5 500Gb SATA 
>>> disks
>>>     
>>
>>
>> You have just upgraded to udev havn't you? :-)
>>
>> [snip!]
>>
>>  
>>
>>> Hum ho,.. I survived the horror but umm, well, I'll leave the above as
>>> a story to frighten young sysadmins with.
>>>     
>>
>>
>> The same happened to me with eth0-2. I _could_ not for my life
>> understand why I didn't get internet connect to work. But then I
>> realized that eth0 and eth1 had been swapped after I upgraded to udev.
>> Please advice your distribution udev documentation how to "lock down"
>> scsi and network cards to specific kernel names.
>>
>> Regards,
>> Henrik Holst
>>   
>
> Ah,.. yes,, udev has helpfully remapped where all the drives I have 
> were,.. and of course I've misread the log because my brain is so 
> fixated on expecting drives to be where they should
>
> curse you UDEV!! 

If you were using PARTITIONS and letting mdadm assemble the RAID it 
wouldn't matter. Using names is dangerous even without udev, I have a 
system on (mostly) FC1, using a 2.6.15 kernel, and if I bbot with a 
drive in the removable bay it calls that controller (VIA something) hde 
and hdf, if there's no drive it drops the module for the controller and 
everything else moves up by two.

Using mdadm I haven't been bitten by this in severl years.

I have similar problems on a RH8.0 system which needs to run the burner 
on ide-scsi, depending on USB devices plugged at boot names are 
negotiable. At boot time the "right" names are found and symlinks 
created as needed.

Finally, there's a command which allows you to set names of NICs by MAC 
address. Haven't needed it in years, I *think* it's called ifname from 
the iproute2 stuff. That's from memory.

Hope some of this is useful, I over-answered the question.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

