From: "Stephen Hargrove" <stephen@exitwound.org>
Subject: RE: Should I Start Over?
Date: Wed, 7 Jul 2004 13:24:27 -0500 (CDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <2128.66.230.1.97.1089224667.squirrel@exitwound.org>
References: <1165.66.230.1.97.1089206618.squirrel@exitwound.org>
    <200407071340.i67DeJ307800@watkins-home.com>
Reply-To: stephen@exitwound.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200407071340.i67DeJ307800@watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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
