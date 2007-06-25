From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: stripe_cache_size and performance
Date: Mon, 25 Jun 2007 18:23:38 -0500 (CDT)
Message-ID: <Pine.LNX.4.64.0706251823230.5806@gheavc.wnzcbav.cig>
References: <Pine.LNX.4.64.0706211312480.5806@gheavc.wnzcbav.cig>
 <5d96567b0706211242p7f03bd1cw9102ae3e44d67cee@mail.gmail.com>
 <Pine.LNX.4.64.0706211808140.5806@gheavc.wnzcbav.cig>
 <Pine.LNX.4.64.0706251705040.5806@gheavc.wnzcbav.cig>
 <e9c3a7c20706251519u3f6db295n3c653869ecbfbb0c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20706251519u3f6db295n3c653869ecbfbb0c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 25 Jun 2007, Dan Williams wrote:

> > 7. And now, the question: the best absolute 'write' performance comes
> > with a stripe_cache_size value of 4096 (for my setup). However, any
> > value of stripe_cache_size above 384 really, really hurts 'check' (and
> > rebuild, one can assume) performance.  Why?
> >
> Question:
> After performance goes "bad" does it go back up if you reduce the size
> back down to 384?

Yes, and almost instantly.

--
Jon Nelson <jnelson-linux-raid@jamponi.net>
