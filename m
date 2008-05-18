From: David Greaves <david@dgreaves.com>
Subject: Re: questions about softraid limitations
Date: Sun, 18 May 2008 23:23:50 +0100
Message-ID: <4830AC76.6050004@dgreaves.com>
References: <002801c8b55a$60e4a360$0404a8c0@dcccs> <482AC2BB.5010602@dgreaves.com> <01be01c8b61a$6e616260$9300a8c0@dcccs> <482D479F.3040809@dgreaves.com> <022401c8b739$5262ba80$9300a8c0@dcccs> <482FF2DB.9060604@dgreaves.com> <A20315AE59B5C34585629E258D76A97C6B3EEC@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C6B3EEC@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: Janos Haar <janos.haar@netcenter.hu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Lethe wrote:
 > Hmm - I wonder if things like ddrescue could work with the md bitmaps to
> improve
> this situation?
> Is this related to David Lethe's recent request?
> 
> -----------
> No, we are trying two different approaches.
> In my situation, I already know that the data is munged on a particular
> block, so the solution is to calculate the correct data from surviving
> parity, and just write the new value.  There is no reason to worry about
> md bitmaps, or even whether or not there are 0x00 holes.

I think we (or I) may be talking about the same thing?

Consider an array sd[abcde] and a badblock (42) on sdb followed by a badblock
elsewhere (142) on sdc.
I would like to ddrescue sdb to sdb' and sdc to sdc' (leaving holes)
block 42 should be recovered from sd[acde] to sdb'
block 142 should be recovered from sd[abde] to sdc'

The idea was to possibly tristate the bitmap clean/dirty/corrupt.
If md gets a read/write error then it marks the block corrupt; alternatively we
could use the output from ddrescue to identify corrupt blocks that md may not
have seen.

I wondered whether each block actually needed to record the event it was last
updated with. I haven't thought through the various failure cases but...

> I am not trying to fix a problem such as a rebuild gone bad or an
> intermittent disk failure that put the md array in a partially synced,
> and totally confused state.
No, me neither...

> My desire is to limit damage before a full disk recovery needs to be
> performed, by insuring that there are no double-errors that will make
> stripe-level recovery impossible (assuming they aren't using RAID6).
> For that I need a mechanism to repair a stripe given a physical disk and
> offset. There is no completely failed disk to contend with, merely a
> block of bad data that will repair itself once I issue a simple write
> command. (trick, of course, is to figure out exactly what & where to
> right it and deal with potential locking issues relating to file
> system).
I think I'm describing that too.
If you simplify my case to a single badblock do we meet?

David

