From: Phil Turmel <philip@turmel.org>
Subject: Re: Mdadm server eating drives
Date: Thu, 13 Jun 2013 22:08:40 -0400
Message-ID: <51BA7B28.9030808@turmel.org>
References: <CAPSPcXizHpTnqfAGz7LDc3z+DSJUnOb7ukUdhbuFG6mJgs4=Bg@mail.gmail.com> <51B896A2.9090105@websitemanagers.com.au> <CAPSPcXihHrAi2TB9Fuxb1qOGMc_WzwGoXAA7nHdwe2knkO0LkQ@mail.gmail.com> <CAPSPcXib4YZ9Ah-jLvL_kPwpKHLxaGT0rNaDL4XQcFm=RtjcAQ@mail.gmail.com> <CAPSPcXhn8WKcZMVWhSDBVkRyqwo5XCyDc55f2sgr6davVsN5XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPSPcXhn8WKcZMVWhSDBVkRyqwo5XCyDc55f2sgr6davVsN5XA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Barrett Lewis <barrett.lewis.mitsi@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Barrett,

Please interleave your replies, and trim unnecessary quotes.

On 06/13/2013 08:19 PM, Barrett Lewis wrote:
> Sorry for the delay, I wanted to let the memtest run for 48 hours.
> It's at 49 hours now with zero errors, so memory is pretty much ruled
> out.
> 
> As far as power, I would *think* I have enough power.  The power
> supply is a 500w Thermaltake TR2.  It's powering an Asrock z77 mobo
> with an i5-3570k, and the only card on it is a dinky little 2 port
> sata card my OS drive is on (the RAID components are plugged into the
> mobo).  Eight 7200 drives and an SSD.  Tell me if this sounds
> insufficient.
> 
> Phil, when you say "what you are experiencing", what do you mean
> specifically?  The dmesg errors and drives falling off?  Or did you
> mean the beeping noises (since thats the part you trimmed)?

Drives dropping out when they shouldn't, and smartctl says "PASSED".
This is *unavoidable* when you have mismatched device and driver timeouts.

> Here is the data you requested
> 
> 1) mdadm -E /dev/sd[a-f]       http://pastie.org/8040826

/dev/sdd and /dev/sde have old event counts ...

> 2) mdadm -D /dev/md0          http://pastie.org/8040828

... matching the array report ...

> 3)
> smartctl -x /dev/sda                   http://pastie.org/8040847

Ok, but no error recovery support (typical of green drives).

> smartctl -x /dev/sdb                   http://pastie.org/8040848

Ok, green again.  No ERC.

> smartctl -x /dev/sdc                   http://pastie.org/8040850

Ok, with ERC support, but disabled.  Not a green drive.

> smartctl -x /dev/sdd                   http://pastie.org/8040851

Not Ok.  A few relocations, a couple pending errors.  ERC support
present but disabled.

> smartctl -x /dev/sde                   http://pastie.org/8040852

Not Ok.  No relocations, but several pending errors.  No ERC.

> smartctl -x /dev/sdf                   http://pastie.org/8040853

Ok, but no ERC.

> 4) cat /proc/mdstat                   http://pastie.org/8040859
> 
> 5) for x in /sys/block/sd*/device/timeout ; do echo $x $(< $x) ; done
>                  http://pastie.org/8040870

All timeouts are still the default 30 seconds.  With enabled ERC
support, these values must be two to three minutes.  I recommend 180
seconds.  Your array *will not* complete a rebuild with dealing with
this problem.

> 6) dmesg | grep -e sd -e md                   http://pastie.org/8040871
> (note that I have rebooted since the last dmesg link I posted (where
> two drives failed) because I was running memtest, if I should do dmesg
> differently, let me know)
> 
> 7) cat /etc/mdadm.conf                   http://pastie.org/8040876

I generally simplify the ARRAY line to just the device and the UUID, but
it is ok as is.

> Adam, I wouldn't be opposed to spending the money on a good sata card,
> but I'd like to get opinions from a few people first.  Any suggestions
> on a good one for mdadm specifically?

No need.  Just fix your timeouts.  For the two devices that support ERC,
you need to turn it on:

> smartctl -l scterc,70,70 /dev/sdc
> smartctl -l scterc,70,70 /dev/sdd

For the others, you need long timeouts in the linux driver:

> for x in /sys/block/sd[abef]/device/timeout ; do echo 180 >$x ; done

This must be done now, and at every power cycle or reboot.  rc.local or
similar distro config is the appropriate place.  (Enterprise drives
power up with ERC enabled.  As do raid-rated consumer drives like WD Red.)

Then stop and re-assemble your array.  Use --force to reintegrate your
problem drives.  Fortunately, this is a raid6--with compatible timeouts,
your rebuild will succeed.  A URE on /dev/sdd would have to fall in the
same place as a URE on /dev/sde to kill it.

Upon completion, the UREs will either be fixed or relocated.  If any
drive's relocations reach double digits, I'd replace it.

Finally, after your array is recovered, set up a cron job that'll
trigger a "check" scrub of your array on a regular basis.  I use a
weekly scrub.  The scrub keeps UREs that develop on idle parts of your
array from accumulating.  Note, the scrub itself will crash your array
if your timeouts are mismatched and any UREs are lurking.

I'll let you browse the archives for a more detailed explanation of
*why* this happens.

Phil
