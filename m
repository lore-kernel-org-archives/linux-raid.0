From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: detecting/correcting _slightly_ flaky disks
Date: Mon, 5 Mar 2007 10:09:54 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0703051008190.14012@p34.internal.lan>
References: <bb145bd20703040322g1e5e8784i93a933c0c61b43f6@mail.gmail.com>
 <17898.45673.573800.56474@notabene.brown> <45EB3867.8050907@eyal.emu.id.au>
 <17899.18568.523543.478792@notabene.brown> <45EBCA83.40106@eyal.emu.id.au>
 <45EC2F89.2070703@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45EC2F89.2070703@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Stumpf <mjstumpf@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 5 Mar 2007, Michael Stumpf wrote:

> I'm trying to assemble an array (raid 5) of 8 older, but not yet old age ATA 
> 120 gig disks, but there is intermittent flakiness in one or more of the 
> drives.  Symptoms:
>
> * Won't boot sometimes.  Even after moving to 2 power supplies and monitoring 
> the amp spikes, sometimes I get "clicking" from 1-2 of the drives after the 
> startup.
>
> * When initiating a SMART long test, so far two of them have:
>      + passed 50-75% of the time
>      + when "failed", didn't actually fail, just perpetually were stuck at 
> an arbitrary % of test remain.
>      + If I cancel and restart the test, often they pass.
>
> I've heard clicking from some drives when executing SMART long tests.  Doing 
> 4 drives at a time, but still can't
> isolate and don't want to use laborious "sit and listen by computer" method 
> to determine which are dying--would prefer a tool to detect the issue.
>
> I know there's a problem with one or more because my issues with my primary 
> array disappeared the minute I used LVM to remove these devices (and upgrade 
> to some larger/newer ones).
>
> Two questions:
>
> 1)  Is it smartest to isolate which drives are clicking and chuck them into 
> the wood chipper, given the circumstances?
>
> 2)  Are there tools that are designed to determine if a drive is fit for 
> duty?  dd_rescue et all seem focused on saving a dying drive; spinrite seems 
> to be controversial black magic marketing, etc.  I could try the manufacturer 
> shipped tools but given their black box nature I have no idea how much (or 
> little) is being done by their tests.  What do you folks recommend?
>
> Thanks in advance.
> --Michael Stumpf
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

This is what I use:

799] What is the best way to verify a hard drive has no bad blocks? 
/usr/bin/time badblocks -b 512 -s -v -w /dev/hdg

Note, this will wipe anything out on the drive.

There is also a non-destructive write, check the manpage for badblocks(8).

This operation usually takes 12 hours or so on a 400GB drive, if this 
passes & short+long tests pass without error, the drive is probably OK for 
the time being.

Also, what does smartctl -a /dev/hda for each of your drives show?

Justin.
