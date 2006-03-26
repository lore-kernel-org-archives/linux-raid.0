From: dean gaudet <dean@arctic.org>
Subject: Re: raid5 high cpu usage during reads - oprofile results
Date: Sat, 25 Mar 2006 21:38:17 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0603252122210.6166@twinlark.arctic.org>
References: <1143240438.8573.59.camel@starfire> <1143275900.8573.116.camel@starfire>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1143275900.8573.116.camel@starfire>
Sender: linux-raid-owner@vger.kernel.org
To: Alex Izvorski <aizvorski@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 25 Mar 2006, Alex Izvorski wrote:

>  http://linuxraid.pastebin.com/621363 - oprofile annotated assembly

it looks to me like a lot of time is spent in __find_stripe() ... i wonder 
if the hash is working properly.

in raid5.c you could try changing

#define stripe_hash(conf, sect) (&((conf)->stripe_hashtbl[((sect) >> STRIPE_SHIFT) & HASH_MASK]))

to

#define stripe_hash(conf, sect) (&((conf)->stripe_hashtbl[(((sect) >> STRIPE_SHIFT) ^ ((sect) >> (2*STRIPE_SHIFT))) & HASH_MASK]))

or maybe try using jhash_1word((sect) >> STRIPE_SHIFT, 0) ...

-dean
