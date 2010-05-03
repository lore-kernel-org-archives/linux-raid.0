From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Questions about 4k sector drives
Date: Mon, 03 May 2010 16:19:47 -0400
Message-ID: <yq1bpcwpwkc.fsf@sermon.lab.mkp.net>
References: <4BD42B57.9000703@kusche.de> <1272206601.7734.4.camel@faldara>
	<4BDE0512.8070502@tmr.com>
	<x2v87f94c371005030630idaaad1e9ue3faff470bd318e1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <x2v87f94c371005030630idaaad1e9ue3faff470bd318e1@mail.gmail.com>
	(Greg Freemyer's message of "Mon, 3 May 2010 09:30:01 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Phillip Susi <psusi@cfl.rr.com>, Florian Kusche <flox@kusche.de>, linux-raid@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-raid.ids

>>>>> "Greg" == Greg Freemyer <greg.freemyer@gmail.com> writes:

Greg> In theory 4K physical sector drives with XP alignment will
Greg> eventually ship and possibly have already.

Well, that's a definite maybe :)

The 4K transition took much longer than anticipated and Vista and beyond
know how to query the drives for alignment.  So I'm guessing that we'll
only see 1-alignment via a jumper at this point.


Greg> I don't know it any those drives exist yet, or if they ever will.

I have a bunch, but obviously they are mostly prototypes.


Greg> mdadm should as well, not just blindly say 1MB is the magic
Greg> alignment point.  (ie. linux can do better than Win2008/Win2003
Greg> which simply disagree with each other on how to align.)

We're going with 1MB as default because that's the new storage industry
consensus.  It's a less formalized number than - say - IDEMA sector
counts, but it appears to have reached critical mass among the vendors.

And obviously we'll compensate if the storage device reports a different
alignment via the relevant ATA or SCSI knobs.

-- 
Martin K. Petersen	Oracle Linux Engineering
