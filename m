From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: which raid level gives maximum overall speed? (raid-10,f2 vs. raid-0)
Date: Tue, 5 Feb 2008 23:55:34 +0100
Message-ID: <20080205225534.GA32053@rap.rap.dk>
References: <20080130192133.17b254bf@szpak> <20080130220007.GG20173@rap.rap.dk> <20080130233639.5d46b044@szpak> <20080131015506.GB6617@rap.rap.dk> <20080205161036.GA30326@rap.rap.dk> <alpine.DEB.1.00.0802051152500.9790@p34.internal.lan> <20080205200423.GB17621@rap.rap.dk> <alpine.DEB.1.00.0802051726510.10352@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0802051726510.10352@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 05, 2008 at 05:28:27PM -0500, Justin Piszcz wrote:
> 
> 
> >Could you give some figures?
> 
> I remember testing with bonnie++ and raid10 was about half the speed 
> (200-265 MiB/s) as RAID5 (400-420 MiB/s) for sequential output, but input 
> was closer to RAID5 speeds/did not seem affected (~550MiB/s).

Impressive. What levet of raid10 was involved? and what type of
equipment, how many disks? Maybe the better output for raid5 could be
due to some striping - AFAIK raid5 will be striping quite well, and 
writes almost equal to reading time indicates that the writes are
striping too.

best regards
keld
