From: CaT <cat@zip.com.au>
Subject: Re: help wanted - 6-disk raid5 borked: _ _ U U U U
Date: Mon, 17 Apr 2006 10:55:54 +1000
Message-ID: <20060417005554.GS19700@zip.com.au>
References: <62b0912f0604161419udee8ff2tf0861bc2f6e8e304@mail.gmail.com> <17474.51121.178492.61143@cse.unsw.edu.au> <62b0912f0604161617k31eedfaev8778b299e4a65b4b@mail.gmail.com> <17474.54168.331725.412456@cse.unsw.edu.au> <17474.55148.614834.999648@fisica.ufpr.br> <20060417002513.GR19700@zip.com.au> <17474.58490.889579.654449@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17474.58490.889579.654449@fisica.ufpr.br>
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Apr 16, 2006 at 09:42:34PM -0300, Carlos Carvalho wrote:
> CaT (cat@zip.com.au) wrote on 17 April 2006 10:25:
> >Not necessarily. You probably have something like (say) 200GB of data
> >stripes across that disk. That one read error may affect just one or a
> >few which means there's a whole buttload of data that could be retrieved
> >still. Perhaps setting the entire raid array read-only on such an error
> >would be better? That makes it a choice between potentially losing
> >everything and having writes and some reads fail as you have a mild
> >stroke trying to get another drive in on things. Put the drive in, let
> >the array do the best it can to restore things, fail the bad drive, put
> >another disk in, have it come up fully and the fsck it good.
> 
> You want the array to stay on and jump here and there getting the
> stripes from wherever it can, each time from a different set of disks.
> That's surely nice but I think it's too much to ask...

That would be nice but even just setting it read-only and if it fails a
read done as it normally would it just fails it and moves on. Nothing
special but it might let you recover a vast chunk of your data. Then you
can decide if what is lost is worth crying over. That's still better
then complete data loss.

Hope that makes sense. :)

-- 
    "To the extent that we overreact, we proffer the terrorists the
    greatest tribute."
    	- High Court Judge Michael Kirby
