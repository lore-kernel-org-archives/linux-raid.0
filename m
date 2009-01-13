From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: upgrade advice
Date: Mon, 12 Jan 2009 23:37:34 -0500
Message-ID: <yq163kju8hd.fsf@sermon.lab.mkp.net>
References: <d5fe39840812160310t45e822c1geb633f805cf5388e@mail.gmail.com>
	<alpine.DEB.1.10.0812160641130.725@p34.internal.lan>
	<1229428184.22331.43.camel@localhost>
	<alpine.DEB.1.10.0812160807200.725@p34.internal.lan>
	<1229436950.22331.45.camel@localhost>
	<cccedfc60812160757x2af73afbv4a69eac31d212062@mail.gmail.com>
	<alpine.DEB.1.10.0812161829490.31132@p34.internal.lan>
	<cccedfc60812161608y29e6c645n6ff7df5c87292374@mail.gmail.com>
	<1229497160.22331.73.camel@localhost>
	<cccedfc60812170526l43c661ddgff95c99ea883f362@mail.gmail.com>
	<A20315AE59B5C34585629E258D76A97C030D4837@34093-C3-EVS3.exchange.rackspace.com>
	<1229525166.22331.79.camel@localhost>
	<yq17i5yhkvl.fsf@sermon.lab.mkp.net> <496C03C0.8050407@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <496C03C0.8050407@tmr.com> (Bill Davidsen's message of "Mon\, 12 Jan 2009 22\:00\:16 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Redeeman <redeeman@metanurb.dk>, David Lethe <david@santools.com>, Jon Nelson <jnelson-linux-raid@jamponi.net>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Bill" == Bill Davidsen <davidsen@tmr.com> writes:

>> Most of the errors you see on drives are a result of media errors
>> that are big enough that the drive ECC can't correct them.  Errors
>> are often caused by head misses due to bad tracking, vibration from
>> other drives in the enclosure, the user kicking the cabinet at an
>> inopportune moment, etc.  I.e. external interference.  Other errors
>> are due to real imperfections of the media itself.

Bill> I would be surprised if a consumer grade drive doing more retries
Bill> over several seconds rather than several rotations wasn't better
Bill> able to correct for most of the transient problems you mention.

Not all the problems I mentioned are of transient nature.  Several
common corruption scenarios are caused by the transient external factors
*at write time*.  No amount of retrying is going to fix something that
was badly written to begin with.  Doesn't even have to be the sector in
question.  Could be adjacent tracks that got clobbered.


Bill> Other than possibly having more ECC bits there isn't much
Bill> difference,

I mentioned better tracking/multiple sync marks as another crucial
difference.  That's a pretty huge deal in my book.

Nearline drive firmware also devotes resources to predicting impending
failure.  They have the ability to throttle the I/O pipeline if there's
an increased risk of write error due to excessive seeking, overheating,
etc.  That means that under load performance can be choppy.

That is unacceptable behavior in the consumer/interactivity
benchmarketing-focused market whereas making sure you write things
correctly is an absolute must in the enterprise space.  And the
non-deterministic performance characteristics are not such a big deal
when the drives are sitting behind an array head with non-volatile
cache.


Bill> as several people here have noted you don't want the drive to hang
Bill> for several seconds trying this and that in a server
Bill> environment. And given that there are a very small number of
Bill> things to be done on error, like reread, seek away and back,
Bill> recalibrate, etc, 

Again, you are talking about behavior when a transient read error is
detected.  My focus is the due diligence done by the firmware during
write operations.

It is correct that one of the defining characteristics of nearline
vs. consumer drives is the retry behavior.  But that's not the point I
was trying to make.

What I was trying to convey was that:

1. Contrary to popular belief there is no inherent mechanical difference
   between consumer and nearline drives.  Same heads, arms, motors, etc.
   The premium you pay is not for "mechanical ruggedness".  That's what
   most people assume when they are charged more(*).

2. The difference is largely in how the firmware encodes stuff on the
   physical platters in the drive, the internal housekeeping overhead.
   That difference between consumer and nearline is getting bigger with
   each generation of drives.

That said, I'm also sure you can appreciate that media defect tolerances
are likely to be different between nearline and consumer kit despite
coming off the same assembly line.


(*) Seagate recently put out some SAS nearline drives that have a
different logic board than their SATA cousins.  So there's actually a
real hardware difference in that series.  The fatter PCB with dual
processors enables even better integrity protection (on par with "real"
enterprise drives) albeit at lower duty cycles.

-- 
Martin K. Petersen	Oracle Linux Engineering
