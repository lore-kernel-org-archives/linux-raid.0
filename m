From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Scrub?
Date: Fri, 6 Aug 2004 22:03:33 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0408062159360.7382-100000@uplift.swm.pp.se>
References: <200408062041.35337.mrwatts@fast24.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200408062041.35337.mrwatts@fast24.co.uk>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 6 Aug 2004, Mark Watts wrote:

> Well I've only ever seen the phrase 'scrub' used when refering to wiping 
> disks, usually in a secure way (multiple passes with different bit paterns).
> Thats on this side of the pond anyway...

http://www.nexsan.com/products/FAQATAboy.pdf

There is a sentense:

"Array is verified before being put into production;  automatic "parity
scrub" (array verify) is performed as a background task every 24 hours
after"

So some use it in the sense of "verify" anyway. I prefer verify as well, 
it seems a more adequate word. There are numerous referrals to the word 
"scrub" as verify when doing a google search for "+raid +scrub".

I set my 3ware volumes to verify every week, it makes me more comfortable 
with the volumes being checked and excercised on a regular basis so I know 
all blocks can be read from all drives.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

