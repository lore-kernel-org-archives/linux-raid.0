From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Should I Start Over?
Date: Wed, 7 Jul 2004 15:07:37 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407071907.i67J7b309004@watkins-home.com>
References: <2128.66.230.1.97.1089224667.squirrel@exitwound.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2128.66.230.1.97.1089224667.squirrel@exitwound.org>
To: stephen@exitwound.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I said:
> Do this command to determine which disk is being re-built:
> cat /proc/mdadm

You said:
I do not have a /proc/mdadm.  All I have is /proc/mdstat.
Thanks!

My bad! cat /proc/mdstat
Now I don't think /proc/mdstat will help.

Send me the output from these 2 commands:
Cat /proc/mdstat
mdadm -D /dev/md0

Omit the disk that is being re-built!!!!!!  Not hde1.  hde1 was added as a
spare.  It may still have good data.  The disk being re-built is toast!  The
other 2 may also have good data.

Take your time!!!  Re-read everything.  Then when you get to "re-read
everything", do it again!  :)

If you are not sure, just ask another question.

Lots of odd things can go wrong.  You can recover from most of them!!  But,
the documentation on recovery is non-existent!  I have learned what I know
from monitoring this list, asking on this list, and playing with the stuff.

Once we get things working we will try to determine why your re-build is so
slow!

Guy

-----Original Message-----
From: Stephen Hargrove [mailto:stephen@exitwound.org] 
Sent: Wednesday, July 07, 2004 2:24 PM
To: Guy
Cc: linux-raid@vger.kernel.org
Subject: RE: Should I Start Over?

Guy said:
> You did not use the "missing" keyword.  You just created a 3 disk array.
> If
> your array had 3 disks, you should have listed 2 of them and the "missing"
> keyword for the third.

Hrm.  Ok.  I should have read the man page before proceeding.  Well, it's
official.  I am an idiot.

> Why did you add a spare(hde1)?

See above.

> You should have done something like this:
> mdadm --create /dev/md0 --level=5 --raid-devices=4 /dev/hdg1 /dev/hdd1
> /dev/hdc1 missing

# mdadm --create /dev/md0 --level=5 --raid-devices=4 /dev/hdg1 /dev/hdd1
/dev/hdc1 missing
mdadm: /dev/hdg1 appears to be part of a raid array:
    level=5 devices=3 ctime=Wed Jul  7 08:11:18 2004
mdadm: /dev/hdd1 appears to be part of a raid array:
    level=5 devices=3 ctime=Wed Jul  7 08:11:18 2004
mdadm: /dev/hdc1 appears to be part of a raid array:
    level=5 devices=3 ctime=Wed Jul  7 08:11:18 2004
Continue creating array? n

Yeah, it looks like I screwed the pooch on this one.  The array was
composed of hd[gdc] with hde as the spare.  I managed to stop the rebuild
at 1.1% complete.  I guess at this point I don't have anything to lose by
letting it rebuild.  Would there be any benefit to omitting hdg and
letting it rebuild from hd[cde]?  Like this:

# mdadm --create /dev/md0 --level=5 --raid-devices=4 /dev/hdd1 /dev/hdc1
/dev/hde1 missing

> Do this command to determine which disk is being re-built:
> cat /proc/mdadm

I do not have a /proc/mdadm.  All I have is /proc/mdstat.

Thanks!
--
Steve

