From: pg_mh@mh.to.sabi.co.UK (Peter Grandi)
Subject: RE: RAID halting
Date: Sun, 5 Apr 2009 23:20:43 +0100
Message-ID: <18905.11963.968493.29417@tree.ty.sabi.co.uk>
References: <F2C688D6A021E34CB81C0E631EF4C093017FF4E0@34093-C4-EVS1.exchange.rackspace.com>
	<20090405203331.FWRT1944.cdptpa-omta02.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090405203331.FWRT1944.cdptpa-omta02.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> [ ... ] The evidence so far does not strongly suggest a
> hardware issue, at least not a drive issue, [ ... ]

> [ ... ] the drive system previously reported tons of sector
> remaps when the drives were in a different, clearly broken,
> enclosure, and they continue to do so on the 320G drive with
> known issues.

>> * Did you look into firmware? Are the drives and/or firmware
>>   revisions qualified by your controller vendor?

> Yes.  I did that before purchasing the controller.  No, I did not
> look into the drives.  The controller vendor does not qualify
> drives.  Controllers don't get any more generic than the one I
> purchased (I don't recall the brand at this time - it's based on
> the Silicon Image SiI3124 controller chip).

Uhhh, I'd invest in something else. Just in case. The SiL chips are
a bit low end, and most SiL based cards I have seeen were of the
cheap and cheerful variety, and those sometimes have fairly
marginal electrical/noise designs.

> More importantly, the fact the system ran for months without the
> problem, and the problem only occurred after changing the array
> chassis and the file system strongly suggests this is not the
> root of the issue.

Not necessarily: a different file system may trigger different bugs
in the host adapter fw and in the drive fw by doing operations in a
different sequence with different timing.

> [ ... ] "HOW DO I RUN A FULL BLOCK-LEVEL HARDWARE TEST?"

I agree that it seems unlikely that it is a physically defective
disk. More likely bad cabling, bad backplane, bad fw, bad
electrical/noise design.

Anyhow it is practically impossible on modern drives to run a full
black level hardware test on disk drives, which are more like block
servers, with several layers of interpolation between the command
level and the hardware.

However to run a *logical* block test, 'badblocks' from the
'e2fsprogs' package is the common choice.

But I'd leave running the CERN "silent corruption" daemon and other
checks/diagnostics and look carefully at the system logs for host
adapter errors.

For most people doing significant storage systems and self-built
systems of a certain size keeping current with the HEPiX workshops
<URL:https://WWW.HEPiX.org/> seems to me a good idea.
