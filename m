From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Partition or whole disk ?
Date: Thu, 1 Jul 2004 13:15:18 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0407011311110.21757-100000@coffee.psychology.mcmaster.ca>
References: <1088604941.2840.1.camel@JubJub>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1088604941.2840.1.camel@JubJub>
To: Josh Litherland <josh@emperorlinux.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Couldn't find an authoritative answer to this in the faq or elsewhere...
> Is it preferred to build md sets out of whole disks or of partitions ? 
> Is there any functional reason why either one is better ?

as others have pointed out, there's little reason (save a track
on whole-disk, lose partition-type-0xfd auto-detection).

however, if you go the partition route, don't go too far!
I've seen several cases where someone gets overly enthusiastic
about multiple parallel raids across a small set of disks.
they wind up shuffling the heads between partitions for an 
obscene fraction of time.  this can be especially noticable 
with journalling filesystems, since they tend to do synchronous
log forces on a regular basis.  don't even get me started on 
people who set their mail spools to pure-sync!  (hmm, why can 
my awesome new quad-opteron mail server only receive 10 email/sec?)

