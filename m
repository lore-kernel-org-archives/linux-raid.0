From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: how to understand this bitmap_zero
Date: Wed, 09 Nov 2005 18:11:15 -0500
Message-ID: <1131577875.452.15.camel@localhost.localdomain>
References: <1131557337.8969.466.camel@localhost.localdomain>
	 <17266.30795.161044.844874@cse.unsw.edu.au>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17266.30795.161044.844874@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

ic. thx!

so it seems that we still have to use set_bit in a for loop to set
certain particular area, rite?

Ming

On Thu, 2005-11-10 at 09:29 +1100, Neil Brown wrote:
> On Wednesday November 9, mingz@ele.uri.edu wrote:
> > could anybody help me on this? thanks!
> > 
> > see if we call bitmap_zero(dst, 2), it will do *dst = 0UL and thus clear
> > whole *dst, but what if we intent to clear 2 bits? not 32bits?
> 
> bitmap_zero isn't intended for zeroing just a few bits in a bitmap.
> It is for zeroing an entire bitmap, and you tell it how big the bitmap
> is.  So this function will always zero at least the whole bitmap, and
> maybe a bit more.  as bitmaps are always allocated as an array of
> 'unsigned long', there it no risk it over-running the space allocated.
> 
> Hope that helps.
> NeilBrown
> 
> > 
> > static inline void bitmap_zero(unsigned long *dst, int nbits)
> > {
> >         if (nbits <= BITS_PER_LONG)
> >                 *dst = 0UL;
> >         else {
> >                 int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
> >                 memset(dst, 0, len);
> >         }
> > }
> > 
> > 
> > Ming
> > 
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

