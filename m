From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: stoppind md from kicking out "bad' drives
Date: Wed, 13 Nov 2013 19:45:29 +0400
Message-ID: <52839E99.1070002@msgid.tls.msk.ru>
References: <5280870E.6080703@msgid.tls.msk.ru> <alpine.DEB.2.02.1311110838190.26054@uplift.swm.pp.se> <52808C72.3000405@msgid.tls.msk.ru> <alpine.DEB.2.02.1311110853530.26054@uplift.swm.pp.se> <52808FC1.3010200@msgid.tls.msk.ru> <CAPbD+Re7sVfSawjGFyMZMpU4Oaf3ULTW-UA3eoD_upcgxj3GOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPbD+Re7sVfSawjGFyMZMpU4Oaf3ULTW-UA3eoD_upcgxj3GOg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guillaume Betous <guillaume.betous@gmail.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

12.11.2013 10:34, Guillaume Betous wrote:
> 
>     And it is just ONE bad sector (on next drive) which makes md to kick the
>     WHOLE device out of the array
> 
> 
> I admit that this policy is good as long as I have a bunch of redundancy (in any way) available. When this is your last chance to keep the service up, this seems a little bit "rude" :)

The "last chance" isn't exactly a well-defined term really.
For example, if you have a raid5, how do you think, pulling
one drive out of fully working raid, - is/was this drive your
last chance or not?  From one point of view it is not, it
is your last chance to have redundancy instead.  But once
you hit an error on any of other drives, you may reconsider...

> Would you mean that you'd prefer an algorithm like :
> 
> if data can be read then
>   read it
>   => NO_ERROR
> else
>   is there another way to get it ?
>   if yes
>     get it
>     rebuild failing sector
>     => NO_ERROR
>   else
>     kick the drive out
>     => ERROR
>   end
> end

No.  Please take a look at the subject again.
What I'm asking is to NOT kick any drives,
at least not when this leads to lack of
redundancy.

> Maybe we could consider this "soft" algorithm in case there is no more redundancy available (just to avoid a complete system failure, which finally is the worst solution).

I described the the algorithm which I'd love to be implemented in md,
in my previous email.  Here it is again.

When hitting an unrecoverable error on a raid compoent device
(when the device can't be written), do not kick it just yet,
but instead, mark it as "failing".  In this mode, we may still
attempt to read from the device and/or write to it, maybe marking
the new failed areas in a bitmap to not read them again (esp. if
it was write of new data which failed), or may just keep the device
around without touching it at all (and still filling the bitmap
when new writes are skipped).

This way, when some other component fails, we may _try_ to reconstruct
that place from other, good, drives and this first failed drive,
provided we didn't performed write to this part of array (if this
place isn't marked in the bitmap for the first failed drive).

And if we can't re-write and fix second drive which failed, do not
kick it from the array too, leaving it here just in case, in one
of the two modes again.

This way, we may have, say, 2-drive array where half of the data
is okay one one drive and another half is okay on another drive,
but it is still working.

The bitmap might be permanent, saved to non-volatile memory just
like current write-intent bitmap is handled, OR it can be stored
just in memory (if no persistent bitmap has been configured), so
that it is valid until the drive is disassembled -- at least this
in-memory bitmap will help to keep the device working before
shutdown...

Thanks,

/mjt
