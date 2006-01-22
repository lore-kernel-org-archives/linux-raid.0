From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Save to use spindown?
Date: Sun, 22 Jan 2006 01:12:15 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0601220102220.24057-100000@coffee.psychology.mcmaster.ca>
References: <43D2E9A6.8000703@xs4all.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43D2E9A6.8000703@xs4all.nl>
Sender: linux-raid-owner@vger.kernel.org
To: John Hendrikx <hjohn@xs4all.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> of my drives at the moment are below 10 start-stop cycles, even though 
> the array is only used very lightly for a few hours every day.

but my point was that "very lightly" doesn't tell you how many start/stop
cycles.  if the spindown timeout is less than ~10 minutes, you _could_
hit 50K cycles over 3 years, even assuming only 8 hrs/day.  I'd feel 
uncomfortable coming within a factor of 2 of the start/stop rating...

> > I don't believe ext3 will generate journal forces unless you do something
> > that generates data or journal IO.  for instance, atime updates are often
> > overlooked here.  I generally turn atime stuff off anyway.
> >   
> But accessing the drive will spin it up anyway, so why would it be 
> prudent to turn atime off (apart from the fact that it is often not 
> needed anyway)?

but reading a cached file will update its atime.  with fileservers commonly
in the multi-GB range, many files are cached...

regards, mark hahn.

