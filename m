From: NeilBrown <neilb@suse.de>
Subject: Re: New device for RAID array
Date: Fri, 13 May 2011 15:50:31 +1000
Message-ID: <20110513155031.4ceb0686@notabene.brown>
References: <20110513112119.79e67ceb@notabene.brown>
	<8E.76.28813.873CCCD4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8E.76.28813.873CCCD4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 13 May 2011 00:37:02 -0500 "Leslie Rhorer" <lrhorer@satx.rr.com>
wrote:

> > -----Original Message-----
> > From: NeilBrown [mailto:neilb@suse.de]
> > Sent: Thursday, May 12, 2011 8:21 PM
> > To: lrhorer@satx.rr.com
> > Cc: linux-raid@vger.kernel.org
> > Subject: Re: New device for RAID array
> > 
> > On Thu, 12 May 2011 19:59:01 -0500 "Leslie Rhorer" <lrhorer@satx.rr.com>
> > wrote:
> > 
> > >
> > > I read through the man page for mdadm a couple of times and did not spot
> > how
> > > to do this.  I currently have a RAID array that I need to upgrade from
> > 1T
> > > drives to 3T drives.  To accomplish this, I intend to create a larger
> > array,
> > > but with fewer spindles, and then rsync the contents of the old array to
> > the
> > > new.  Once I am done, I then want to stop the old array (/dev/md0) and
> > start
> > > up the new array under /dev/md0.  Do I have to stop the array and then
> > > re-create it with all the same parameters, except the device target?
> > 
> > For v0.90:  --update=super-minor
> > For v1.x    --update=name
> 
> 	Um, it will be a 1.2 array, so I take it if the current array is
> /dev/md0, named RAID-Server:0 from /dev/sd[a-n], and the new array is
> something like /dev/md4, named RAID-Server:4 from sd[q-x], then I stop both
> arrays and enter 
> 
> mdadm --assemble /dev/md0 /dev/sd[q-x] --update=name
> 
> 	Correct?  Of course then I need to update /etc/mdadm/mdadm.conf and
> run `update-initrd`.

Yes, though you don't really need to change the name on the array unless you
particularly want to.  Just changing mdadm.conf is enough to get it assembled
as the "right" place.

I think the command you give will store "RAID-Server:0" in the metadata
assuming 'hostname' or HOMEHOST in mdadm.conf is RAID-Server, but if it
doesn't you can experiment with explicitly setting --name and --hostname on
the command line.

NeilBrown

