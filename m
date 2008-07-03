From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: new bottleneck section in wiki
Date: Thu, 3 Jul 2008 07:28:57 -0500
Message-ID: <cccedfc60807030528t4724cbdhe5334ed0acefc536@mail.gmail.com>
References: <20080702155603.GA11156@rap.rap.dk>
	 <A20315AE59B5C34585629E258D76A97CF1FCCC@34093-C3-EVS3.exchange.rackspace.com>
	 <20080702190337.GA2311@sewage.raw-sewage.fake>
	 <cccedfc60807021210y2b47917ap227e46fd1666755e@mail.gmail.com>
	 <20080702193527.GA13186@rap.rap.dk>
	 <cccedfc60807021238w2fdb2a60i5d6c4c8a901071e2@mail.gmail.com>
	 <A20315AE59B5C34585629E258D76A97CF200D3@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97CF200D3@34093-C3-EVS3.exchange.rackspace.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: Keld J?rn Simonsen <keld@dkuug.dk>, Matt Garman <matthew.garman@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Not true, Jon.  The test above was limited by the amount of data that a
> single drive head can push to the controller with 100% sequential reads
> of 64KB.  You can't say anything about chipset bottlenecks, because you
> haven't created a condition where the chipset could even be a
> bottleneck.  I/O is constrained by the disk drives.
>
> Now, if you attached industrial class SSDs that operate at media speeds
> with access time in the NS range, then you could be in a position to
> benchmark chipset performance.

Well, that's true. However, perhaps I mis-spoke. What I was intending
on doing is showing that the chipset was /not/ the limiting factor
here, not checking it's maximum speed, but rather given what I know
about the drives individually, and then what the rates are with all
drives cookin', then I can say, "Well, at least the chipset or bus
aren't getting in the way." Note that I also added "or bus" to my
statement. Would you say that this statement is more accurate or am I
getting the terminology wrong, again?


-- 
Jon
