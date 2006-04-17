From: CaT <cat@zip.com.au>
Subject: Re: help wanted - 6-disk raid5 borked: _ _ U U U U
Date: Mon, 17 Apr 2006 10:25:13 +1000
Message-ID: <20060417002513.GR19700@zip.com.au>
References: <62b0912f0604161419udee8ff2tf0861bc2f6e8e304@mail.gmail.com> <17474.51121.178492.61143@cse.unsw.edu.au> <62b0912f0604161617k31eedfaev8778b299e4a65b4b@mail.gmail.com> <17474.54168.331725.412456@cse.unsw.edu.au> <17474.55148.614834.999648@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17474.55148.614834.999648@fisica.ufpr.br>
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Apr 16, 2006 at 08:46:52PM -0300, Carlos Carvalho wrote:
> Neil Brown (neilb@suse.de) wrote on 17 April 2006 09:30:
>  >The easiest thing to do when you get an error on a drive is to kick
>  >the drive from the array, so that is what the code always did, and
>  >still does in many cases.
>  >It is arguable that for a read error on a degraded raid5, that may not
>  >be the best thing to do, but I'm not completely convinced.
> 
> I don't see how it could be different. If the array is degraded and
> one more disk fails there's no way to obtain the information, so the
> md device just fails like a single disk.

Not necessarily. You probably have something like (say) 200GB of data
stripes across that disk. That one read error may affect just one or a
few which means there's a whole buttload of data that could be retrieved
still. Perhaps setting the entire raid array read-only on such an error
would be better? That makes it a choice between potentially losing
everything and having writes and some reads fail as you have a mild
stroke trying to get another drive in on things. Put the drive in, let
the array do the best it can to restore things, fail the bad drive, put
another disk in, have it come up fully and the fsck it good.

At least this way you probably have less of a chance of losing the
entire array of data and who knows, only the 'less important' files
might be lost. :)

Anyway, my 2c. :)

-- 
    "To the extent that we overreact, we proffer the terrorists the
    greatest tribute."
    	- High Court Judge Michael Kirby
