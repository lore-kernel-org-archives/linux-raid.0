From: "David Lethe" <david@santools.com>
Subject: RE: questions about softraid limitations
Date: Sun, 18 May 2008 14:36:12 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C6B3EEC@34093-C3-EVS3.exchange.rackspace.com>
References: <002801c8b55a$60e4a360$0404a8c0@dcccs> <482AC2BB.5010602@dgreaves.com> <01be01c8b61a$6e616260$9300a8c0@dcccs> <482D479F.3040809@dgreaves.com> <022401c8b739$5262ba80$9300a8c0@dcccs> <482FF2DB.9060604@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <482FF2DB.9060604@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>, Janos Haar <janos.haar@netcenter.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



-----Original Message-----
From: David Greaves [mailto:david@dgreaves.com] 
Sent: Sunday, May 18, 2008 4:12 AM
To: Janos Haar
Cc: linux-raid@vger.kernel.org; David Lethe
Subject: Re: questions about softraid limitations

Janos Haar wrote:
> At this time, i working in my data recovery company, and some times
need
Ah - I missed this too.

> to recover the broken hw raid arrays too.
> (with md arrays, we have no problem at all. :-) )
Nice quote for "the benefits of software raid" somewhere :)

> In your rows, we talking about 2 cases:
> 
> a, disk hw problem (only bad sectors, the completely failed disk is in
> 'b' case)
> Yes, the ddrescue is the best way, to do the recovery, but:
> The ddrescue is too agressive with default -e 0 setting!
> This can be easily fail down the drive! (dependig the reason of the
bad
> sectors)
OK, worth knowing - what would you suggest?

> And with the images, we have another problem!
> The 0x00 holes.
> The hw or md have no deal about where we need recover from parity and
> where we have real zero blocks....
> Overall this is why data recovery companys learning and developing
more
> and more.... :-)

Hmm - I wonder if things like ddrescue could work with the md bitmaps to
improve
this situation?
Is this related to David Lethe's recent request?

> I need no help at this time, i just want to share my ideas, to helping
> upgrading/developing md, and helping for people....
OK - ta.

David
-----------
No, we are trying two different approaches.
In my situation, I already know that the data is munged on a particular
block, so the solution is to calculate the correct data from surviving
parity, and just write the new value.  There is no reason to worry about
md bitmaps, or even whether or not there are 0x00 holes.

I am not trying to fix a problem such as a rebuild gone bad or an
intermittent disk failure that put the md array in a partially synced,
and totally confused state. [I also do data recovery, and have a
software bag-o-tricks, but I only take on jobs relating to certain
hardware RAID controllers where I am intimately familiar with the
metadata layout ... and have a software bag-o-tricks that nearly always
have to modify given the original configuration, and chain of events].

My desire is to limit damage before a full disk recovery needs to be
performed, by insuring that there are no double-errors that will make
stripe-level recovery impossible (assuming they aren't using RAID6).
For that I need a mechanism to repair a stripe given a physical disk and
offset. There is no completely failed disk to contend with, merely a
block of bad data that will repair itself once I issue a simple write
command. (trick, of course, is to figure out exactly what & where to
right it and deal with potential locking issues relating to file
system).


