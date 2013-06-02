From: Phil Turmel <philip@turmel.org>
Subject: Re: Wiki-recovering failed raid, overlay problem
Date: Sun, 02 Jun 2013 09:53:32 -0400
Message-ID: <51AB4E5C.5060909@turmel.org>
References: <CAGXrYFTamGFyiOz34ZV+zaoXMA3D9z-eJjco3gApdK95QR9fPg@mail.gmail.com> <51AA83FD.8080500@turmel.org> <CAGXrYFSgoLpKO-UHd_tvOh3gs3Ub2qqOKA48kPEA1Pr=cnrUhA@mail.gmail.com> <51AAA0B9.3050908@turmel.org> <CAGXrYFTyzG-hakGrU9j1=TSmjZHbzs2aRypJX=w8O4viS1+Dfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGXrYFTyzG-hakGrU9j1=TSmjZHbzs2aRypJX=w8O4viS1+Dfg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Finley <debenbain@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/02/2013 01:07 AM, Chris Finley wrote:
>>
>> Please show the output of my 'lsdrv' script [1] as your system is now
>> set up.

[trim /]

Ok.  Documented.

>> Your drive with S/N S2H7JD2B105688 seems to be the worst, with
>> triple-digit pending sectors.  This suggests a mismatch between your
>> drives' error correction time limits and the linux drivers' default
>> timeout.
> 
> I'm not sure that I understand this. Wouldn't the drive move a bad
> sector regardless of the OS timeout?

No.  If the drive takes longer than the linux driver (default 30
seconds) when encountering a typical unrecoverable read error, the
controller's attempt to reset the link disrupts the MD attempt to
rewrite the problem sector.  This failed *write* kicks the drive out of
the array when it would otherwise be corrected.

This is almost certainly what happened to your first dropped drive.  It
is otherwise healthy.

> Can you point me to more information on correcting the time limits?

There are numerous discussions in the archives...  search them for
combinations of "scterc", "tler", and "ure".

> The change in device mapping went like this:
> At Failure --> Now
> sdc                                              --> sdc
> sdd  (2nd drop, most errors)       --> ddrescue to sdb and then unplugged
> sde (1st drop, low event count)   --> sdd
> sdf                                               --> sde

So your device role order is /dev/sd{c,b,d,e}1.

>>  And a lack of regular scrubbing to clean up pending sectors.
>> "smartctl -l scterc" for each drive would give useful information.
>> Anyways, the drive may not be really failing--it has zero relocations.
>>
>> If S2H7JD2B105688 was the old /dev/sdd, then it doesn't matter, but
>> you've now lost the opportunity to correct those sectors.
> 
> The failed sdd has the serial number S2H7JD2B105688. I still have the
> drive, it's just unplugged.

You may want to revisit this drive.  ddrescue simply puts zeros where
the unreadable sectors were.  A running raid5 or raid6 array will fix
those unreadable sectors when encountered, as long as the drive timeouts
are short.

> Running "smartctl -l scterc" produces some interesting results.

Sadly, no.  These are what I expected.  And they show the reason
consumer-grade desktop drives are not warranteed for use in raid arrays.

> # smartctl -l scterc /dev/sdb
> smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.2.0-44-generic] (local build)
> Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net
> 
> SCT Error Recovery Control:
>            Read: Disabled
>           Write: Disabled

[trim /]

> What is going on here? How would error recovery get disabled?

On enterprise drives, or otherwise raid-rated drives, scterc defaults to
a small number on power-up, typically 7.0 seconds.  This is perfect for
MD raid.

On desktop drives, sold for systems without raid, aggressive (long)
error recovery is good--the user would want the drive to make every
possible effort to retrieve its data.  Most consumer drives will try for
two minutes or more, and will ignore any controller signals while doing
so.  Unfortunately, this behavior breaks raid arrays.

Good desktop drives, like yours, offer a setting to adjust this
behavior.  When needed, it must be set at every drive power up.  You
need suitable commands in your startup scripts (rc.local or equivalent).

Most desktop drives do not even offer scterc.  This protects the
manufacturers' markup for raid-rated drives.  When the drive timeout
cannot be shortened, the linux driver timeout must be lengthened.
Again, one would need suitable commands in the system startup scripts.

Finally, raid arrays need to be exercised to encounter (and fix) the
UREs as they develop, so they don't accumulate.  The only way to be sure
the entire data surface is read (including parity or mirror copies) is
to ask the array to "check" itself.  I recommend this scrub on a weekly
basis.

Anyways, the quickest way for you to have a running array is to use
"mdadm --assemble --force /dev/md0 /dev/sd{c,b,e}1".  This leaves out
the first dropped disk.  Any remaining UREs cannot be corrected while
degraded, but the data on the first dropped disk is suspect.

Feel free to use an overlay on /dev/md0 itself while making your first
attempt to mount and access the data.  If you cannot get critical data,
stop and re-assemble with all four devices.

Phil


