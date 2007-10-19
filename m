From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm 2.6.x regression, fails creation of raid1 w/ v1.0 sb and internal bitmap
Date: Fri, 19 Oct 2007 15:51:10 +1000
Message-ID: <18200.17870.419986.530609@notabene.brown>
References: <170fa0d20710170837g1b0cd549w3b7fe8e663a01b7e@mail.gmail.com>
	<18198.62670.605246.270516@notabene.brown>
	<170fa0d20710180510o1edff608p22953fa712e217f6@mail.gmail.com>
	<18200.6319.487833.714355@notabene.brown>
	<170fa0d20710182152i4763c347r704c9d939e0a4638@mail.gmail.com>
	<170fa0d20710182215v19756cabp30ddddeb7a7668a2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Snitzer on Friday October 19
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday October 19, snitzer@gmail.com wrote:
> 
> To further test this I used 2 local sparse 732456960K loopback devices
> and attempted to create the raid1 in the same manner.  It failed in
> exactly the same way.  This should cast further doubt on the bad block
> theory no?

Yes :-)

> 
> I'm using a stock 2.6.19.7 that I then backported various MD fixes to
> from 2.6.20 -> 2.6.23...  this kernel has worked great until I
> attempted v1.0 sb w/ bitmap=internal using mdadm 2.6.x.
> 
> But would you like me to try a stock 2.6.22 or 2.6.23 kernel?

Yes please.
I'm suspecting the code in write_sb_page where it tests if the bitmap
overlaps the data or metadata.  The only way I can see you getting the
exact error that you do get it for that to fail.
That test was introduced in 2.6.22.  Did you backport that?  Any
chance it got mucked up a bit?

I did the loopback test on current -mm and it works fine.

NeilBrown
