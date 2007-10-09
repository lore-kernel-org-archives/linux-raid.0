From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: very degraded RAID5, or increasing capacity by adding discs
Date: Tue, 09 Oct 2007 13:48:50 +0400
Message-ID: <470B4E82.6010102@msgid.tls.msk.ru>
References: <20071008211313.6cd8bbb5@absurd>	<470AB496.5010406@msgid.tls.msk.ru> <18186.62585.7261.178442@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18186.62585.7261.178442@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday October 9, mjt@tls.msk.ru wrote:
[]
>> o During this reshape time, errors may be fatal to the whole array -
>>   while mdadm do have a sense of "critical section", but the
>>   whole procedure isn't as much tested as the rest of raid code,
>>   I for one will not rely on it, at least for now.  For example,
>>   a power failure at an "unexpected" moment, or some plain-stupid
>>   error in reshape code so that the whole array goes "boom" etc...
> 
> While it is true that the resize code is less tested than other code,
> it is designed to handle a single failure at any time (so a power
> failure is OK as long as the array is not running degraded), and I
> have said that if anyone does suffer problems while performing a
> reshape, I will do my absolute best to get the array functioning and
> the data safe again.

Well... Neil, it's your code, so you trust it - that's ok, I also
(tries to) trust my code until someone finds a bug in it.. ;)
And I'm a sysadmin (among other things), who's professional
property must be a bit of paranoia..  You got the idea ;)

>> o A filesystem on the array has to be resized separately after
>>   re{siz,shap}ing the array.  And filesystems are different at
>>   this point, too - there are various limitations.  For example,
>>   it's problematic to grow ext[23]fs by large amounts, because
>>   when it gets initially created, mke2fs calculates sizes of
>>   certain internal data structures based on the device size,
>>   and those structures can't be grown significantly, only
>>   recreating the filesystem will do the trick.
> 
> This isn't entirely true.
> For online resizing (while the filesystem is mounted) there are some
> limitations as you suggest.  For offline resizing (while filesystem is
> not mounted) there are no such limitations.

There still is - at least for ext[23].  Even offline resizers
can't do resizes from any to any size, extfs developers recommend
to recreate filesystem anyway if size changes significantly.
I'm too lazy to find a reference now, it has been mentioned here
on linux-raid at least this year.  It's sorta like fat (yea, that
ms-dog filesystem) - when you resize it from, say, 501Mb to 999Mb,
everything is ok, but if you want to go from 501Mb to 1Gb+1, you
have to recreate almost all data structures because sizes of
all internal fields changes - and here it's much safer to just
re-create it from scratch than trying to modify it in place.
Sure it's much better for extfs, but the point is still the same.

/mjt
