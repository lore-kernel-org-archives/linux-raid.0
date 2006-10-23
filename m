From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Propose of enhancement of raid1 driver
Date: Mon, 23 Oct 2006 17:28:09 +0200
Message-ID: <ehin29$80g$1@sea.gmane.org>
References: <45347D6E.3000600@mieszczak.com.pl> <17718.61672.794099.425723@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> wrote:
> Skipping over blocks within a track is no faster than reading blocks
> in the track, so you would need to make sure that your chunk size is

Not even "no faster" but probably even "slower".
For seek()+read() from userspace this gets smoothed by the kernel's
implicit read-ahead but for md this would most likely be different.
It gets IMHO further smoothed by the drive's internal cache.
Of course, there is a break-even point where seek()+read() gets faster
than sequential read() but this is surely environment-dependant.
A student of mine did some tests (in another context and from userspace,
though) to find the break-even point and found seek()+read() and
sequential read() to be quite equal up to 512k and significantly
different only at 1M and more (in his testing environment, of course).
So, to utilize this one would surely need some adaptive strategy which
measures the break-even point and somehow also identifies "large
sequential read()s" to minimize useless data transfers (and thus cache
poisoning at the different caching stages).


regards
   Mario
-- 
But after a while I learned the trick of speaking fast. You don't have
to think any faster; just use twice as many words to say everything.
                                -- Paul Graham

