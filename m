From: adfas asd <chimera_god@yahoo.com>
Subject: Re: Remote NAS
Date: Wed, 23 Sep 2009 08:44:41 -0700 (PDT)
Message-ID: <840059.86859.qm@web38806.mail.mud.yahoo.com>
References: <20090923152927.GC9409@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090923152927.GC9409@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Wed, 9/23/09, Robin Hill <robin@robinhill.me.uk> wrote:
> > My goal is to have two large drives in the HTPC and
> two out in the
> > garage NASed, in RAID10 so that if my HTPC is stolen
> or there's a fire
> > I'll still have my data.  But no one here seems
> to know how to specify
> > the HTPC drives as one side of the mirror and the
> garage drives as the
> > other.  
> > 
> You have two drives in RAID10 currently, and you want to go
> to four.
> Are you meaning to increase the capacity as well or do you
> just want the
> two remote drives to be a mirror of your current two
> drives?

Both more capacity, and remote storage.


> > Needless to say I'd like performance to be good, but
> that's starting
> > to look hopeless.
> > 
> I'd recommend getting two smaller drives, and having two
> separate
> mirrored pairs - the smaller array for the OS and database
> and the
> larger one for recording.  Keep one of each size
> within the HTPC and one
> of each in the garage.  You can also use the
> write-mostly option to make
> the kernel read from the local drives where possible.

But what I'm saying there doesn't seem to be a way in mdadm to specify --one side-- of the mirror here, and the other side, there.

Thanks for the tip on write-mostly.



      
