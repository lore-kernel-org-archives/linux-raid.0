From: "Al Boldi" <a1426z@gawab.com>
Subject: RE: Multiplexed RAID-1 mode
Date: Mon, 1 Aug 2005 17:12:09 +0300
Message-ID: <200508011412.RAA06326@raad.intranet>
References: <17133.41835.683675.621675@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17133.41835.683675.621675@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@cse.unsw.edu.au>
Cc: 'Gordon Henderson' <gordon@drogon.net>, linux-raid@vger.kernel.org, 'Jeff Breidenbach' <jeff@jab.org>
List-Id: linux-raid.ids

Neil Brown wrote: {
On Sunday July 31, a1426z@gawab.com wrote:
> 
> Multiplexing read/write requests would certainly improve performance 
> ala RAID-0 (-offset overhead).
> During reads the same RAID-0 code (+mirroring offset) could be used.
> During writes though, this would imply delayed mirroring.

But what exactly do you mean by 'delayed mirroring'?
Are you suggesting that the write request completes after only writing to
one mirror?  If so, which one?  Wouldn't this substantially reduce the value
of mirroring?
}

Think of it as a _smart_ resync running on idle.
Should be an option though!

--
Al

