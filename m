From: Neil Brown <neilb@suse.de>
Subject: Re: Problems with RAID 6 across 15 disks
Date: Fri, 2 Apr 2010 16:03:38 +1100
Message-ID: <20100402160338.389ca4d8@notabene.brown>
References: <4BB49E4D.1090809@maxeaves.co.uk>
	<4BB4A461.5030704@redhat.com>
	<4BB4A89F.7030707@maxeaves.co.uk>
	<20100402074325.3ce34e8f@notabene.brown>
	<20100401224644.GA2455@lazy.lzy>
	<1270162736.24051.0.camel@travelmate.workshop>
	<20100401230437.GA5067@lazy.lzy>
	<1270172413.24051.2.camel@travelmate.workshop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1270172413.24051.2.camel@travelmate.workshop>
Sender: linux-raid-owner@vger.kernel.org
To: jools@oxfordinspire.co.uk
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, max@maxeaves.co.uk, linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

On Fri, 02 Apr 2010 02:40:13 +0100
Jools Wills <jools@oxfordinspire.co.uk> wrote:

> On Fri, 2010-04-02 at 01:04 +0200, Piergiorgio Sartor wrote:
> > you might be unaware of the repeated neverending
> > discussions about this topic.
> 
> yup :)
> 
> > It is *possible* to do it, but, as of today, it
> > cannot do it.
> > I mean, there is no functionality, in the RAID-6, to
> > detect and correct those errors using the available
> > double parity.
> 
> Is this the same for raid 5 or specifically a raid 6 issue on linux ?
> 
> I had assumed that with my raid5 array, if the raid check finds an error
> it will attempt to rewrite back to the disk, and then read again, and
> carry on if everything is ok.

Piergiogio is confusing you.  Maybe he is confused himself.

The most likely cause of error on modern drives is media problem.  Maybe the
data wasn't stored well, or maybe the charge in the media decayed.
When you have trillions of bytes on a drive, the chance of something going
wrong becomes quite significant.

When this happens the drive will notice while reading and will report an
error (after trying a few times).  It detects an error because an
error-detecting code (CRC?) reported an error.

When this happens on a non-degraded array (RAID 1,10,4,5,6) md will recover
the data from elsewhere and write out good data, which will normally fix the
problem.

Ofcourse md cannot do this if it never reads the data, and on a terabyte
drive there is probably lots of data that won't be read often.

So a regular check pass to 'scrub' the device is a good ideas as it will find
these sleeping bad blocks by reading every single block.
It doesn't have to be weekly, or even monthly.  But regular is important.

You need to find a frequency and speed that matches your storage size and
throughput requirements, and how cautious you feel.

The situation which Piergiogio is referring to is quite different.
It is conceivably possible for wrong data to be written and a matching CRC to
be written with it.  In this case the drive doesn't notice so md doesn't
notice.
If you know the source of the error, or catch it before any write happens on
the same stripe, then it is possible on RAID6 or RAID1 with >2 drives to
work out with high probability which block has wrong data, and to fix it.

This sort of problem is much more rare, and is very likely to be accompanied
by other error the could well lead to general system failure.
Bad memory, bit flips on a bus that is not ECC protected, things like that.

As I said, it only make sense to attempt to 'correct' this if you know that
the stripe has not be written to since the error occurred.  You can only
really know this if you check for errors before every write.  We don't do
that and it would be a significant performance impact (I expect) to do so.

It does not make sense to try to fix these extreme rare possible errors on a
regular scan.  It does make sense to report them with more detail than we
currently do.  Patches always welcome.

http://neil.brown.name/blog/20100211050355

NeilBrown
