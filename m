From: Andrew Beresford <beezly@beezly.org.uk>
Subject: Re: raid1 oops in raid1_read_balance on Sparc64
Date: Fri, 26 Apr 2002 12:00:56 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020426110056.GC25225@monkey.beezly.org.uk>
References: <20020424231406.GD8249@monkey.beezly.org.uk> <15559.57163.613685.697556@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <15559.57163.613685.697556@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Antti Siipola <ansi@iki.fi>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

The problem has gone away compiling with 3.0.4 :)
Cheers,

Beezly

On Thu, Apr 25, 2002 at 08:49:47PM +1000, Neil Brown wrote:
> On Thursday April 25, beezly@beezly.org.uk wrote:
> > I've been trying to get my sparc64 machine to use raid1 but each time I
> > set up the md config with one good disk and one failed disk (so I can
> > get the data off the "failed" disk and into the md device before I do a
> > raidhotadd) I get the following oops (after ksymoops mangling)
> > 
> > The kernel is 2.4.19-pre7. md and raid1 are compiled as modules. If any more information is needed please don't hesitate to contact me.
> > 
> 
> That's two reports of this.  It looks to me very much like a compiler
> bug.   I'm not an export on Sparc assembler, but I've just been
> reading through the disassembly listing of read1_read_balance,
> and at least two things look wrong:
> 
> 0xc30 <raid1_read_balance+208>: sllx  %o2, 3, %g2 
> 0xc34 <raid1_read_balance+212>: add  %i1, 0x20, %g3
> 0xc38 <raid1_read_balance+216>: clr  [ %i5 + 0x3f0 ]
> 0xc3c <raid1_read_balance+220>: add  %g2, %o2, %g2
> 
> This is the only place that %o2 is used, and it is never
> initialised.
> 
> 0xbac <raid1_read_balance+76>:  add  %i5, 0x18, %o7
> 0xbb0 <raid1_read_balance+80>:  sllx  %o7, 3, %g2
> 
> %i5 is holding "conf". adding 0x18 gives the address of
>  conf->mirrors[0]->head_position in %o7.
> But then we shift %o7 left 3 places, multiplying by 8.
> Multiplying an address by 8 is very unlikely to be correct.
> 
> Could you both please tell us what compiler version you are using, and
> see if you can try a different one.
> 
> NeilBrown
> 
> 
> 
> >  \|/ ____ \|/
> >  "@'/ .. \`@"
> >  /_| \__/ |_\
> >     \__U_/
> 
> Gotta love this!!
> 
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
