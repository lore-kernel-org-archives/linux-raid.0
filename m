From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] mdadm 2.5 (Was: ANNOUNCE: mdadm 2.5 - A tool for managing
 Soft RAID under Linux)
Date: Thu, 1 Jun 2006 11:22:09 +1000
Message-ID: <17534.16705.903525.672433@cse.unsw.edu.au>
References: <20060531171801.56459.qmail@web50208.mail.yahoo.com>
	<447E1574.60908@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Eyal Lebedinsky on Thursday June 1
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday June 1, eyal@eyal.emu.id.au wrote:
> Alex Davis wrote:
> >>short swap16(short in)
> >>{
> >>       int i;
> >>       short out=0;
> >>       for (i=0; i<4; i++) {
> >>               out = out<<8 | (in&255);
> >>               in = in >> 8;
> >>       }
> >>       return out;
> >>}
> > 
> > Shouldn't that be "for (i=0; i<2; i++) {..." ? 

Well, yes... if you want the code to actually work, I guess that might
be an improvement....


> 
> In which case, do we really need this complexity rather than
> a clear swap, e.g.
> 	return (short)(((in&0x0ff)<<8) | ((in>>8)&0x0ff))

What I like about the above is that the difference between swap16,
swap32 and swap64 is just one number.  In this case I think clarity
and maintainability are much more important than efficiency.

Thanks for the comment,
NeilBrown
