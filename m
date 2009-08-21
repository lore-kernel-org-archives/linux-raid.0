From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: RAID10 Layouts
Date: Fri, 21 Aug 2009 22:42:34 +0200
Message-ID: <20090821204234.GA3683@rap.rap.dk>
References: <200908210627.06241.Info@quantum-sci.net> <87ljldce33.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87ljldce33.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Info@quantum-sci.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Aug 21, 2009 at 06:43:28PM +0200, Goswin von Brederlow wrote:
> Info@quantum-sci.net writes:
> 
> > Hello list,
> >
> > Researching RAID10, trying to learn the most advanced system for a 2
> > SATA drive system.  Have two WD 2TB drives for a media computer, and
> > the most important requirement is data redundancy.  I realize that
> > RAID is no substitute for backups, but this is a backup for the
> > backups and the purpose here is data safety.  The secondary goal is
> > speed enhancement.  It appears that RAID10 can give both.
> >
> > First question is on layout of RAID10.  In studying the man pages it
> > seems that Far mode gives 95% of the speed of RAID0, but with
> > increased seek for writes.  And that Offset retains much of this
> > benefit while increasing efficiency of writes.  What should be the
> > preference, Far or Offset?  Are they equally as robust?
> 
> All raid10 layouts offer the same robustness. Which layout is best for
> you really depends on your use case. Probably the biggest factor will
> be the average file size. My experience is that with large files the
> far copies do not cost noticeable write speed while being twice as
> fast reading as raid1.

The file system elevator makes up for the Far write head movement.

> > How safe is the data in Far or Offset mode?  If a drive fails, will
> > a complete, usable, bootable system exist on the other drive?
> > (These two are the only drives in the system, which is Debian
> > Testing, Debian kernel 2.6.30-5) Need I make any special Grub
> > settings?
> 
> I don't think lilo or grub1 can boot from raid10 at all with offset or
> far copies. With near copies you are identical to a simple raid1 so
> that would boot.

there is a howto on setting up a system, that can continue runnig, if one 
disk fails at
http://linux-raid.osdl.org/index.php/Preventing_against_a_failing_disk

> > How does this look:
> > # mdadm --create /dev/md0 --level=raid10 --layout=o2 --metadata=1.2 --chunk=64 --raid-disks=2 missing /dev/sdb1
> 
> On partitions it is save to use 1.1 format. Saves you 4k. Jupey.
> 
> You should play with the chunksize though and try with and without
> bitmap and different bitmap sizes. Bitmap costs some write performance
> but it greatly speeds up resyncs after a crash or temporary drive
> failure.

I would recommend a bigger chunk size. at least 256 kiB.

Best regards
keld
