From: Neil Brown <neilb@suse.de>
Subject: Re: Write intent bitmaps
Date: Fri, 19 Jun 2009 12:16:09 +1000
Message-ID: <19002.62697.475588.28776@notabene.brown>
References: <20090608021026139.GMOD14139@cdptpa-omta02.mail.rr.com>
	<18989.6010.582386.812296@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Carlos Carvalho on Monday June 8
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday June 8, carlos@fisica.ufpr.br wrote:
> 
>  >5. What happens if the bitmap is lost or the external drive fills up?
> 
> No idea.

If the bitmap is lost, it is just as though you didn't have a bitmap 
(or as though all the bits in the bitmap were set to one).

The drive filling up is not relevant.  When the bitmap is in a
separate file, the file is preallocated to be the right size.

> 
>  >If so, would ext2 probably be the best choice?
> 
> That's what the man page says. I find it strange since if it's a file
> the filesystem shouldn't matter. Neil?

The way that md writes to the bitmap file is not entirely portable
across different filesystems.  As the man page say,  it is known to
work for ext2 and ext3.  Either is a fine choice.
A new filesystem interface is being introduced in 2.6.31 as part of
the swap-over-NFS work.  I might end up using that to write to bitmap
files, as it has the right characteristics.  But that is very much in
the future.

NeilBrown
