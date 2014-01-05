From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Looking for some advice on best way to identify drives / recover
 from issues
Date: Sun, 5 Jan 2014 07:44:39 -0800
Message-ID: <CAK2H+ecnYpDbyqQrFZwmkL4F++iVwDvhfxNqxzWETbFtvXJqUg@mail.gmail.com>
References: <CAJrqPH9FNtomPygu1XPm2VQpJg3MKX1zUPCt0AOnzQ4GO7YEEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJrqPH9FNtomPygu1XPm2VQpJg3MKX1zUPCt0AOnzQ4GO7YEEQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dylan Distasio <interzone@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Jan 5, 2014 at 7:04 AM, Dylan Distasio <interzone@gmail.com> wrote:
> Hi all-
>
> I''ve been fortunate enough to not have to email this august group for
> advice regarding my mdadm arrays in quite awhile, but am looking for
> some suggestions.
>
> I woke up this morning to something beeping in my headless Norco
> server case at home (never a promising start to the morning).  I was
> unable to ping the box which increased my dismay.  I proceeded to
> perform a hard reboot, and still nothing on the ping.  At this point,
> I plugged a monitor in to see what was happening on reboot.
>
> Let me take a moment to provide details of my basic set up.  There are
> three separate HD controllers being used in this box: the motherboard
> headers, a supermicro PCI-X card (in a PCI slot), and a Highpoint
> RocketRaid SAS controller used as JBOD.
>
> I have a number of separate mdadm arrays tied to this physical box
> that have been built over the years including a RAID6 one, a RAID10,
> and 2 mirrors.
>
> Unfortunately, I did not take the time to physically label the drives
> in the box (there are close to 20) as I built these, and had been
> meaning to, but life got in the way.  Since I have had no issues with
> these arrays in a very long time, I don't even remember if I split
> them across controllers or what.
>
> So back to the reboot, I can see the motherboard drives showing up as
> the POST runs through its paces.  I can then see what appears to be
> the Supermicro drives showing up, but when the Highpoint controller
> gets to it own internal boot screen, it hangs at detecting drives, and
> I am unable to get into the controller card BIOS by hitting ctrl-H
> (keyboard works though, as I can ctrl-alt-delete, so it is not locking
> the PC).
>
> So at this point, I don't know my point of failure.  I am guessing the
> Highpoint flaked out though, especially since I now believe that was
> the component beeping based on the PC restarting ok otherwise.
>
> I am looking for advice on minimizing my risk of making things worse
> as I attempt to identify what drives belong which with array.   The
> RAID6 is my most immediate concern in getting back up and running.
>
> My immediate thought was to disconnect all drives and then reconnect
> them one by one from a motherboard header, and use:
>
> mdadm --examine /dev/sdX1
>
> Will that give me enough info to figure out which drive belongs to
> which array?  Does anyone have any other suggestions?  I am not sure
> of the current state of ANY of the arrays that were on this box, but I
> don't want to make things worse by booting this system up with some
> drives missing because I've unplugged them, and having the a bad
> situation get worse.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I'm reacting to nothing more than 20 drives, no documentation and beeping:

1) Are the beeps POST codes?

http://www.computerhope.com/beep.htm

2) Before making any physical changes I'd start by  drawing an
accurate picture. Exactly what cables go to exactly what drives. Put a
label on each drive & each cable (masking tape/black pen, etc.) so
that if you do disassemble things you have a chance of getting it back
together later in the same configuration.

3) If I thought it was the High Point I'd likely just remove it from
its slot and try booting again. (Assuming it's not needed to boot.)

4) It's not clear to me from this email exactly what's required (if
anything) in terms of RAID to make machine boot but if I could boot
from nothing but what's attached to the MB then that what I'd be
trying to do first. With 20 drives you could have a power supply
failiing  and the system isn't getting enough power to run 20 drives,
etc. Minimize as much as possible.

5) If you get to where you can boot then you should run smartctl on
each drive looking for any info. However I would understand if 20
drives over a bunch of years means not all drives support S.M.A.R.T.

6) Once you get it booting I'd run a check of any RAID that's included
at that point to ensure it hadn't been damaged and then look to add
things back in.

Good luck!

- Mark
