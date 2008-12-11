From: "David Lethe" <david@santools.com>
Subject: RE: status of raid 4/5 disk reduce
Date: Wed, 10 Dec 2008 22:30:28 -0600
Message-ID: <A20315AE59B5C34585629E258D76A97C02FA1D78@34093-C3-EVS3.exchange.rackspace.com>
References: <493D8A95.2020700@mikebrancato.com> <493EDF02.5090500@redwax.co.uk>	 <A20315AE59B5C34585629E258D76A97C02F476F7@34093-C3-EVS3.exchange.rackspace.com>	 <20081209215149.GA21523@cthulhu.home.robinhill.me.uk> <7d86ddb90812091515m1e0ee2f9w95a86ca2b56a98fe@mail.gmail.com> <493FB2AC.7000902@redwax.co.uk> <494059A4.8050702@mikebrancato.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <494059A4.8050702@mikebrancato.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Brancato <mike@mikebrancato.com>, Alex Lilley <alex@redwax.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Michael Brancato
> Sent: Wednesday, December 10, 2008 6:07 PM
> To: Alex Lilley
> Cc: linux-raid@vger.kernel.org
> Subject: Re: status of raid 4/5 disk reduce
> 
> 
> > There is the very obvious use to reduce the number of drives but
> > ultimately have a larger array if the drives are all larger. And
> there
> > should be no issue with file system/lvm resizing as these can
> generally
> > grow on-line anyway.
> >
> > I appreciate that shrinking the size of the array and doing so onto
> less
> > disks is both an unlikely requirement and fraught with danger.
> Growing
> > the size of the array but to less disks is very useful indeed, which
> is
> > what I was getting at.
> 
> Hardware limitations is a good use case.  When I say reduce, I mean
> --grow -nX and not necessarily reducing the size of the array in the
> end.
> 
> >>>> This is a lot to ask for in terms of development, and creates
> extreme
> >>>> risk of data loss.
> >>>> First, you degrade /dev/md0, so any bad blocks or drive failures
> will
> >>>> cause catastrophic
> >>>> data loss, unless /dev/disk4 is used for mirroring in the
interim.
> 
> This is a standard fact of RAID45.  Any RAID45 with a failed drive is
> subject to these same concerns.  Isn't this true today with grow if
> replacing a 4x100GB array with 4x200GB by replacing one drive at a
> time?
> 
> >>>> Secondly, by removing that disk (for sake of argument, say each
> disk is
> >>>> 1TB. You go from 3TB usable data
> >>>> to 2TB.  Most likely, you need to resize the file system in place
> so it
> >>>> fits into 2TB.  You're probably booted
> >>>> onto md0 also, which makes it difficult.  Resizing a hot
> filesystem
> >>>> without scratch space??  If your file system
> >>>> can't be dynamically reduced, then no point worrying about md
> raid.
> 
> There are a lot of assumptions here about how the array is used,
> filesystem support, etc.  I'm not saying that in every situation this
> is
> ideal.  There are many situations where md0 is not the boot device,
md0
> is not the device to be contracted, and the filesystem supports either
> online or offline resizing.  Concerns about filesystem expansion or
> contraction (online or not) and array shrinking are mutually exclusive
> of one another and shrinking the size of the array is already
possible.
> 
> Neil Brown has previously responded to a comment on the topic at
> http://neil.brown.name/blog/20050727143147 in regards to a --shrink
> option.
> 
> Here are a few use cases:
> 
> Hardware limitations - Replacing 4x120GB size drives with 3x500GB
> drives.  This would involve replacing each 120GB disk with a 500GB one
> at a time and rebuilding each before reshaping the array to 3 drives
> and
> growing to use all space on the new drives.  This is especially useful
> on a system which cannot increase the number if drives it has (4 max),
> only capacity.
> 
> Drive failure - A developer, home user or SMB has a drive failure in
an
> array.  Due to money, time, shipping delays, etc, the user cannot
> replace the drive immediately and the drive is in a degraded state.
> The
> user shrinks the filesystem by 1 drive amount and shrinks the array to
> return to a optimal state in the array.  The array would return to a
> protected state in hours not days if waiting on a drive.
> 
> Flexibility - A user wishes to free a disk in an array which is
> oversized to use that disk elsewhere.
> 
> I hope this give a better understanding of the usefulness of reducing
> the amount of disks in a RAID45 array.
> --
> Mike Brancato, CISSP
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


  
Respectfully, go bother the LVM, jfs, ext, afs, and all the other file
system people.  You have zero chance of getting them on board to support
online file system shrinking without any guarantee of scratch space.
My advice is that you don't tell them you also want them to resize while
the md volume is being resized, and also don't tell them that the array
might be degraded.

If you want to copy 4x120 into 3x500 ... mount all the disks and COPY
the data.  If you are truly limited to 4 disks, and are too cheap to
spend $10-20 for another controller, after buying 1.5TB worth of disk
drives, then you really need to get your priorities in order.

David




