From: Neil Brown <neilb@suse.de>
Subject: Re: RAID MIA.  Again.  (Kinda.)
Date: Wed, 10 Mar 2010 06:49:09 +1100
Message-ID: <20100310064909.4ff1fc60@notabene.brown>
References: <ef2f0a4210283390480f4adbd9a547de.squirrel@webmail.jots.org>
	<20100305075016.51e98363@notabene.brown>
	<b305ada429c44b2b62b03c101f7ecf0a.squirrel@webmail.jots.org>
	<20100305123028.55a34c14@notabene.brown>
	<a65d84c03d315f1aea40641238f25625.squirrel@webmail.jots.org>
	<20100306073703.2e44d2f6@notabene.brown>
	<6efdda840bff85f8b8ec053808afa5dd.squirrel@webmail.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6efdda840bff85f8b8ec053808afa5dd.squirrel@webmail.jots.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ken D'Ambrosio <ken@jots.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 9 Mar 2010 09:43:48 -0500 (EST)
"Ken D'Ambrosio" <ken@jots.org> wrote:

> On Fri, March 5, 2010 3:37 pm, Neil Brown wrote:
> > mount /dev/md0 /somewhere
> >
> > ??
> 
> Sorry this took so long; I've been busy dying from Martian Death Flu. 
> So... I tried what you suggested.
> 
> And it worked.
> 
> WTF?!
> 
> How can you mount something that doesn't show a partition in fdisk?  I'm
> -very-, -very- confused here.  Grateful, yes, but confused.  Is this
> something I'm just not "getting?"

Yes, this something you are just "not getting", but it is very simple so
won't take a moment to explain.

A partition table is simply a description of how to divide a disk drive up
into smaller units.  In stead of 1 big device, you appear to have several
small devices.
You can create a filesystem on any of these things - the big device, or any
of the smaller devices.

You can use fdisk to divide /dev/sda up into /dev/sda1, /dev/sda2, etc, but
you don't have to.  You can "mkfs /dev/sda" if you like.
Similarly, you can devide /dev/md0 up into /dev/md0p1, /dev/md0p2, with
fdisk, but you don't have to.
Commonly, people use /dev/sda1 rather than /dev/sda, and
  /dev/md0 rather than /dev/md0p1.
But this is just common practice, not enforced (that it wasn't long ago
when /dev/md0p1 could not be created, but that isn't important here).

A partition table does add one byte of extra information - a partition type.
This is a hint as to what sort of thing is stored in the partition.  However
that hint is not widely used in Linux.  I think some installers use it to
automagically find 'swap' and maybe 'root', but that is about it.  For many
purposes the partition type can be ignored.

When you created your filesystem, you must have created it on /dev/md0, not
on a partition.

Hope it is all clear now.

NeilBrown


> 
> Thanks much, regardless, for the pointer -- don't know if I would ever
> have tried mounting it without a partition showing.
> 
> *confused but happy*
> 
> -Ken
> 
> 

