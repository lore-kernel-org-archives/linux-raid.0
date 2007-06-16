From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: limits on raid
Date: Sat, 16 Jun 2007 10:08:57 -0400
Message-ID: <20070616140857.GA4206@animx.eu.org>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm> <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <20070616020320.GB2002@animx.eu.org> <18035.23867.576212.859440@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18035.23867.576212.859440@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Friday June 15, wakko@animx.eu.org wrote:
>  
> >                                                   As I understand the way
> > raid works, when you write a block to the array, it will have to read all
> > the other blocks in the stripe and recalculate the parity and write it out.
> 
> Your understanding is incomplete.
> For raid5 on an array with more than 3 drive, if you attempt to write
> a single block, it will:
> 
>  - read the current value of the block, and the parity block.
>  - "subtract" the old value of the block from the parity, and "add"
>    the new value.
>  - write out the new data and the new parity.
> 
> If the parity was wrong before, it will still be wrong.  If you then
> lose a drive, you lose your data.

I see, I didn't know that the MD's raid5 did this.

> And why is it such a big deal anyway?  The initial resync doesn't stop
> you from using the array.  I guess if you wanted to put an array into
> production instantly and couldn't afford any slowdown due to resync,
> then you might want to skip the initial resync.... but is that really
> likely?

When I've had an unclean shutdown on one of my systems (10x 50gb raid5) it's
always slowed the system down when booting up.  Quite significantly I must
say.  I wait until I can login and change the rebuild max speed to slow it
down while I'm using it.   But that is another thing.

Thanks for the clarification on raid5.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
