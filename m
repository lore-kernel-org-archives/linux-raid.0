From: adfas asd <chimera_god@yahoo.com>
Subject: Re: Remote NAS
Date: Wed, 23 Sep 2009 07:52:59 -0700 (PDT)
Message-ID: <9510.91067.qm@web38801.mail.mud.yahoo.com>
References: <20090923075710.GA9409@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090923075710.GA9409@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--- On Wed, 9/23/09, Robin Hill <robin@robinhill.me.uk> wrote:
> > Commercial flagging is writing like hell to the array,
> according to
> > iotop.  I don't know how else to assess what's
> going on.  The drives
> > are constantly hammering, and my Myth menu moves get
> very slow during
> > flagging, even with the latest 2TB disk drives and
> RAID10.
> > 
> Are you transcoding as well?  The flagging itself
> shouldn't write, but
> if you're transcoding as well (to cut the commercials) then
> it will have
> to write.  And slow menu moves would suggest
> database/CPU holdups -
> there should be no need to read from the recordings disk
> (actually, it
> may have to check the file exists, but that's it). 
> You didn't say
> whether your database is on the array or not (if you're
> booting from the
> array then I'd guess so though).

Not transcoding at the same time, just the standard commercial flagging.  The drive light is constantly on.  CPU is pretty busy (3GHz) reaching 180% when simultaneously flagging 2 videos.

The database in in the / partition of the array, and the videos are in the /home partition on it.  No idea why the array is so busy.


> If your aim is to improve performance then I'd recommend
> using a single
> (relatively small) drive for the main OS and database, and
> then one (or
> more) drives for the recordings.

My goal is to have two large drives in the HTPC and two out in the garage NASed, in RAID10 so that if my HTPC is stolen or there's a fire I'll still have my data.  But no one here seems to know how to specify the HTPC drives as one side of the mirror and the garage drives as the other.  

Needless to say I'd like performance to be good, but that's starting to look hopeless.



      
