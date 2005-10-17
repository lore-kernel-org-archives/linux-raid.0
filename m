From: "George  Iosif" <giosif@ase.ro>
Subject: Re: [PATCH md 000 of 8] Introduction
Date: Mon, 17 Oct 2005 13:17:23 +0300
Message-ID: <s353a474.074@nsa.ase.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: babydr@baby-dragons.com, neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,

If JimL doesn't want/have the time/etc. to do the patch testing I'd be
willing to do that.
Also, if there is something else I could contribute to, I'll be happy to
do it, given I have time for it (I'm employed so I'll try to do it in my
spare time).

Yours,

George Iosif

>>> Neil Brown <neilb@suse.de> 10/17/05 4:38 AM >>>
On Sunday October 16, babydr@baby-dragons.com wrote:
>  	Hello Neil ,  Is it possible to inert in the 'Introduction's for
your
>  	patches a Min & Max kernel level they will successfully patch
>  	against ?  ie: 2.6.12 to 2.6.14-rc4 or some such .
>  	That would sure take the angst out of guessing .  Tia ,  JimL
> 

I could certainly be more precise about which kernel they are created
against (it is usually the latest 2.6-mm) but it would be a lot of
work to figure out how far back you can safely go and still have the
patch usefully apply, and I'm not sure that it is really worth it, is
it?

If you want to help test raid patch (and I do appreciate the help), it
is really best if you use the most recent kernel, otherwise there
could be unexpected interactions which invalidate the test.

Hope that's ok,

Thanks,
NeilBrown
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

