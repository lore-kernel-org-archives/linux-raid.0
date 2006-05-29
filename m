From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 kicks non-fresh drives
Date: Mon, 29 May 2006 14:34:36 +1000
Message-ID: <17530.31196.220346.778940@cse.unsw.edu.au>
References: <1148652686.3100.4.camel@hendrix.hollabaugh.com>
	<Pine.LNX.4.44.0605261231460.20378-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mark Hahn on Friday May 26
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: Craig Hollabaugh <craig@hollabaugh.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday May 26, hahn@physics.mcmaster.ca wrote:
> > I had no idea about this particular configuration requirement. None of
> 
> just to be clear: it's not a requirement.  if you want the very nice 
> auto-assembling behavior, you need to designate the auto-assemblable 
> partitions.  but you can assemble "manually" without 0xfd partitions
> (even if that's in an initrd, for instance.)
> 
> I think the current situation is good, since there is some danger of 
> going too far.  for instance, testing each partition to see whether 
> it contains a valid superblock would be pretty crazy, right?

I'm curious: why exactly do you say that?
Doing the reads themselves cannot be a problem as the kernel already
reads the partition table from each devices.  Reading superblocks is
no big deal.

If you don't like the idea of assembling everything that was found,
how is that different from.....

  requiring
> either the "auto-assemble-me" partition type, or explicit partitions 
> given in a config file is a happy medium...

assembling everything that was found which had an 'auto-assemble-me'
flag?  That flag, in common usage, contains almost zero information
more than the existence of the raid superblock.

Am I missing something?

My opinion:  the "auto-assemble-me" partition type is not a happy
medium.  The superblock containing the hostname (as supported by
mdadm-2.5) is (I hope).

NeilBrown
