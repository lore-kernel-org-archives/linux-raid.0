From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: upgrade advice
Date: Wed, 17 Dec 2008 10:38:54 -0500
Message-ID: <yq17i5yhkvl.fsf@sermon.lab.mkp.net>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1229525166.22331.79.camel@localhost> (redeeman@metanurb.dk's message of "Wed\, 17 Dec 2008 15\:46\:06 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Redeeman <redeeman@metanurb.dk>
Cc: David Lethe <david@santools.com>, Jon Nelson <jnelson-linux-raid@jamponi.net>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Redeeman" == Redeeman  <redeeman@metanurb.dk> writes:

>> Consider also how many people complain about botched rebuilds due
>> to multiple drive failures on rebuilds and bad blocks on surviving
>> disks.  I can't remember anybody who bought enterprise class disks
>> asking for such help recently, it always seems to be people who buy
>> consumer drives.  No wonder several fail within days of each other,
>> they all have same model, I/O load, and generally same
>> manufacturing batch.

Redeeman> Did you ever split open the consumer and "enterprise"
Redeeman> versions of the drives and observe?

Redeeman> While i do believe they do some more testing/quality control
Redeeman> on the enterprise disks, they are almost all identical
Redeeman> excepting firmware.. so to be fair, i'd say the mistake is
Redeeman> not properly stress testing the disks, and for instance just
Redeeman> buying a huge batch of disks and putting to use..

People always seem to assume that hardware is what's making the
difference between consumer and enterprise.  It's not.  The physical
hardware differs mostly due to capacity vs. RPM trade-offs.  Most
vendors these days have big platters for high-capacity drives and
smaller platters for high RPM/higher IOPS class drives.  On top of
that, head/platter count may vary in capacity classes within a series.

But the important difference between consumer and enterprise drives is
not mechanical.  It's the firmware.  Consumer drive firmware is about
squeezing out the most capacity/$ and nothing else.

Enterprise drives trade capacity for reliability by way of the
firmware.  That includes many things like using more space for track
info (gap/sync), much better ECC, better tolerance for rotational
vibration, etc.

Most of the errors you see on drives are a result of media errors that
are big enough that the drive ECC can't correct them.  Errors are
often caused by head misses due to bad tracking, vibration from other
drives in the enclosure, the user kicking the cabinet at an
inopportune moment, etc.  I.e. external interference.  Other errors
are due to real imperfections of the media itself.

Enterprise drive firmware is about being more resistant to outside
factors as well as real media defects.  That firmware cost more to
develop than the consumer ditto.  And the vendors charge a premium for
it.

So it's not the size that matters.  It's how you use it.

-- 
Martin K. Petersen	Oracle Linux Engineering

