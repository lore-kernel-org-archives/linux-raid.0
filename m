From: Luca Berra <bluca@comedia.it>
Subject: Re: [PATCH*2] mdadm works with uClibc from SVN
Date: Sat, 24 Jun 2006 10:26:30 +0200
Message-ID: <20060624082629.GA12050@percy.comedia.it>
References: <87wtbbjxd4.fsf@hades.wkstn.nix> <871wtgl419.fsf@hades.wkstn.nix> <17563.41604.667253.877348@cse.unsw.edu.au> <87veqrk650.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87veqrk650.fsf@hades.wkstn.nix>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jun 23, 2006 at 08:45:47PM +0100, Nix wrote:
>On Fri, 23 Jun 2006, Neil Brown mused:
>> Is there some #define in an include file which will allow me to tell
>> if the current uclibc supports ftw or not?

it is not only depending on the uClibc version, but also if ftw support
was compiled in or not.

>I misspoke: ftw was split into multiple files in late 2005, but it was
>originally added in September 2003, in time for version 0.9.21.
>
>Obviously the #defines in <ftw.h> don't exist before that date, but
>that's a bit late to check, really.
>
><features.h> provides the macros __UCLIBC_MAJOR__, __UCLIBC_MINOR__, and
>__UCLIBC_SUBLEVEL__: versions above 0.9.20 appear to support ftw()
>(at least, they have the function, in 32-bit form at least, which
>is certainly enough for this application!)

the following would be the correct check.

#include <features.h>
#ifdef __UCLIBC_HAS_FTW__
.....
#else
.....
#endif /* __UCLIBC_HAS_FTW__ */


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
