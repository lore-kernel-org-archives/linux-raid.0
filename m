From: Daniel Reurich <daniel@centurion.net.nz>
Subject: Re: md extension to support booting from raid whole disks.
Date: Thu, 14 May 2009 14:21:54 +1200
Message-ID: <1242267714.11016.174.camel@ezra>
References: <20090503013342770.VMBT19475@cdptpa-omta01.mail.rr.com>
	 <e13f0e541934a0966f213f6da13d83da.squirrel@neil.brown.name>
	 <1241406283.17240.26.camel@ezra> <87fxff462s.fsf@frosties.localdomain>
	 <21cdc7a16fbdd42979d52331db97c737.squirrel@neil.brown.name>
	 <87ws8r2pqf.fsf@frosties.localdomain>
	 <18953.2936.212863.158003@notabene.brown> <1242157469.18958.13.camel@ezra>
	 <18954.43834.53155.793587@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18954.43834.53155.793587@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> > Could we do this better using containers and snia's ddf in intels matrix
> > (or our own) metadata to define the data areas and this way create a
> > raid1 container at the start of the disks and use 1.0 format superblock
> > and metadata at the end of the drive (as long as this doesn't mess with
> > the metadata.  
> > 
> > This would solve the syncing of boot sectors because it would be done as
> > part of normal raid 1.  Hot add would simply be a matter of adding
> > members to the container.  The only issue I can see is whether you are
> > able to hot resize the data areas in containers as part of the grow
> > feature, or would we have to do a metadata tweak to redefine the size of
> > data areas.
> 
> While it might be possible to do something vaguely like this, I don't
> want to.
> 
Is it already possible to do with mdadm v3?

BTW, I'm not talking about just raiding the boot sector, but a raid1
volume with a filesystem for /boot with the embedded bootsector at the
start of it.  This means that for every member disk that includes
the /boot volume we have a mirror.

The description I got about ddf|matrix containers led me to believe this
was a robust way to do this.  

What's the point in supporting ddf|matrix containers if we can't create
the data areas within them to suit particular use cases like this?  

If we could/can then nothing further needs to be done to md/mdadm to
allow me to implement my preferred boot solution.

> don't bother having a raid1 there that is never read
> and hardly ever written..
????
It's read every time we boot!

I guess I've failed to communicate what I'm after effectively! :(

-- 
Daniel Reurich

Centurion Computer Technology (2005) Ltd
Ph 021 797 722

