From: NeilBrown <neilb@suse.de>
Subject: Re: Bug#624343: linux-image-2.6.38-2-amd64: frequent message "bio
 too big device md0 (248 > 240)" in kern.log
Date: Mon, 2 May 2011 10:22:24 +1000
Message-ID: <20110502102224.7787d6bd@notabene.brown>
References: <20110427161901.27049.31001.reportbug@servo.factory.finestructure.net>
	<1304051980.3105.46.camel@localhost>
	<8739kyf53e.fsf@servo.factory.finestructure.net>
	<1304294457.2833.111.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1304294457.2833.111.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Jameson Graef Rollins <jrollins@finestructure.net>, 624343@bugs.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 02 May 2011 01:00:57 +0100 Ben Hutchings <ben@decadent.org.uk> wrote:

> On Sun, 2011-05-01 at 15:06 -0700, Jameson Graef Rollins wrote:
> > On Fri, 29 Apr 2011 05:39:40 +0100, Ben Hutchings <ben@decadent.org.uk> wrote:
> > > On Wed, 2011-04-27 at 09:19 -0700, Jameson Graef Rollins wrote:
> > > > I run what I imagine is a fairly unusual disk setup on my laptop,
> > > > consisting of:
> > > > 
> > > >   ssd -> raid1 -> dm-crypt -> lvm -> ext4
> > > > 
> > > > I use the raid1 as a backup.  The raid1 operates normally in degraded
> > > > mode.  For backups I then hot-add a usb hdd, let the raid1 sync, and
> > > > then fail/remove the external hdd. 
> > > 
> > > Well, this is not expected to work.  Possibly the hot-addition of a disk
> > > with different bio restrictions should be rejected.  But I'm not sure,
> > > because it is safe to do that if there is no mounted filesystem or
> > > stacking device on top of the RAID.
> > 
> > Hi, Ben.  Can you explain why this is not expected to work?  Which part
> > exactly is not expected to work and why?
> 
> Adding another type of disk controller (USB storage versus whatever the
> SSD interface is) to a RAID that is already in use.

Normally this practice is perfectly OK.
If a filesysytem is mounted directly from an md array, then adding devices
to the array at any time is fine, even if the new devices have quite
different characteristics than the old.

However if there is another layer in between md and the filesystem - such as
dm - then there can be problem.
There is no mechanism in the kernl for md to tell dm that things have
changed, so dm never changes its configuration to match any change in the
config of the md device.

A filesystem always queries the config of the device as it prepares the
request.  As this is not an 'active' query (i.e. it just looks at
variables, it doesn't call a function) there is no opportunity for dm to then
query md.

There is a ->merge_bvec_fn which could be pushed into service.  i.e. if
md/raid1 defined some trivial merge_bvec_fn, then it would probably work.
However the actual effect of this would probably to cause every bio created
by the filesystem to be just one PAGE in size, and this is guaranteed always
to work.  So it could be a significant performance hit for the common case.

We really need either:
 - The fs sends down arbitrarily large requests, and the lower layers split
   them up if/when needed
or
 - A mechanism for a block device to tell the layer above that something has
   changed.

But these are both fairly intrusive which unclear performance/complexity
implications and no one has bothered.

NeilBrown

