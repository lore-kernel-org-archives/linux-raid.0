From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH md 006 of 6] Add write-behind support for md/raid1
Date: Mon, 15 Aug 2005 08:24:32 +1000
Message-ID: <17151.50336.645817.629042@cse.unsw.edu.au>
References: <20050811171720.10115.patches@notabene>
	<200508120922.52689.a1426z@gawab.com>
	<42FC92C6.7060604@steeleye.com>
	<200508130800.32901.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Al Boldi on Saturday August 13
Sender: linux-raid-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: Paul Clements <paul.clements@steeleye.com>, Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday August 13, a1426z@gawab.com wrote:
> >
> > WriteMostly is just a flag that tells us which devices will get the
> > write-behinds, and which will not. You'll be able to mix any
> > combination of WriteMostly devices and normal devices in a raid1.
> >
> 
> Yes, but doesn't WriteMostly imply ReadDelay?
> If so, doesn't that mean that WriteBehind is dependent on ReadDelay?

I'm not sure what you mean by "ReadDelay".
We never deliberately delay reads.  However some devices (e.g. network
connection to remote mirror) may have a higher read latency, and these
would be appropriate for WriteMostly.

As read-latency and write-latency are likely to go together, it seems
reasonable for WriteMostly and WriteBehind to go together.  Do you
disagree?

NeilBrown
