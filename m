From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Save to use spindown?
Date: Sun, 22 Jan 2006 02:11:26 -0500
Message-ID: <200601220711.k0M7BUq22159@www.watkins-home.com>
References: <Pine.LNX.4.44.0601220102220.24057-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0601220102220.24057-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mark Hahn' <hahn@physics.mcmaster.ca>, 'John Hendrikx' <hjohn@xs4all.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

During a start and stop the disk's heads touch the surface.
At speed the heads glide on a cushion of air, and don't touch the surface.
AFAIK, the heads and surface don't wear while in use.

Also, if disks are anything like light bulbs, they will fail during start.
I have never seen a light bulb fail while on, only during on/off cycles.

I have seen disks go bad while in use.  But more often I see disks that were
fine, until the power is cycled.

Guy

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Mark Hahn
} Sent: Sunday, January 22, 2006 1:12 AM
} To: John Hendrikx
} Cc: linux-raid@vger.kernel.org
} Subject: Re: Save to use spindown?
} 
} > of my drives at the moment are below 10 start-stop cycles, even though
} > the array is only used very lightly for a few hours every day.
} 
} but my point was that "very lightly" doesn't tell you how many start/stop
} cycles.  if the spindown timeout is less than ~10 minutes, you _could_
} hit 50K cycles over 3 years, even assuming only 8 hrs/day.  I'd feel
} uncomfortable coming within a factor of 2 of the start/stop rating...
} 
} > > I don't believe ext3 will generate journal forces unless you do
} something
} > > that generates data or journal IO.  for instance, atime updates are
} often
} > > overlooked here.  I generally turn atime stuff off anyway.
} > >
} > But accessing the drive will spin it up anyway, so why would it be
} > prudent to turn atime off (apart from the fact that it is often not
} > needed anyway)?
} 
} but reading a cached file will update its atime.  with fileservers
} commonly
} in the multi-GB range, many files are cached...
} 
} regards, mark hahn.
} 
} -
} To unsubscribe from this list: send the line "unsubscribe linux-raid" in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html

