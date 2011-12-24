From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID1 seems not to be able to scrub pending sectors shown by
 smart
Date: Sat, 24 Dec 2011 09:27:45 -0500
Message-ID: <4EF5E161.5010001@turmel.org>
References: <87hb0r2kvq.fsf@poker.hands.com> <CAAMCDedN7nBrt7nLoUq2v26ZoX21ab+htowc3r2A=nOAvfF42A@mail.gmail.com> <878vm32dan.fsf@poker.hands.com> <4EF5001F.8050409@gmail.com> <8762h62sgb.fsf@poker.hands.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8762h62sgb.fsf@poker.hands.com>
Sender: linux-raid-owner@vger.kernel.org
To: Philip Hands <phil@hands.com>
Cc: Roger Heflin <rogerheflin@gmail.com>, 'LinuxRaid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Philip,

On 12/24/2011 05:07 AM, Philip Hands wrote:
[...]
> Last night I started a check of the RAID that contained most of the errors on
> that disk, and it's pretty much finished (81%), in which time the Pending
> sector count is back up to 53. [Erm, 83% and 54 now -- while writing
> this mail]
> 
> Clearly it's not a particularly happy drive, so I guess that smart will
> eventually diagnose it as faulty, but in the mean time it may be a
> useful test case for mdadm.
> 
> One of those newly pending sectors was found almost immediately, as I
> was able to see from the logs, and while that was being dealt with, it
> drove the system load up to about 18, and rendered the system
> unresponsive for at least 10 seconds, probably more like 20 or 30 (the
> normal load once it had chance to settle down again was about 2, on a 6
> core CPU, so it wasn't really that busy).
> 
> [84% and 55 pending now -- with the first indication being a spike in
> load, followed a minute or two later by mention of the read problems in
> the logs, but apparently nothing logged by md, so presumably the read
> eventually succeeded]
> 
>> I wonder if a patch might be possible that allows one to put an array 
>> into a mode (or go into said mode once a badblock condition has 
>> happened) that causes it to read from at least 2 possible data sources 
>> and return whichever gets there first...
> 
> Well, given that something appears to be blocking in a fairly
> disastrous way on the read that's not coming back, I was wondering if
> there might be some way of having a timeout on those reads that if one
> gets no response for long enough (say 10 seconds) reacts by getting the
> data from elsewhere, and overwriting the slow sector.

Have you set up TLER or SCTERC on these drives?  I suspect you haven't, as
these long delays on read errors are typical of default error handling on
consumer drives.

Can you show the complete "smartctl -x" output for this failing drive?

Phil
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk714VwACgkQBP+iHzflm3BXmACffzNuNvh98KueHKUL06e9Ultj
ETcAn20P84PxbN3n6K0BlDoNsMpg1+2n
=2gBn
-----END PGP SIGNATURE-----
