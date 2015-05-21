From: Jim Paris <jim@jtan.com>
Subject: Re: Data corruption after resizing partition, when using bitmaps
Date: Thu, 21 May 2015 01:58:11 -0400
Message-ID: <20150521055810.GA9889@psychosis.jim.sh>
References: <20150519141239.GA5309@psychosis.jim.sh>
 <20150520153104.7ac99de1@notabene.brown>
 <20150520063149.GA8346@psychosis.jim.sh>
 <20150521102444.6346dc5d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150521102444.6346dc5d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown wrote:
> On Wed, 20 May 2015 02:31:50 -0400 Jim Paris <jim@jtan.com> wrote:
> 
> > NeilBrown wrote:
> > > On Tue, 19 May 2015 10:12:40 -0400 Jim Paris <jim@jtan.com> wrote:
> > > 
> > > > I had a raid1 mirror consisting of big partitions on two disks.
> > > > The first disk was 2TB, partitioned like this:
> > > > 
> > > >   [--sda1(128M)--][-------sda2(~2T)--------------]
> > > > 
> > > > The second disk was 3TB, partitioned like this:
> > > > 
> > > >   [--sdb1(128M)--][-------sdb2(~3T)------------------------------------]
> > > > 
> > > > sda2 and sdb2 were part of the array, which was only ~2TB in size due
> > > > to the smaller disk.
> > > > 
> > > > I realized that I needed to add a BIOS boot partition to the 3TB disk,
> > > > so I removed sdb2 from the array, and repartitioned sdb like this:
> > > > 
> > > >   [--sdb1(128M)--][--sdb2(1M)--][-------sdb3(~3T)----------------------]
> > > > 
> > > > Then I added sdb3 to the array.  And lost all my data. :(
> > > > 
> > > > What happened was that the last sector of the big partition did not
> > > > change location.  So the metadata (0.90) at the end was still present.
> > > 
> > > This is one of the big reasons why 1.x was invented.
> > > 
> > > > Adding sdb3 to the array was considered a "re-add" because the UUID
> > > > and array sizes still matched the array, even though the partition
> > > > itself shrank.  And the resync was thus guided by an out-of-date
> > > > bitmap, which caused very little data to actually be written to sdb3,
> > > > so half the reads from the array started returning junk.  Once the
> > > > filesystem got involved, the result was rapid corruption.
> > > > 
> > > > If I had not been using write-intent bitmaps, everything would have
> > > > worked fine.  I only recently started using bitmaps, and never had any
> > > > problems with adjusting partitions like this before that.
> > > > 
> > > > Perhaps mdadm can be more careful here -- for example, maybe checking
> > > > the actual device size and not just the "used dev size" when
> > > > determining whether to trust the bitmap.
> > > 
> > > It is perfectly acceptable to have the various devices in an array of
> > > different sizes.  Unfortunately I don't think there is anything that mdadm
> > > can usefully do here.
> > > 
> > > Thanks for the report anyway,
> > > NeilBrown
> > 
> > Hi Neil,
> > 
> > Can we add u64 device_size to bitmap_super_t, and ensure that it
> > matches the actual current device size before trusting the bitmap?
> 
> Well .... we could, but the bitmap_super is currently the same on all
> devices.  This would  make it different.
> And if we a going to change the metadata, why not just convert from 0.90 to
> 1.0?

My thinking was that the extra field could be added to bitmap_super
automatically -- just start writing it now, but only use it to
determine bitmap validity if the current value is non-zero.  No
explicit user-visible conversion.

I see your point; it's a bit strange to change outdated stuff.  But I
also feel that if there's something mdadm could have done to prevent
my data loss, that's worth putting in there.

>  mdadm --stop /dev/mdXX
>  mdadm --assemble /dev/mdXX --update=metadata /dev/...list-of-devices....
> 
> You might need to remove the bitmap first, and add it back afterwards.

Cool.  Much simpler than what's currently listed in the wiki for that
conversion.

Thanks Neil.
xJim

> 
> NeilBrown


