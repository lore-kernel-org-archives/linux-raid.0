From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: RAID5 kicks non-fresh drives
Date: Fri, 26 May 2006 12:45:55 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0605261231460.20378-100000@coffee.psychology.mcmaster.ca>
References: <1148652686.3100.4.camel@hendrix.hollabaugh.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1148652686.3100.4.camel@hendrix.hollabaugh.com>
Sender: linux-raid-owner@vger.kernel.org
To: Craig Hollabaugh <craig@hollabaugh.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I had no idea about this particular configuration requirement. None of

just to be clear: it's not a requirement.  if you want the very nice 
auto-assembling behavior, you need to designate the auto-assemblable 
partitions.  but you can assemble "manually" without 0xfd partitions
(even if that's in an initrd, for instance.)

I think the current situation is good, since there is some danger of 
going too far.  for instance, testing each partition to see whether 
it contains a valid superblock would be pretty crazy, right?  requiring
either the "auto-assemble-me" partition type, or explicit partitions 
given in a config file is a happy medium...

