From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Partitioned raid and major number
Date: Mon, 1 Mar 2004 11:16:03 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16450.32963.829675.526061@notabene.cse.unsw.edu.au>
References: <20040225145624.GA1513@cistron.nl>
	<16445.12026.812778.621025@notabene.cse.unsw.edu.au>
	<20040226215144.GC11831@drinkel.cistron.nl>
	<16446.36226.591283.495194@notabene.cse.unsw.edu.au>
	<16446.39583.968782.41221@notabene.cse.unsw.edu.au>
	<20040227165614.GO23988@traveler.cistron.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Miquel van Smoorenburg on Friday February 27
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday February 27, miquels@cistron.nl wrote:
> On 2004.02.27 02:17, Neil Brown wrote:
> > On Friday February 27, neilb@cse.unsw.edu.au wrote:
> > > 
> > > Right.  I missed a bit in the patch.
> > > (I assume you are still wanting to boot off /dev/sda until you copy
> > > the data into /dev/md/d0p* - then you will use root=/dev/md_d0p1)
> > 
> > Sorry, that patch was wrong.
> > This one, ontop of the original patch, works for me (I finally got
> > around to testing it).
> 
> Yes, it works! Great.
> 
> Now how to enable RAID1 on an existing disk... I hoped that I could create
> an array with /dev/sda and /dev/sdb, with /dev/sdb marked as failed-disk.
> Because initializing a RAID1 array with just one working disk doesn't
> destroy the existing contents of the disk, right ? (I kept the last few
> MB of the disk as free space for the raid superblock).
> 
> Unfortunately the current tools (or the kernel) doesn't let me do that
> (/dev/sda is busy).

Yep.  Currently it isn't really possible while sda is mounted.  
You need to boot off some other media and create the array there.

You are right: creating a raid1 with just one working disk doesn't
destroy existing contents - except for last 128K or so.

> 
> Two more minor issues - one, if partitioned MD is on (/dev/md/d0 etc)
> the standard /dev/md0 device doesn't work anymore. For accessing the whole
> device (management purposes / tools) shouldn't both /dev/md0 and
> /dev/md/d0 open the same device ?

No - they are completely different devices.  Making them appear as one
device has all sorts of problems relating to confusing bits of code
that think they have exclusive access.  The idea as appealing but
wasn't worth the effort.



> 
> Two, shouldn't raid=partitionable md=d0,/dev/sda,/dev/sdb simply be
> md=d0,/dev/sda,/dev/sdb,partitionable ? You could even leave out the 'd'
> then and make it md=0,/dev/sda,/dev/sdb,partitionable. Together with
> (one) this would make a bit more sense.

no.
   raid=partitionable
and
   md=d0,.....
are related, but mean substantially different things.  You normally
only need one of these, not both.

  raid=partitionable
means that any auto-detected (using partition type 0xfd) arrays are
assembled as partitionable.  This does not apply to you at all because
you are not making arrays out of partitions.

 md=d0,......
assembles an array from explicit devices and a partitionable array.

NeilBrown
