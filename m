From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: Robustness in the face of errors
Date: Mon, 18 Nov 2002 12:07:32 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D3CC@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Neil Brown' <neilb@cse.unsw.edu.au>, jbass@dmsd.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yeah, this is logic that scsi couldn't do by itself, but md can, since it
can recover the data.

Also, wouldn't we want to check (and even set) the auto-reallocation
(AWRE/ARRE) mode page bits on the drive when md loads, to let the disk do as
much as it can with remapping?  Or does that belong outside of md?

Andy

-----Original Message-----
From: Neil Brown [mailto:neilb@cse.unsw.edu.au] 
Sent: Saturday, November 16, 2002 7:09 AM
To: jbass@dmsd.com
Cc: linux-raid@vger.kernel.org
Subject: Re: Robustness in the face of errors


On Saturday November 16, jbass@dmsd.com wrote:
> On first error the system currently appears to just abandon a drive,
forcing
> the system into degraded mode for all I/O which follows. A much more
reasonable
> approach would be to not abandon the drive completely, but rather build a
fast
> lookup table with known bad blocks which would allow accesses to most
areas of
> the array to continue without degradation, and only areas that have bad
blocks
> would be forced into degraded mode.
> 
> Many drives will trash a sector if power drops when writing, and that
sector
> will generate read errors until written. It makes sense on those drives to
> recover the data in degraded mode, and re-write followed by a verify. If
the
> verify fails, and the drive support dynamic sparing/remapping the sector
> should be remapped, rewritten, and verified again. On a large 200GB arry,
this
> single feature would remove nearly a day of reconstruction time for normal
> errors and sector failures, substantially improving realized reliability.
> 
> Doing dynamic error management would remove 99% of the gross software raid
> device failures I have seen over the last year.

You are largely correct...
I look forward to you providing (or sponsoring) code to do this. :-)

Maybe this should go on a FAQ as it does get mentioned from time to
time.
The answer is:
    Yes, it could be done.
    No, it hasn't been done.
    Patches are always welcome.

NeilBrown
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
