From: Neil Brown <neilb@suse.de>
Subject: Re: softraid and multiple distros
Date: Mon, 15 May 2006 08:51:58 +1000
Message-ID: <17511.46222.221460.337788@cse.unsw.edu.au>
References: <Pine.LNX.4.44.0605141048330.7486-100000@coffee.psychology.mcmaster.ca>
	<200605142000.56659.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dexter Filmore on Sunday May 14
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: Mark Hahn <hahn@physics.mcmaster.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday May 14, Dexter.Filmore@gmx.de wrote:
> Am Sonntag, 14. Mai 2006 16:50 schrieben Sie:
> > > What do I need to do when I want to install a different distro on the
> > > machine with a raid5 array?
> > > Which files do I need? /etc/mdadm.conf? /etc/raittab? both?
> >
> > MD doesn't need any files to function, since it can auto-assemble
> > arrays based on their superblocks (for partition-type 0xfd).
> 
> I see. Now an issue arises someone else here mentioned: 
> My first attempt was to use the entire disks, then I was hinted that this 
> approach wasn't too hot so I made partitions. 

I always use entire disks if I want the entire disks raided (sounds
obvious, doesn't it...)  I only use partitions when I want to vary the
raid layout for different parts of the disk (e.g. mirrored root, mirrored
swap, raid6 for the rest).   But that certainly doesn't mean it is
wrong to use partitions for the whole disk.


> Now the devices have all two superblocks, the one left from the first try 
> which are now kinda orphaned and those now active. 
> Can I trust mdadm to handle this properly on its own?

You can tell mdadm where to look.  If you want to be sure that it
won't look at entire drives, only partitions, then a line like
   DEVICES /dev/[hs]d*[0-1]
in /etc/mdadm.conf might be what you want. 
However as you should be listing the uuids in /etc/mdadm.conf, any
superblock with an unknown uuid will easily be ignored.

If you are relying nf 0xfd autodetect to assemble your arrays, then
obviously the entire-disk superblock will be ignored (because they
wont be in the right place in any partition).

NeilBrown
