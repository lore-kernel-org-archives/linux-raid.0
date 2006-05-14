From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: softraid and multiple distros
Date: Sun, 14 May 2006 14:42:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0605141438340.7486-100000@coffee.psychology.mcmaster.ca>
References: <200605142000.56659.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200605142000.56659.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Now the devices have all two superblocks, the one left from the first try 
> which are now kinda orphaned and those now active. 
> Can I trust mdadm to handle this properly on its own?

I'm not sure what "properly" means.  you should not leave around 0xfd 
partitions with bogus superblocks, since MD will certainly try to 
assemble them.  I don't know offhand how it decides which components 
to make into a single array (UUID?), but why screw around?
for "orphan" partitions, either change the partition type 
or zero the superblock or both...

