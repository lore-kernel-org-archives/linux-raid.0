From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: bonnie++ on md device causes reboot on new motherboard
Date: Thu, 5 Feb 2009 09:57:30 -0600
Message-ID: <20090205155730.GA14035@sewage.raw-sewage.fake>
References: <20090203041450.GA2107@sewage.raw-sewage.fake> <4988061B.2020904@dgreaves.com> <18824.24876.76210.433309@stoffel.org> <4988E942.1060402@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4988E942.1060402@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: John Stoffel <john@stoffel.org>, David Greaves <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 03, 2009 at 07:02:58PM -0600, Roger Heflin wrote:
> John Stoffel wrote:
>> David> Matt Garman wrote:
>>>> Anyone seen anything like this or have any ideas where I can start
>>>> looking for more information?
>> David> netconsole?
>> David> 
>> http://www.mjmwired.net/kernel/Documentation/networking/netconsole.txt
>> Or a serial console...
>> David> At least then you may see what the error is.  And for a crash
>> David> like this I'd contact your distro kernel team too (not sure
>> David> about lkml with 2.6.24 but probably)
>>> From the sounds of it, it's a Hardware problem of some sort.  I'd run
>> a full memtest86 on the box, as well as some sort of CPU torture.
>> Check all your cables, possibly remove two of the four disks, etc.
>> Remove as much memory as possible, re-seat memory board, etc.  Have
>> you checked the BIOS version?  Have you reset the BIOS defaults to the
>> 'safe' or 'default' settings?  Don't bother tweaking stuff to get more
>> speed, go for stability.  The second you have porblems with stability,
>> you've lost all that time you saved by tweaking things.  :]
>>
>
> I would second the HW issue, if the machine is doing a full reset
> with no printout out of any type I would think PS, or some other
> serious HW issue, Linux generally does not crash without some
> error message.
>
> How big of PS do you have?
>
> I would try just dding the 4 disks at the same time and see if
> that also crashes.
>
> And then if you can remove 2 disks from the machine and retest.

Netconsole is a great idea, thanks for that!

I'm going to keep testing, but here are some answers to the above
and general notes.  Maybe these will generate ideas...

    - Power supply is a Seasonic 450 Watt.  I doubt this is the
      problem, as I've been using this same power supply---as well
      as all other hardware (except mobo and cpu)---without any
      stability problems for several months.  This MB/CPU actually
      uses less power than the previous.  Plus I have a Kill-A-Watt
      electricity meter hooked up; I have yet to see the machine
      pull more than 200 W AC (even at boot, md resync, cpuburn,
      memtest, etc).

    - I did a dd *read* test from the four drives in parallel
      numerous times without causing a crash.

    - I ran 24 hours of memtest86 without a single error.

    - BIOS settings are all set to stable/conservative values.
      (There is a newer BIOS, but no changelog---just says "updated
      CPU support".  I'll try it anyway.)

    - It's not just bonnie++, it appears to be any bulk write to the
      filesystem.  I tried to do a bulk copy (locally, using rsync)
      from the other md array, and that also caused a reset
      (unfortunately, I didn't have netconsole running when it
      happened).

    - One thing that's interesting is that every time this machine
      has rebooted itself, it has to resync the md array.  The rsync
      process itself has never caused a reboot.

    - I got brave and both ran bonnie++ and wrote a bunch of data
      (via NFS) to the other md array on the integrated (SB700) SATA
      controller.  No problems.

My hunch is that the board doesn't like one or both of those SiI
2-port PCIe SATA cards.  The motherboard has a single PCIe 1x slot
and a 16x; the SATA cards are both PCIe 1x.  Maybe the board doesn't
like having a 1x device in the 16x slot?  Although, my understanding
is that PCI express is smart enough to handle this kind of thing.

