From: Anton Starikov <A.Starikov@utwente.nl>
Subject: Support for PATA in Promise 378 driver
Date: Mon, 23 Feb 2004 14:16:36 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040223141636.20fed6ba@hantst.kabel.utwente.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

As I can see, there is no support for PATA port on promise 378 chip
currently.

Is this support planned?
If now, why? Is there some religious reasons?  ;) 
Or just matter of time?

I just see, that I'm not one person who can't migrate to 2.6 because of
using PATA port on 378.
There is no driver from Promise, driver from libata also does not
support.

So, now I see two solutions:
1) adopt promise driver from vendor (which use cam) for 2.6
kernel, if there is religious reasons ;)
2) try to work under libata promise driver in order to have
support for PATA port. 

First way is relatively easy. At least I know what to do, it just matter
of programming.
Second one is longer because I have to understand how
libata works, because I had nothing common with HW for a long time :)
But if later it will be merged to libata, there is more sense to go by
this way.

Finally, what to do? :)

Anton Starikov
