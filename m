From: Mattias Wadenstein <maswan@acc.umu.se>
Subject: Re: [PATCH md ] Better handling of readerrors with raid5.
Date: Tue, 11 Oct 2005 16:31:52 +0200 (MEST)
Message-ID: <Pine.GSO.4.62.0510111605370.24146@shaka.acc.umu.se>
References: <20050916125754.11044.patches@notabene> <1050916030157.11071@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1050916030157.11071@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 16 Sep 2005, NeilBrown wrote:

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

I have been trying for the last couple of weeks on a batch of drives[1] 
that are known to now and then pop up such errors, but I've so far only 
managed to find two drives with real, permanent, failure modes. I don't 
know if that's just because I haven't been looking hard enough, or that 
the disks have started to behave though.

On the other hand, it does seem stable, I still have all my [test] data. 
It managed to properly fail the broken disk and restripe onto a hot spare, 
but I have no good observations on fixable media errors.

/Mattias Wadenstein

[1]: 3 4-drive raid5s with a hot spare each
