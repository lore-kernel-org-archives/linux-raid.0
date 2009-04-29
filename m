From: Michael Ole Olsen <gnu@gmx.net>
Subject: Re: md extension to support booting from raid whole disks, raid6,
	grub2, lvm2
Date: Thu, 30 Apr 2009 00:43:47 +0200
Message-ID: <20090429224347.GB29843@rlogin.dk>
References: <1240574900.4507.2076.camel@ezra> <87hc0axhg9.fsf@frosties.localdomain> <49F68CE0.2010906@zytor.com> <e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com> <1240957153.18303.689.camel@ezra> <18935.35747.471257.202356@notabene.brown> <49F78F26.2040909@zytor.com> <1240963225.18303.858.camel@ezra> <49F7997C.2070808@zytor.com> <1240964410.18303.895.camel@ezra>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1240964410.18303.895.camel@ezra>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Reurich <daniel@centurion.net.nz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Neil Brown <neilb@suse.de>, Dan Williams <dan.j.williams@intel.com>, Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I tried recently with grub2 and also the old grub in lenny (even the lenny
    installer fails, though it seems to complete fine, it just don't boot
    afterwards).

didn't think I would get an issue trying to get /boot on my lvm2 raid6 volume,
    as i recalled grub supported mdadm raids and also lvm2.

seems it has to be partitioned separately as a partition with mdadm and no
lvm2 on top of the boot partition, thats the only thing grub supports, 
     if I am not mistaken?

I just made one big volume, then created the logical volume /boot , and
neither grub or lilo would touch it (lilo only supports mdadm raid1 volumes)

would be cool to be able to boot lvm2 /boot volumes with grub

just wanted to give my recent experience with grub+lvm2+mdadm raid6.


/Michael Ole Olsen




On Wed, 29 Apr 2009, Daniel Reurich wrote:

> On Tue, 2009-04-28 at 17:04 -0700, H. Peter Anvin wrote:
> > Daniel Reurich wrote:
> > > 
> > >> For this to be reliable, there is only one sensible configuration, which
> > >> is for /boot to be a RAID-1, which is better handled by -- guess what --
> > >> partitioning systems; and we already have quite a few of those that work
> > >> just fine, thank you.  Otherwise there WILL be configurations -- caused
> > >> by controller failures if nothing else -- that simply will not boot even
> > >> though the system is otherwise functional.  Promoting this kind of stuff
> > >> is criminally stupid.
> > > 
> > > I disagree.  Grub is quite capable of booting from and assembling a
> > > raid5 volume and accessing it's partitions contents, even if the array
> > > is degraded.  All I'm asking for is that the first 64 kbytes of the disk
> > > be reserved and some of it possibly (but not necessarily) replicated so
> > > that a bootloader capable of assembling a raid array can be installed on
> > > the start of each member disk so that whatever disk the bios decides to
> > > boot from, it will always boot.
> > >  
> > 
> > Grub is capable of doing that IF THE FIRMWARE CAN REACH IT.
> 
> Well if the firmware can't find one if the disks, then it doesn't matter
> what scheme we have.  Even a single disk won't work.
> > 
> > You seem to have the happy notion that this is something typical, which
> > frequently isn't the case.
> 
> I'd say it's typical of 100% of pc's, mac's and just about anything else
> that boots of a harddisk without a hardware raid controller.
> > 
> > What's worse, you're clearly of the opinion that this is something that
> > should be promoted to users, which is the "criminal" part of "criminally
> > stupid."
> 
> I'd like it for me, and to prove it can be done and is a cleaner and
> less administratively intensive way of doing it then teaching the
> OS/user how to partition a disk and add each partition to into their
> respective raid array each time they need to replace or add a new disk
> to their array(s). 
> 
> Whether this proves reliable and stable enough to be promoted to users
> can only be seen once it's proven (or not).
> 
> What's your beef. MD already reserve some space for the superblock, and
> write-intent bitmap (which I believe is also replicated across the
> member disks), so why not add some space to this to make it possible for
> a bootloader as well.
> 
> 
> -- 
> Daniel Reurich
> 
> Centurion Computer Technology (2005) Ltd
> Ph 021 797 722
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
