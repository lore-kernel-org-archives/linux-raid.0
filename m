From: Barrett Lewis <barrett.lewis.mitsi@gmail.com>
Subject: Re: Mdadm server eating drives
Date: Thu, 13 Jun 2013 19:19:47 -0500
Message-ID: <CAPSPcXhn8WKcZMVWhSDBVkRyqwo5XCyDc55f2sgr6davVsN5XA@mail.gmail.com>
References: <CAPSPcXizHpTnqfAGz7LDc3z+DSJUnOb7ukUdhbuFG6mJgs4=Bg@mail.gmail.com>
	<51B896A2.9090105@websitemanagers.com.au>
	<CAPSPcXihHrAi2TB9Fuxb1qOGMc_WzwGoXAA7nHdwe2knkO0LkQ@mail.gmail.com>
	<CAPSPcXib4YZ9Ah-jLvL_kPwpKHLxaGT0rNaDL4XQcFm=RtjcAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPSPcXib4YZ9Ah-jLvL_kPwpKHLxaGT0rNaDL4XQcFm=RtjcAQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sorry for the delay, I wanted to let the memtest run for 48 hours.
It's at 49 hours now with zero errors, so memory is pretty much ruled
out.

As far as power, I would *think* I have enough power.  The power
supply is a 500w Thermaltake TR2.  It's powering an Asrock z77 mobo
with an i5-3570k, and the only card on it is a dinky little 2 port
sata card my OS drive is on (the RAID components are plugged into the
mobo).  Eight 7200 drives and an SSD.  Tell me if this sounds
insufficient.

Phil, when you say "what you are experiencing", what do you mean
specifically?  The dmesg errors and drives falling off?  Or did you
mean the beeping noises (since thats the part you trimmed)?


Here is the data you requested

1) mdadm -E /dev/sd[a-f]       http://pastie.org/8040826

2) mdadm -D /dev/md0          http://pastie.org/8040828

3)
smartctl -x /dev/sda                   http://pastie.org/8040847
smartctl -x /dev/sdb                   http://pastie.org/8040848
smartctl -x /dev/sdc                   http://pastie.org/8040850
smartctl -x /dev/sdd                   http://pastie.org/8040851
smartctl -x /dev/sde                   http://pastie.org/8040852
smartctl -x /dev/sdf                   http://pastie.org/8040853

4) cat /proc/mdstat                   http://pastie.org/8040859

5) for x in /sys/block/sd*/device/timeout ; do echo $x $(< $x) ; done
                 http://pastie.org/8040870

6) dmesg | grep -e sd -e md                   http://pastie.org/8040871
(note that I have rebooted since the last dmesg link I posted (where
two drives failed) because I was running memtest, if I should do dmesg
differently, let me know)

7) cat /etc/mdadm.conf                   http://pastie.org/8040876


Adam, I wouldn't be opposed to spending the money on a good sata card,
but I'd like to get opinions from a few people first.  Any suggestions
on a good one for mdadm specifically?

Thanks all!

On Thu, Jun 13, 2013 at 7:19 PM, Barrett Lewis
<barrett.lewis.mitsi@gmail.com> wrote:
> Sorry for the delay, I wanted to let the memtest run for 48 hours.  It's at
> 49 hours now with zero errors, so memory is pretty much ruled out.
>
> As far as power, I would *think* I have enough power.  The power supply is a
> 500w Thermaltake TR2.  It's powering an Asrock z77 mobo with an i5-3570k,
> and the only card on it is a dinky little 2 port sata card my OS drive is on
> (the RAID components are plugged into the mobo).  Eight 7200 drives and an
> SSD.  Tell me if this sounds insufficient.
>
> Phil, when you say "what you are experiencing", what do you mean
> specifically?  The dmesg errors and drives falling off?  Or did you mean the
> beeping noises (since thats the part you trimmed)?
>
>
> Here is the data you requested
>
> 1) mdadm -E /dev/sd[a-f]       http://pastie.org/8040826
>
> 2) mdadm -D /dev/md0          http://pastie.org/8040828
>
> 3)
> smartctl -x /dev/sda                   http://pastie.org/8040847
> smartctl -x /dev/sdb                   http://pastie.org/8040848
> smartctl -x /dev/sdc                   http://pastie.org/8040850
> smartctl -x /dev/sdd                   http://pastie.org/8040851
> smartctl -x /dev/sde                   http://pastie.org/8040852
> smartctl -x /dev/sdf                   http://pastie.org/8040853
>
> 4) cat /proc/mdstat                   http://pastie.org/8040859
>
> 5) for x in /sys/block/sd*/device/timeout ; do echo $x $(< $x) ; done
> http://pastie.org/8040870
>
> 6) dmesg | grep -e sd -e md                   http://pastie.org/8040871
> (note that I have rebooted since the last dmesg link I posted (where two
> drives failed) because I was running memtest, if I should do dmesg
> differently, let me know)
>
> 7) cat /etc/mdadm.conf                   http://pastie.org/8040876
>
>
> Adam, I wouldn't be opposed to spending the money on a good sata card, but
> I'd like to get opinions from a few people first.  Any suggestions on a good
> one for mdadm specifically?
>
> Thanks all!
>
>
> On Thu, Jun 13, 2013 at 7:17 PM, Barrett Lewis
> <barrett.lewis.mitsi@gmail.com> wrote:
>>
>> Sorry for the delay, I wanted to let the memtest run for 48 hours.  It's
>> at 49 now with zero errors, so memory is pretty much ruled out.
>>
>> As far as power, I would think I have enough power.  The power supply is a
>> 500w Thermaltake TR2.  It's powering an Asrock z77 mobo with an i5-3570k,
>> and the only card on it is a dinky little 2 port sata card my OS drive is on
>> (the RAID components are plugged into the mobo).  Eight 7200 drives and an
>> SSD.  Tell me if this sounds like insufficient power.
>>
>> Phil, when you say "what you are experiencing", what do you mean
>> specifically?  The dmesg errors and drives falling off?  Or did you mean the
>> beeping noises (since thats the part you trimmed)?
>>
>>
>> Here is the data you requested
>>
>> 1) mdadm -E /dev/sd[a-f]       http://pastie.org/8040826
>>
>> 2) mdadm -D /dev/md0          http://pastie.org/8040828
>>
>> 3)
>> smartctl -x /dev/sda                   http://pastie.org/8040847
>> smartctl -x /dev/sdb                   http://pastie.org/8040848
>> smartctl -x /dev/sdc                   http://pastie.org/8040850
>> smartctl -x /dev/sdd                   http://pastie.org/8040851
>> smartctl -x /dev/sde                   http://pastie.org/8040852
>> smartctl -x /dev/sdf                   http://pastie.org/8040853
>>
>> 4) cat /proc/mdstat                   http://pastie.org/8040859
>>
>> 5) for x in /sys/block/sd*/device/timeout ; do echo $x $(< $x) ; done
>> http://pastie.org/8040870
>>
>> 6) dmesg | grep -e sd -e md                   http://pastie.org/8040871
>> (note that I have rebooted since the last dmesg link I posted (where two
>> drives failed) because I was running memtest, if I should do dmesg
>> differently, let me know)
>>
>> 7) cat /etc/mdadm.conf                   http://pastie.org/8040876
>>
>>
>> Adam, I wouldn't be opposed to spending the money on a good sata card, but
>> I'd like to get opinions from a few people first.  Any suggestions on a good
>> one for mdadm specifically?
>>
>>
>>
>> On Wed, Jun 12, 2013 at 10:41 AM, Adam Goryachev
>> <adam@websitemanagers.com.au> wrote:
>>>
>>> On 12/06/13 23:47, Barrett Lewis wrote:
>>> > I started about 1 year ago with a 5x2tb raid 5.  At the beginning of
>>> > feburary, I came home from work and my drives were all making these
>>> > crazy beeping noises.  At that point I was on kernel version .34
>>> >
>>> > I shutdown and rebooted the server and the raid array didn't come back
>>> > online.  I noticed one drive was going up and down and determined that
>>> > the drive had actual physical damage to the power connecter and was
>>> > losing and regaining power through vibration.  No problem.  I bought
>>> > another hard drive and mdadm started recovering to the new drive.
>>> > Got it back to a Raid 5,  backed up my data, then started growing to a
>>> > raid6, and my computer hung hard where even REISUB was ignored.  I
>>> > restarted and resumed the grow.  Then I started getting errors like
>>> > these, they repeat for a minute or two and then the device gets failed
>>> > out of the array:
>>> >
>>> > [  193.801507] ata4.00: exception Emask 0x0 SAct 0x40000063 SErr 0x0
>>> > action 0x0
>>> > [  193.801554] ata4.00: irq_stat 0x40000008
>>> > [  193.801581] ata4.00: failed command: READ FPDMA QUEUED
>>> > [  193.801616] ata4.00: cmd 60/08:f0:98:c8:2b/00:00:10:00:00/40 tag 30
>>> > ncq 4096 in
>>> > [  193.801618]          res 51/40:08:98:c8:2b/00:00:10:00:00/40 Emask
>>> > 0x409 (media error) <F>
>>> > [  193.801703] ata4.00: status: { DRDY ERR }
>>> > [  193.801728] ata4.00: error: { UNC }
>>> > [  193.804479] ata4.00: configured for UDMA/133
>>> > [  193.804499] ata4: EH complete
>>> >
>>> > First one one drive, then on another, then on another, as the slow
>>> > grow to raid 6 was happening these messages kept coming up and taking
>>> > drives down.  Eventually (over the course of the week long grow time)
>>> > the failures were happening faster than I could recover them and I had
>>> > to revert to ddrescueing raid components to keep it from going under
>>> > the minimum components.  I ended up having to ddrescue 3 failed drives
>>> > and force the array assembly to get back to 5 drives and by that time
>>> > the arrays ext4 file system could no longer mount (said something
>>> > about group descriptors being corrupted).  By this time, every one of
>>> > the original drives has been replaced and this has been ongoing for 5
>>> > months.  I didn't even want to do an fsck to *attempt* to fix the file
>>> > system until I got a solid raid6.
>>> >
>>> > I upgraded my kernel to .40, bought another hard drive and put it in
>>> > there and started the grow.  Within an hour the system froze. I
>>> > rebooted and restarted the array (and the grow), 2 hours later the
>>> > system froze again, rebooted restarted the array (and the grow) again,
>>> > and got those same errors again, this time on a drive that I had
>>> > bought last month.  Frustrated (feeling like this will never end) I
>>> > let it keep going, hoping to atleast get back to raid 5.  A few hours
>>> > later I got these errors AGAIN on ANOTHER drive I got last month (of a
>>> > differen't brand and model).  So now I'm back with a non functional
>>> > array.  A pile of 6 dead drives (not counting the ones still in the
>>> > computer, components of a now incomplete array).
>>> >
>>> > What is going on here?  If brand new drives from a month ago from two
>>> > different manufacturers are failling, something else is going on.  Is
>>> > it my motherboard?  I've run memtest for 15 hours so far with no
>>> > errors, and ill let it go for 48 before I stop it, lets assume its not
>>> > the RAM for now.
>>> >
>>> > Not included in this history are SEVERAL times the machine locked up
>>> > harder than a REISUB, almost always during the heavy IO of component
>>> > recovery.  It seems to stay up for weeks when the array is inactive
>>> > (and I'm too busy with other things to deal with it) and then as soon
>>> > as I put a new drive in and the recovery starts, it hangs within an
>>> > hour, and does so every few hours, and eventually I get the "failed
>>> > command: READ FPDMA QUEUED status: { DRDY ERR } error: { UNC }" errors
>>> > and another drive falls off the array.
>>> >
>>> > I don't mind buying a new motherboard if thats what it is (i've
>>> > already spent almost a grand on hard drives), I just want to get this
>>> > fixed/stable and the nightmare behind me.
>>> >
>>> > Here is the dmesg output for my last boot where two drives failed at
>>> > 193 and 12196: http://paste.ubuntu.com/5753575/
>>> >
>>> > Thanks for any thoughts on the matter
>>>
>>> Apart from the previous thought regarding lack of power for the number
>>> of drives, have you considered getting a SATA controller card? This
>>> would totally rule out the motherboard as being an issue without forcing
>>> you to replace the motherboard. I'd probably check out the power supply
>>> issue first (quick, cheap, easy) and then follow up with using a well
>>> supported SATA controller card.... (ie, not a cheap crappy sata card
>>> with poor drivers/etc).
>>>
>>> Hope this helps
>>>
>>> Regards,
>>> Adam
>>>
>>> --
>>> Adam Goryachev
>>> Website Managers
>>> Ph: +61 2 8304 0000
>>> adam@websitemanagers.com.au
>>> Fax: +61 2 8304 0001
>>> www.websitemanagers.com.au
>>>
>>
>
