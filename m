From: Sven Luther <sven.luther@wanadoo.fr>
Subject: Re: Root Drive Mirroring and LVM.
Date: Wed, 28 Jan 2004 09:15:23 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040128081523.GA27313@iliana>
References: <868055F9-5045-11D8-8066-00039382032A@mindspring.com> <200401270801.i0R81HdT022197@kruuna.Helsinki.FI> <16407.4986.950905.135422@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16407.4986.950905.135422@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Atro.Tossavainen@helsinki.fi, linuxppc-dev@lists.linuxppc.org, linux-raid@vger.kernel.org, tas@mindspring.com
List-Id: linux-raid.ids

On Wed, Jan 28, 2004 at 12:42:18PM +1100, Neil Brown wrote:
> 
> On Tuesday January 27, atossava@cc.helsinki.fi wrote:
> > Sorry about the crossposting.
> >
> > I wrote on the Yellow Dog Linux list when somebody asked about software
> > RAID on YDL about my experiences with it:
> >
> > >> The one really big gotcha is that the Macintosh partitioning scheme
> > >> can't tell the Linux kernel that certain partitions are to be
> > >> considered "Linux RAID autodetect" (as in x86 using the DOS partition
> > >> table type 0xfd). This means that you can't boot a Mac Linux system
> > >> directly from RAID because the kernel won't be able to autostart the
> > >> RAID devices. You have to work around this by creating an initial RAM
> > >> disk that uses the raidstart command to start your metadevices, then
> > >> swaps the initrd out of the way and proceeds to start the real system.
> >
> 
> This is not entirely true.  Certainly an initial-ram-disk is one
> solution and is (I think) the preferred long-term solution. However
> you can also boot from raid with kernel-parameters like:
> 
>    md=0,/dev/hda1,/dev/hdc1 boot=/dev/md0
> 
> where '0' indicated which md device (md0 in this case), and the
> remaining words are the devices to assemble it from.

This is said to be broken on latest 2.4.x kernels though. Didn't try
myself though, since i only have a single drive, and don't really want
to mess up with it.

> > to which Tim Seufert replied on the same list:
> >
> > > Hmmm.  That would seem to be a lack in the Linux RAID code, since the
> > > Macintosh partition table has a vastly more flexible partition type
> > > field than DOS: instead of a single byte it's a string.  It would mean
> > > breaking from the convention of using the "Apple_SVR2_UNIX" type for
> > > Linux partitions, but that really is just a convention as far as I know.
> >
> > Perhaps the PPC Linux developers and the Linux RAID developers should
> > get together on this and make some decisions so as to make it happen.
> >
> 
> I personally think auto-detect is the wrong approach and have no
> desire to extend it to other partition types (I cannot remove it from
> DOS partitions as that breaks back-compatability).
> Just use "md=..."

Ok.

Friendly,

Sven Luther
