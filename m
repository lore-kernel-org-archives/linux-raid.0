From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: Read algorithm-raid1/raid10
Date: Tue, 18 Jan 2011 16:01:49 +0100
Message-ID: <20110118150149.GB602@www2.open-std.org>
References: <AANLkTin+Kd+RfuEUyBrvnunBbQ+2uzzdy57Xy-LEJ_6J@mail.gmail.com> <AANLkTi=ULecH9g9Mt+axPY_KsyvZU=KdawphxpJ2kDGi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTi=ULecH9g9Mt+axPY_KsyvZU=KdawphxpJ2kDGi@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jan 18, 2011 at 12:00:49PM -0200, Roberto Spadim wrote:
> like this patch (a long time ago)
> http://www.spinics.net/lists/raid/msg30003.html
> 
> 
> 2011/1/18 Roberto Spadim <roberto@spadim.com.br>:
> > hi guys, could we implement a load_balance read algorithm for SSD?
> > nearest head isn't as fast as round robin for ssd.
> > i'm talking about raid1 (raid10 too)
> > what's my problem?
> > as i can see, raid0 is faster than raid1
> > for example:
> > two disks raid0 is faster than
> > two disks raid1.
> >
> > why?
> > nearest head
> > instead of a balanced read algorithm (like raid0) the nearest head
> > make raid1 use only one disk for searchs where we could use two disks
> > (like raid0)
> >
> > could we implement a round robin for ssd? and make raid1 as fast as
> > raid0 for ssd?
> > i didn't tested the raid10 algorithm yet.
> > thanks a lot.

This should only be in use for SSDs. For disks it would be a waste of IO
bandwidth. How do we detect whether it is a SSSD.
Another way to accomplish an improvement os to use the offset layout of
raid10.

best regards
Keld
