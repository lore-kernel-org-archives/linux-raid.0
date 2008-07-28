From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: System hangs on raid md recovery/resync
Date: Mon, 28 Jul 2008 06:16:10 -0500
Message-ID: <488DAA7A.4020901@gmail.com>
References: <da290bd50807260519v293851c9ue4bef88b1fc52013@mail.gmail.com>	 <da290bd50807271505k4bf5734bp9734883a219e9d53@mail.gmail.com>	 <488CF4F5.9030707@gmail.com>	 <da290bd50807271639o1dd585edwe121c156743a4199@mail.gmail.com>	 <488D0E04.3000505@gmail.com> <da290bd50807280305q44f5d127ofe98add826298ef5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <da290bd50807280305q44f5d127ofe98add826298ef5@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad <brad46526@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brad wrote:
> Roger,
> 
>> The Intel stuff tends to be pretty decent, where I have ran into the most
>> issues is with anything that the MB vendor adds on, so I would try putting
>> all 3 on the Intel, and in the past the Intel controllers I have tested have
>> been able to run all disks at full speed (or close to it) even when multiple
>> disks are being actively used, this would at least eliminate the jmicron
>> controller from the mix.
> 
> I thought I was being cute in putting the two disks of the regular raid1
> set on different controllers, for maximum redundancy.  :-)  But yes, the
> JMicron controller seems to be a bit flakey ... sometimes after a reboot it will
> experience constant 'hard resetting link' errors under full load.  After another
> reboot though it'll be as stable as a rock.  I've assumed Linux isn't getting
> something quite right when it initialises the JMicron controller at boot.
> 
> In any case I've noticed - using iostat - that when I've added the third drive
> to the raid1 device, for example, the recover operation consists of reads on
> the disk that's hooked up to the ICH9R controller and writes to the third
> disk on the same controller.  The MD code doesn't seem to share the read
> operation between the two existing mirrored disks, so the second disk on
> the JMicron isn't involved at all.

 From a performance stand point and if everything works fine it is a good idea, 
from a debugging and potential bug stand point, more drivers/more separate 
hardware involves more code/hardware so there is more stuff to have a bug/design 
defect.  With everything being on the Intel sata controllers I would not expect 
it to make a performance difference either way.

It could be the other traffic hitting the jmicron causes the failure when the 
Intel one is busy.

On mine the issues seems to be that the MB system does not properly deal with 
things being heavily utilized (and I have seen at least 2-3 other MB's that as 
designed only fail when pushed close to the bandwidth limit of the internal 
buses), if things are not pushed too hard it will run fine for weeks with no 
errors, push it hard enough the right way (and in my case a raid5 MD rebuild is 
what does it) and you can make it fall over in just minutes with any other 
traffic outside the MD subsystem also needing to be there.

> 
>> How much power does the PS have on the 12V line?    So long as it is either
>> a split 12V supply or has more than 15-20A (non-split PS) you should be OK.
> 
> I'm sorry but I wouldn't have a clue about that.  I've got an Antec
> Sonata III 500
> case with its standard 500W power suppler.  "80 PLUS" certified, whatever
> that means ... "an EarthWatts 500 Watt power supply unit (PSU) which is
> equipped with universal input and Active PFC. This PSU is also 80PLUS(R)
> certified making it one of the most efficient PSU's available" says their web
> site.

I have a earthwatts 380, the 500 should be just fine, that is what is called a 
split rail supply, it has 2 separate 12V supplies.    The ratings would be on 
the PS box itself, and on the PS itself.    My 380 says 12V(v1) 17A and 12V(v2) 
17A, a non-split rail supply will have only one 12V entry and it may be under 
17A on the single supply.

> 
>> You did run the dd on all 3 disks at the same time?
> 
> Yes.
> 
>> The hard resetting link usually indicates something bad happened, though
>> that could be caused by a lot of things.
> 
> I normally never see that error at all.  And I didn't see it the three times the
> system hung on the MD raid1 resync/recover operations.
> 
> If the kernel MD code had a hardware problem with the SATA 2 ports would
> I see an error message?

The message would go on the text console, if it hangs the system bad enough it 
would likely never make it to the log files as the disk subsystem is hung, so it 
would not be in the log files.   Also if you can switch to the console after the 
event the message would not be there, you would need to already have the text 
console up when the error happens.   dmesg may have the message if enough of the 
system is still working for dmesg to run.

                                 Roger

