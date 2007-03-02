From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID1, hot-swap and boot integrity
Date: Fri, 02 Mar 2007 15:57:14 -0500
Message-ID: <45E88FAA.5020106@tmr.com>
References: <45E82EF8.9000106@laurelnetworks.com> <20070302161004.GE31010@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070302161004.GE31010@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: Mike Accetta <maccetta@laurelnetworks.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gabor Gombas wrote:
> On Fri, Mar 02, 2007 at 09:04:40AM -0500, Mike Accetta wrote:
>
>   
>> Thoughts or other suggestions anyone?
>>     
>
> This is a case where a very small /boot partition is still a very good
> idea... 50-100MB is a good choice (some initramfs generators require
> quite a bit of space under /boot while generating the initramfs image
> esp. if you use distro-provided "contains-everything-and-the-kitchen-sink"
> kernels, so it is not wise to make /boot _too_ small).
>   
You are exactly right on that! Some (many) BIOS implementations will 
read the boot sector off the drive, and if there is no error will run 
the boot sector.
> But if you do not want /boot to be separate a moderately sized root
> partition is equally good. What you want to avoid is the "whole disk is
> a single partition/file system" kind of setup.
>
>   
Actually, the solution is moderately simple, install the replacement 
drive, create the partitions, and **don't mark the boot partition 
active** until the copy is complete. The BIOS will boot from the 1st 
active partition it finds (again, in sane cases).

I never have anything changing in /boot in normal operation, so I admit 
to using dd to do a copy with the array stopped. No particular reason to 
think it works better than just a rebuild. After the partition is valid 
I set the active flag in the partition.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

