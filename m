From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: Re: Partitioned raid and major number
Date: Fri, 27 Feb 2004 17:56:14 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040227165614.GO23988@traveler.cistron.net>
References: <20040225145624.GA1513@cistron.nl> <16445.12026.812778.621025@notabene.cse.unsw.edu.au> <20040226215144.GC11831@drinkel.cistron.nl> <16446.36226.591283.495194@notabene.cse.unsw.edu.au> <16446.39583.968782.41221@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16446.39583.968782.41221@notabene.cse.unsw.edu.au> (from neilb@cse.unsw.edu.au on Fri, Feb 27, 2004 at 02:17:19 +0100)
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Miquel van Smoorenburg <miquels@cistron.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2004.02.27 02:17, Neil Brown wrote:
> On Friday February 27, neilb@cse.unsw.edu.au wrote:
> > 
> > Right.  I missed a bit in the patch.
> > (I assume you are still wanting to boot off /dev/sda until you copy
> > the data into /dev/md/d0p* - then you will use root=/dev/md_d0p1)
> 
> Sorry, that patch was wrong.
> This one, ontop of the original patch, works for me (I finally got
> around to testing it).

Yes, it works! Great.

Now how to enable RAID1 on an existing disk... I hoped that I could create
an array with /dev/sda and /dev/sdb, with /dev/sdb marked as failed-disk.
Because initializing a RAID1 array with just one working disk doesn't
destroy the existing contents of the disk, right ? (I kept the last few
MB of the disk as free space for the raid superblock).

Unfortunately the current tools (or the kernel) doesn't let me do that
(/dev/sda is busy).

Two more minor issues - one, if partitioned MD is on (/dev/md/d0 etc)
the standard /dev/md0 device doesn't work anymore. For accessing the whole
device (management purposes / tools) shouldn't both /dev/md0 and
/dev/md/d0 open the same device ?

Two, shouldn't raid=partitionable md=d0,/dev/sda,/dev/sdb simply be
md=d0,/dev/sda,/dev/sdb,partitionable ? You could even leave out the 'd'
then and make it md=0,/dev/sda,/dev/sdb,partitionable. Together with
(one) this would make a bit more sense.

I hope to figure out how to migrate an existing 1-disk setup to RAID1 on
a live machine over the weekend.

Mike.
