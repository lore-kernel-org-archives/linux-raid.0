From: Mike Hardy <mhardy@h3c.com>
Subject: Re: [PATCH md ] Better handling of readerrors with raid5.
Date: Fri, 16 Sep 2005 09:53:48 -0700
Message-ID: <432AF89C.3040407@h3c.com>
References: <20050916125754.11044.patches@notabene> <1050916030157.11071@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1050916030157.11071@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


NeilBrown wrote:
> TESTERS WANTED!!  SEE BELOW...
> 
> This patch changes the behaviour of raid5 when it gets a read error.
> Instead of just failing the device, it tried to find out what should
> have been there, and writes it over the bad block.  For some
> media-errors, this has a reasonable chance of fixing the error.
> If the write succeeds, and a subsequent read succeeds as well, raid5
> decided the address is OK and conitnues.
> 
> I have tested this using the 'faulty' md personality, but it would be
> really good to test it with real disks that have real errors.  If
> anyone has such drives in a cupboard (or even in a computer) and would
> be willing to give this a try, I would really appreciate it.


Oh, this makes me so happy. Thank you thank you thank you.

I regret that I just yesterday sent a drive back with spontaneously
growing read errors that were fixable yet would pop up in another spot.

Does this apply cleanly to 2.6.13 though? Does it require any special
tool support or superblock (version of mdadm, etc)? I could put it on
one of my non-mission-critical rigs and let it run for a while.

-Mike
