From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: help wanted - 6-disk raid5 borked: _ _ U U U U
Date: Sun, 16 Apr 2006 21:42:34 -0300
Message-ID: <17474.58490.889579.654449@fisica.ufpr.br>
References: <62b0912f0604161419udee8ff2tf0861bc2f6e8e304@mail.gmail.com>
	<17474.51121.178492.61143@cse.unsw.edu.au>
	<62b0912f0604161617k31eedfaev8778b299e4a65b4b@mail.gmail.com>
	<17474.54168.331725.412456@cse.unsw.edu.au>
	<17474.55148.614834.999648@fisica.ufpr.br>
	<20060417002513.GR19700@zip.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060417002513.GR19700@zip.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

CaT (cat@zip.com.au) wrote on 17 April 2006 10:25:
 >On Sun, Apr 16, 2006 at 08:46:52PM -0300, Carlos Carvalho wrote:
 >> Neil Brown (neilb@suse.de) wrote on 17 April 2006 09:30:
 >>  >The easiest thing to do when you get an error on a drive is to kick
 >>  >the drive from the array, so that is what the code always did, and
 >>  >still does in many cases.
 >>  >It is arguable that for a read error on a degraded raid5, that may not
 >>  >be the best thing to do, but I'm not completely convinced.
 >> 
 >> I don't see how it could be different. If the array is degraded and
 >> one more disk fails there's no way to obtain the information, so the
 >> md device just fails like a single disk.
 >
 >Not necessarily. You probably have something like (say) 200GB of data
 >stripes across that disk. That one read error may affect just one or a
 >few which means there's a whole buttload of data that could be retrieved
 >still. Perhaps setting the entire raid array read-only on such an error
 >would be better? That makes it a choice between potentially losing
 >everything and having writes and some reads fail as you have a mild
 >stroke trying to get another drive in on things. Put the drive in, let
 >the array do the best it can to restore things, fail the bad drive, put
 >another disk in, have it come up fully and the fsck it good.

You want the array to stay on and jump here and there getting the
stripes from wherever it can, each time from a different set of disks.
That's surely nice but I think it's too much to ask...
