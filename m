From: John Hendrikx <hjohn@xs4all.nl>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Wed, 18 Jan 2006 13:46:16 +0100
Message-ID: <43CE3898.7090207@xs4all.nl>
References: <20060117174531.27739.patches@notabene> <43CCA80B.4020603@tls.msk.ru> <20060117095019.GA27262@localhost.localdomain> <43CCD453.9070900@tls.msk.ru> <20060117160829.GA16606@lug.udel.edu> <43CD3388.9050107@tls.msk.ru> <20060118081407.GC18945@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060118081407.GC18945@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sander wrote:
> Michael Tokarev wrote (ao):
>   
>> Most problematic case so far, which I described numerous times (like,
>> "why linux raid isn't Raid really, why it can be worse than plain
>> disk") is when, after single sector read failure, md kicks the whole
>> disk off the array, and when you start resync (after replacing the
>> "bad" drive or just remapping that bad sector or even doing nothing,
>> as it will be remapped in almost all cases during write, on real
>> drives anyway),
>>     
>
> If the (harddisk internal) remap succeeded, the OS doesn't see the bad
> sector at all I believe.
>   
Most hard disks will not remap sectors when reading fails, because then 
the contents would be lost permanently. 

Instead, they will report a failure to the OS, hoping that the sector 
might be readable at some later time.

What Linux Raid could do is reconstructing the sector that failed from 
the other drives and then writing it to disk.  Because the original 
contents of the sector will be lost on writing, your hard disk can 
safely remap the sector (and it will -- I often "repaired" bad sectors 
by writing to them).

> If you (the OS) do see a bad sector, the disk couldn't remap, and goes
> downhill from there, right?
>   
Not necessarily, if you see a bad sector after *writing* to it (several 
times), then your hard disk will probably go bad soon.  Most hard disks 
only remap sectors on write, so a simple full format can fix sectors 
that failed on read.

I agree with the original poster though, I'd really love to see Linux 
Raid take special action on sector read failures.  It happens about 5-6 
times a year here that a disk gets kicked out of the array for a simple 
read failure.  A rebuild of the array will fix it without a trace, but a 
rebuild takes about 3 hours :)

--John

