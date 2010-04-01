From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Problems with RAID 6 across 15 disks
Date: Fri, 2 Apr 2010 01:04:37 +0200
Message-ID: <20100401230437.GA5067@lazy.lzy>
References: <4BB49E4D.1090809@maxeaves.co.uk>
 <4BB4A461.5030704@redhat.com>
 <4BB4A89F.7030707@maxeaves.co.uk>
 <20100402074325.3ce34e8f@notabene.brown>
 <20100401224644.GA2455@lazy.lzy>
 <1270162736.24051.0.camel@travelmate.workshop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1270162736.24051.0.camel@travelmate.workshop>
Sender: linux-raid-owner@vger.kernel.org
To: Jools Wills <jools@oxfordinspire.co.uk>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Neil Brown <neilb@suse.de>, max@maxeaves.co.uk, linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

Hi,

> > but since it is not possible to correct those errors,
> > there is no point in doing it... :-)
> 
> Well it can. It can try and rewrite the block based on the data from the
> other disks, and if the drive needs to, it can remap the bad block.

you might be unaware of the repeated neverending
discussions about this topic.

It is *possible* to do it, but, as of today, it
cannot do it.

I mean, there is no functionality, in the RAID-6, to
detect and correct those errors using the available
double parity.

Consider that the RAID check returns only how many
mismatch are present, not where they are, i.e. on
which disks.

bye,

-- 

piergiorgio
