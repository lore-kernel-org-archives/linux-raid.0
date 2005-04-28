From: Tom Coughlan <coughlan@redhat.com>
Subject: Re: [PATCH] secure write for RAID1
Date: Thu, 28 Apr 2005 08:34:30 -0400
Message-ID: <1114691670.11434.2599.camel@bianchi.boston.redhat.com>
References: <1toqj2-sjd.ln1@news.it.uc3m.es>
	 <17007.1524.476174.515614@cse.unsw.edu.au>
	 <20050427060531.GH4431@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050427060531.GH4431@marowsky-bree.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2005-04-27 at 02:05, Lars Marowsky-Bree wrote:
> On 2005-04-27T13:24:36, Neil Brown <neilb@cse.unsw.edu.au> wrote:
> 
> > On Saturday April 23, ptb@lab.it.uc3m.es wrote:
> > > This patch (completely untested of course - what, me?) makes RAID1 write
> > > to all components of a raid-1 array, else return error to the write
> > > attempt, when one component cannot be written.
> > I don't understand why or when you would want this.
> > 
> > This wouldn't just return an error to the application if the write
> > wasn't completely safe.  It would cause the filesystem to switch to
> > read-only very quickly and make your machine un-usable.  Is that
> > really what you want??
> 
> Databases sometimes want this (also for replication).
> 
> They'd rather fail than potentially lose a committed transaction, and to
> that end they require that the data be written to at least two disks; ie
> they want the data to be able to withstand at least one failure.  We've
> had such a request from a big database vendor for drbd too.
> 
> (This however is a great application for >2 mirrors and a write quorum
> of two, though.)

As a further optimization, when multi-site replication is required, some
would like to require at least one successful write to each site. Maybe
a "site" attribute for RAID set members is in the future. 

Tom

