From: Nix <nix@esperi.org.uk>
Subject: Re: [PATCH*2] mdadm works with uClibc from SVN
Date: Sat, 24 Jun 2006 14:08:30 +0100
Message-ID: <87u06aitv5.fsf@hades.wkstn.nix>
References: <87wtbbjxd4.fsf@hades.wkstn.nix> <871wtgl419.fsf@hades.wkstn.nix>
	<17563.41604.667253.877348@cse.unsw.edu.au>
	<87veqrk650.fsf@hades.wkstn.nix>
	<20060624082629.GA12050@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060624082629.GA12050@percy.comedia.it> (Luca Berra's message of "Sat, 24 Jun 2006 10:26:30 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 24 Jun 2006, Luca Berra said:
> On Fri, Jun 23, 2006 at 08:45:47PM +0100, Nix wrote:
>>On Fri, 23 Jun 2006, Neil Brown mused:
>>> Is there some #define in an include file which will allow me to tell
>>> if the current uclibc supports ftw or not?
> 
> it is not only depending on the uClibc version, but also if ftw support
> was compiled in or not.

True.

>><features.h> provides the macros __UCLIBC_MAJOR__, __UCLIBC_MINOR__, and
>>__UCLIBC_SUBLEVEL__: versions above 0.9.20 appear to support ftw()
>>(at least, they have the function, in 32-bit form at least, which
>>is certainly enough for this application!)
> 
> the following would be the correct check.
> 
> #include <features.h>
> #ifdef __UCLIBC_HAS_FTW__

Gah. I looked *in that file* and *still* failed to spot that.

You are, of course, correct.

-- 
`NB: Anyone suggesting that we should say "Tibibytes" instead of
 Terabytes there will be hunted down and brutally slain.
 That is all.' --- Matthew Wilcox
