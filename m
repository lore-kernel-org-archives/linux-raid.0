From: "Rev. Jeffrey Paul" <sneak@datavibe.net>
Subject: Re: experiences with 3Ware 6400 3W-6400?
Date: Fri, 27 Jun 2003 15:45:08 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.55.0306271540140.6883@datavibe.net>
References: <Pine.LNX.4.55.0306270920010.6883@datavibe.net>     
 <Pine.LNX.4.43.0306271429480.32150-100000@unicorn.drogon.net>
 <3841.208.48.139.163.1056738220.squirrel@www.greenhydrant.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3841.208.48.139.163.1056738220.squirrel@www.greenhydrant.com>
To: David Rees <dbr@greenhydrant.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 27 Jun 2003, David Rees wrote:

> Gordon Henderson said:
> >
> > Eg. the PC I'm currently typing this email on is 100 miles away and I
> > don't particularly want to drive to it to fix it if a disk fails...
> >
> > gordon @ unicorn: df -h /
> > Filesystem            Size  Used Avail Use% Mounted on
> > /dev/md0              236M   20M  204M   9% /
> >
> > gordon @ unicorn: cat /proc/mdstat
> > ...
> > md0 : active raid1 hdc1[1] hda1[0]
> >       249856 blocks [2/2] [UU]
> > ...
>
> So what do you do when /dev/hda fails and the computer won't reboot?  Have
> you managed to get it to boot off /dev/hdc when /dev/hda isn't available?
>
> Not having to worry about these sorts of things is one reason it's nice to
> have hardware RAID for at least the boot device.

Exactly.  Another issue is that I want them to be able to just swap out
(not necessarily hot, but offline even) a failed drive without my
intervention.... I assume the card will just resync it?  Under linux, it'd
require mucking about with mdadm or the raidtools and I want this to be a
fire-and-forget kind of system.  On solid hardware on a UPS, the only
things likely to die are the processor fan, the power supply, and the
drives...  all of which can be replaced with no knowledge of the raid or
software configuration.

Additionally, I didn't realize the 7xxx cards were that cheap.  If i'm
just using raid 1 or possibly raid10, is it really going to make that much
of a difference?

-j

--
--------------------------------------------------------
 Rev. Jeffrey Paul    -datavibe-     sneak@datavibe.net
   aim:x736e65616b   pgp:0x15FA257E   phone:8777483467
    70E0 B896 D5F3 8BF4 4BEE 2CCF EF2F BA28 15FA 257E
--------------------------------------------------------
