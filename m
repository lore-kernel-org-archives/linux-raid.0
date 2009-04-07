From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: RAID halting
Date: Tue, 7 Apr 2009 14:20:23 -0400
Message-ID: <87f94c370904071120p2fab5d35ifd4052479159a74e@mail.gmail.com>
References: <49DA677C.2080009@hp.com>
	 <20090407174723.LMYU4586.cdptpa-omta02.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090407174723.LMYU4586.cdptpa-omta02.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Leslie,

I don't know if it is related, but if you have an hour or so you
should read bugzilla 12309.  There are 290 comments and tons of
significant attachments.

http://bugzilla.kernel.org/show_bug.cgi?id=12309

It's about very high latency experienced by users while a large i/o
activity is happening in the background.

I don't know if the background tasked is also being slowed down like
it is for you.

Greg
-- 
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
