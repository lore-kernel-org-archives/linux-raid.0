From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 00:19:43 +0100
Message-ID: <fh0pa2-kvp.ln1@news.it.uc3m.es>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es> <l1nna2-e9i.ln1@news.it.uc3m.es> <200501031846.42950.maarten@ultratux.net> <200501032052.21459.maarten@ultratux.net> <a9noa2-o12.ln1@news.it.uc3m.es>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer <ptb@lab.it.uc3m.es> wrote:
> No, call it "p". That is the correct name. And I presume you mean "an
> error", not "a failure".

I'll do this thoroughly, so you can see how it goes.

Let 

   p = probability of a detectible error occuring on a disk in a unit time
   p'= ................ indetectible .....................................

Then the probability of an error occuring UNdetected on a n-disk raid
array is

       (n-1)p + np'
  
and on a 1 disk system (a 1-disk raid array :) it is

       p'

OK? (hey, I'm a mathematician, it's obvious to me).

Exercise .. calculate effect of majority voting! 


Peter
      

