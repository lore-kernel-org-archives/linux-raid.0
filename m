From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 10:46:01 +1100
Message-ID: <16857.55609.534526.297577@cse.unsw.edu.au>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es>
	<l1nna2-e9i.ln1@news.it.uc3m.es>
	<200501031846.42950.maarten@ultratux.net>
	<200501032052.21459.maarten@ultratux.net>
	<a9noa2-o12.ln1@news.it.uc3m.es>
	<fh0pa2-kvp.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peter T. Breuer on Tuesday January 4
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday January 4, ptb@lab.it.uc3m.es wrote:
> Peter T. Breuer <ptb@lab.it.uc3m.es> wrote:
> > No, call it "p". That is the correct name. And I presume you mean "an
> > error", not "a failure".
> 
> I'll do this thoroughly, so you can see how it goes.
> 
> Let 
> 
>    p = probability of a detectible error occuring on a disk in a unit time
>    p'= ................ indetectible .....................................
> 
> Then the probability of an error occuring UNdetected on a n-disk raid
> array is
> 
>        (n-1)p + np'
>   
> and on a 1 disk system (a 1-disk raid array :) it is
> 
>        p'
> 
> OK? (hey, I'm a mathematician, it's obvious to me).

It may be obvious, but it is also wrong.  But then probability is, I
think, the branch of mathematics that has the highest ratio of people
who think that understand it to people to actually do (witness the
success of lotteries).

The probability of an event occurring lies between 0 and 1 inclusive.
You have given a formula for a probability which could clearly evaluate
to a number greater than 1.  So it must be wrong.

You have also been very sloppy in your language, or your definitions.
What do you mean by a "detectable error occurring"?  Is it a bit
getting flipped on the media, or the drive detecting a CRC error
during read?

And what is your senario for an undetectable error happening?  My
understanding of drive technology and CRCs suggests that undetectable
errors don't happen without some sort of very subtle hardware error,
or high level software error (i.e. the wrong data was written - and
that doesn't really count).

NeilBrown
