From: maarten <maarten@ultratux.net>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 01:45:07 +0100
Message-ID: <200501040145.07569.maarten@ultratux.net>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es> <200501032052.21459.maarten@ultratux.net> <a9noa2-o12.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a9noa2-o12.ln1@news.it.uc3m.es>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 03 January 2005 21:41, Peter T. Breuer wrote:
> maarten <maarten@ultratux.net> wrote:
> > Just for laughs, I calculated this chance also for a three-way raid-1
> > setup

> > Let us (randomly) assume there is a 10% chance of a disk failure.
>
> No, call it "p". That is the correct name. And I presume you mean "an
> error", not "a failure".

You presume correctly.

> > We therefore have eight possible scenarios:
>
> Oh, puhleeeeze.  Infantile arithmetic instead of elementary probabilistic
> algebra is not something I wish to suffer through ...

Maybe not.  Your way of explaining may make sense to a math expert, I tried to 
explain it in a form other humans might comprehend, and that was on purpose.

Your way may be correct, or it may not be, I'll leave that up to other people. 
To me, it looks like you complicate it and obfuscate it, like someone can 
code a one-liner in perl which is completely correct yet cannot be read by 
anyone but the author...  In other words, you try to impress me with your 
leet math skills but my explanation was both easier to read and potentially 
reached a far bigger audience.

Now excuse me if my omitting "p" in my calculation made you lose your 
concentration... or something.  Further comments to be found below.


> There is no need for you to consider these scenarios. The probability
> is 3p^2, which is tiny. Forget it. (actually 3p^2(1-p), but forget the
> cube term).

If you're going to prove something in calculations, you DO NOT 'forget' a tiny 
probability.  This is not science, it's math.  Who is to say p will always be 
0.1 ?  In another scenario in another calculation p might be as high as 0.9 !

> > Scenarios G and H are special, the chances
> > of that occurring are calculated seperately.
>
> No, they are NOT special. one of them is the chance that everything is
> OK, which is (1-p)^3, or approx 1-3p (surprise surprise). The other is
> the completely forgetable probaility p^3 that all three are bad at that
> spot.

Again, you cannot go around setting (1-p)^3 to 1-3p.  P is a variable which is 
not known to you (therefore it is a variable) thus might as well be 0.9.  Is 
0.1^3 the same to you as 1-2.7 ?   Not really huh, is it ?

> This is excruciatingly poor baby math!

Oh, well then my math seems on par with your admin skills... :-p

> Or approx 1-p.

Which is approx the same number as what I said.


> It should  be  p! It is one minus your previous result.
>
> SIgh ...      0 (1-3p) + 1/3 3p  = p
>
> > Which, again, is exactly the same chance a single disk will get
> > corrupted, as we assumed above in line one is 10%.  Ergo, using raid-1
> > does not make the risks of bad data creeping in any worse.  Nor does it
> > make it better either.
>
> All false. And baby false at that. Annoying! 

Are your reading skills lacking ?  I stated that the chance of reading bad 
data was 0.1, which is equal to p, so we're in agreement it is p (0.1).

> Look, the chance of an undetected detectable failure occuring is
>          0 (1-3p) + 2/3 3p
>
>          = 2p
>
> and it grows with the number n of disks, as you may expect, being
> proportional to n-1.

I see no proof whatsoever of that.  Is that your proof, that single line ?
Do you comment your code as badly as you do your math ?

Maarten

