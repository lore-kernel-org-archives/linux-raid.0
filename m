From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: is this raid5 OK ?
Date: Fri, 30 Mar 2007 21:00:38 -0400
Message-ID: <460DB2B6.1040207@tmr.com>
References: <237230840.20070329193857@kaneda.iguw.tuwien.ac.at> <17932.22575.558925.535963@notabene.brown> <460CF7EF.1000203@kaneda.iguw.tuwien.ac.at> <460D3A9F.7010800@tmr.com> <460D55AB.1080309@kaneda.iguw.tuwien.ac.at> <Pine.LNX.4.64.0703301655270.11067@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0703301655270.11067@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
>
> On Fri, 30 Mar 2007, Rainer Fuegenstein wrote:
>
>> Bill Davidsen wrote:
>>
>>> This still looks odd, why should it behave like this. I have created 
>>> a lot of arrays (when I was doing the RAID5 speed testing thread), 
>>> and never had anything like this. I'd like to see dmesg to see if 
>>> there was an error reported regarding this.
>>>
>>> I think there's more going on, the original post showed the array as 
>>> up rather than some building status, also indicates some issue, 
>>> perhaps. What is the partition type of each of these partitions? 
>>> Perhaps there's a clue there.
>>
>> partition type is FD (linux raid autodetect) on all disks.
>>
>> here's some more info:
>> the hardware is pretty old, an 800MHz ASUS board with AMD cpu and an 
>> extra onboard promise IDE controller with two channels. the server 
>> was working well with a 60 GB hda disk (system) and a single 400 GB 
>> disk (hde) for data. kernel was 2.6.19-1.2288.fc5xen0.
>>
>> when I added 3 more 400 GB disks (hdf to hdh) and created the raid5, 
>> the server crashed (rebooted, freezed, ...) as soon as there was more 
>> activity on the raid (kernel panics indicating trouble with 
>> interrupts, inpage errors etc.) I then upgraded to a 400W power 
>> supply, which didn't help.  I went back to two single (non-raid) 400 
>> GB disks - same problem.
>>
>> finally, I figured out that the non-xen kernel works without 
>> problems. I'm filling the raid5 since several hours now and the 
>> system is still stable.
>>
>> I haven't tried to re-create the raid5 using the non-xen kernel, it 
>> was created using the xen kernel. maybe xen could be the problem ?
>>
>> I was wrong in my last post - OS  is actually fedora core 5 (sorry 
>> for the typo)
>>
>> PCI: Disabling Via external APIC routing
>
> I will note there is the ominous '400GB' lockup bug with certain promise
> controllers.
>
> With the Promise ATA/133 controllers in some configurations you will get
> a DRQ/lockup no matter what, replacing with an ATA/100 card and no
> issues.  But I see you have a 20265 with is an ATA/100 promise/chipset.
>
> Just out of curiosity have you tried writing or running badblocks on
> each parition simultaenously, this would simulate (somewhat) the I/O
> sent/received to the drives during a RAID5 rebuild.

These are all things which could be related, but any clue why the 
non-xen kernel works?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

