From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: stripe_cache_size and performance
Date: Mon, 25 Jun 2007 15:19:37 -0700
Message-ID: <e9c3a7c20706251519u3f6db295n3c653869ecbfbb0c@mail.gmail.com>
References: <Pine.LNX.4.64.0706211312480.5806@gheavc.wnzcbav.cig>
	 <5d96567b0706211242p7f03bd1cw9102ae3e44d67cee@mail.gmail.com>
	 <Pine.LNX.4.64.0706211808140.5806@gheavc.wnzcbav.cig>
	 <Pine.LNX.4.64.0706251705040.5806@gheavc.wnzcbav.cig>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706251705040.5806@gheavc.wnzcbav.cig>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> 7. And now, the question: the best absolute 'write' performance comes
> with a stripe_cache_size value of 4096 (for my setup). However, any
> value of stripe_cache_size above 384 really, really hurts 'check' (and
> rebuild, one can assume) performance.  Why?
>
Question:
After performance goes "bad" does it go back up if you reduce the size
back down to 384?

> --
> Jon Nelson <jnelson-linux-raid@jamponi.net>

Dan
