From: Marc MERLIN <marc@merlins.org>
Subject: Re: md raid5 on top of dmcrypt, or dmcrypt on top of md raid5?
Date: Sun, 21 Feb 2016 16:44:36 -0800
Message-ID: <20160222004436.GH5512@merlins.org>
References: <20160211162959.GG13969@merlins.org>
 <alpine.DEB.2.02.1602121020570.11524@uplift.swm.pp.se>
 <wrfja8n62e0c.fsf@redhat.com>
 <20160212190700.GQ13969@merlins.org>
 <22206.14606.181359.676881@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <22206.14606.181359.676881@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>, Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 12, 2016 at 02:57:02PM -0500, John Stoffel wrote:
> 
> Marc,
> 
> Did you look into lvcache instead of bcache?  The problem with bcache
> is that you can't (as I understand it) remove it from a live volume,
> while you can with lvache.

I've used LVM2 in the past, and I'm not a big fan of the extra layers
(and back then clear slowdowns).
To be honest, I won't be needing to remove a cache from a volume while
it's running, so that's not too much a concern for me.

I did a bit of reading on one vs the other, and dmcache seemed to have
more users behind it and been around longer, so I went with that.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
