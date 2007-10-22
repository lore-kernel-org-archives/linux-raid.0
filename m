From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: Re: very degraded RAID5, or increasing capacity by adding discs
Date: Mon, 22 Oct 2007 11:03:01 +0200
Message-ID: <20071022090300.GA22588@apartia.fr>
References: <20071008211313.6cd8bbb5@absurd> <470AB496.5010406@msgid.tls.msk.ru> <18186.62585.7261.178442@notabene.brown> <470B4E82.6010102@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <470B4E82.6010102@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 09, 2007 at 01:48:50PM +0400, Michael Tokarev wrote:
> 
> There still is - at least for ext[23].  Even offline resizers
> can't do resizes from any to any size, extfs developers recommend
> to recreate filesystem anyway if size changes significantly.
> I'm too lazy to find a reference now, it has been mentioned here
> on linux-raid at least this year.  It's sorta like fat (yea, that
> ms-dog filesystem) - when you resize it from, say, 501Mb to 999Mb,
> everything is ok, but if you want to go from 501Mb to 1Gb+1, you
> have to recreate almost all data structures because sizes of
> all internal fields changes - and here it's much safer to just
> re-create it from scratch than trying to modify it in place.
> Sure it's much better for extfs, but the point is still the same.

I'll just mention that I once resized a multi-Tera ext3 filesystem and 
it took 8hours +, a comparable XFS online resize lasted all of 10 
seconds! 
