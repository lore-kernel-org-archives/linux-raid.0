From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Remote NAS
Date: Sun, 27 Sep 2009 15:19:09 -0500
Message-ID: <20090927201849401.FXKG6584@cdptpa-omta02.mail.rr.com>
References: <20090923161045.GD9409@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090923161045.GD9409@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > > You have two drives in RAID10 currently, and you want to go
> > > to four.
> > > Are you meaning to increase the capacity as well or do you
> > > just want the
> > > two remote drives to be a mirror of your current two
> > > drives?
> >
> > Both more capacity, and remote storage.
> >
> Okay, so you want the local drives to be (effectively) a RAID-0, and
> then mirrored to the remote drives?
> 
> >
> > > > Needless to say I'd like performance to be good, but
> > > that's starting
> > > > to look hopeless.
> > > >
> > > I'd recommend getting two smaller drives, and having two
> > > separate
> > > mirrored pairs - the smaller array for the OS and database
> > > and the
> > > larger one for recording.  Keep one of each size
> > > within the HTPC and one
> > > of each in the garage.  You can also use the
> > > write-mostly option to make
> > > the kernel read from the local drives where possible.
> >
> > But what I'm saying there doesn't seem to be a way in mdadm to specify
> > --one side-- of the mirror here, and the other side, there.
> >
> I've no idea what you mean here.  You specify two block devices for the
> mirror - what difference does it make where (or what) they are?  And if

	Well, he doesn't want to wind up with both a primary copy and a
mirror copy of any of the drive elements in one physical location.

> you want RAID10 then (in the create order) drives 0 and 2 are local and
> 1 and 3 remote.

	In his situation (assuming he doesn't take my advice and separate
the remote system entirely), wouldn't he be better served to create a RAIDn
array on both systems and then create a RAID1 from the local and NAS array
with the write mostly option?

