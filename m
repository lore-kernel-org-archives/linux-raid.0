From: Neil Brown <neilb@suse.de>
Subject: Re: very degraded RAID5, or increasing capacity by adding discs
Date: Tue, 9 Oct 2007 13:24:41 +1000
Message-ID: <18186.62585.7261.178442@notabene.brown>
References: <20071008211313.6cd8bbb5@absurd>
	<470AB496.5010406@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michael Tokarev on Tuesday October 9
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday October 9, mjt@tls.msk.ru wrote:
> 
> o degraded raid5 isn't really Raid - i.e, it's not any better than
>   a raid0 array, that is, any disk fails => the whole array fails.
>   So instead of creating a degraded raid5 array initially, create
>   smaller one instead, but not degraded, and reshape it when
>   necessary.

Fully agree.

> 
> o reshaping takes time, and for this volume, reshape will take
>   many hours, maybe days, to complete.
> 
> o During this reshape time, errors may be fatal to the whole array -
>   while mdadm do have a sense of "critical section", but the
>   whole procedure isn't as much tested as the rest of raid code,
>   I for one will not rely on it, at least for now.  For example,
>   a power failure at an "unexpected" moment, or some plain-stupid
>   error in reshape code so that the whole array goes "boom" etc...

While it is true that the resize code is less tested than other code,
it is designed to handle a single failure at any time (so a power
failure is OK as long as the array is not running degraded), and I
have said that if anyone does suffer problems while performing a
reshape, I will do my absolute best to get the array functioning and
the data safe again.

> 
> o A filesystem on the array has to be resized separately after
>   re{siz,shap}ing the array.  And filesystems are different at
>   this point, too - there are various limitations.  For example,
>   it's problematic to grow ext[23]fs by large amounts, because
>   when it gets initially created, mke2fs calculates sizes of
>   certain internal data structures based on the device size,
>   and those structures can't be grown significantly, only
>   recreating the filesystem will do the trick.

This isn't entirely true.
For online resizing (while the filesystem is mounted) there are some
limitations as you suggest.  For offline resizing (while filesystem is
not mounted) there are no such limitations.


NeilBrown
