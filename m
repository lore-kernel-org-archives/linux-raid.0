From: seth vidal <skvidal@phy.duke.edu>
Subject: Re: Which raid card to buy for Sarge
Date: Wed, 31 Mar 2004 23:51:06 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1080795066.16499.15.camel@binkley>
References: <Pine.LNX.4.44.0403311442520.31572-100000@coffee.psychology.mcmaster.ca>
	 <406B9F3E.4020701@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <406B9F3E.4020701@wasp.net.au>
To: Brad Campbell <brad@wasp.net.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> One point. Hardware raid (and faux hardware raid) provides real hot swap with on-the-fly rebuilds.
> Linux software raid can't (yet).

umm. That's surprising. My software raid arrays running on dell
powervault 221s scsi boxes with adaptec 39160 controllers are
hotswappable and when I put in a new disk and add it to the array it
resyncs on the fly.

Are you just talking about ide-based raid?

-sv


