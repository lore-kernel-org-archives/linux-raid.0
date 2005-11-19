From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: raid5 write performance
Date: Sat, 19 Nov 2005 17:52:46 -0200
Message-ID: <17279.33422.273880.463498@fisica.ufpr.br>
References: <200511190440.jAJ4efw15919@www.watkins-home.com>
	<437EB0A6.8040807@h3c.com>
	<17278.48635.585763.580503@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17278.48635.585763.580503@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown (neilb@suse.de) wrote on 19 November 2005 16:54:
 >There are two solutions to this silent corruption problem (other than
 >'ignore it and hope it doesn't bite' which is a fair widely used
 >solution, and I haven't seen any bite marks myself).

It happened to me several years ago when two disks failed almost
simultaneously due to scsi bus problems. I had to re-assemble the
array anyway and some files got corrupted :-( That's why I ended up
having each disk on an independent bus and cable...

 >One is journalling, as has been mentioned.  This could be done to a
 >mirrored pair, or to a ECC NVRAM card (the latter being probably the
 >best, though also most expensive).  You would write each data block as
 >it becomes available, and each parity block just before commencing a
 >write to the raid5.  Obviously you also keep track of what you have
 >written.
 >I have toyed with the idea of implementing this, but I think demand is
 >sufficiently low that it isn't worth it.
 >
 >The other is to use a filesystem that allows the problem to be avoided
 >by making sure that the only blocks that can be corrupted are dead
 >blocks.
 >This could be done with a copy-on-write filesystem that knows about the
 >raid5 geometry, and only ever writes to a stripe when no other blocks
 >on the stripe contain live data.
 >I've been working on a filesystem which does just this, and hope to
 >have it available in a year or two (it is a back-ground 'hobby'
 >project). 

I think the demand for any solution to the unclean array is indeed low
because of the small probability of a double failure. Those that want
more reliability can use a spare drive that resyncs automatically or
raid6 (or both).
