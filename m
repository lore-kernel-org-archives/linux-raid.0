From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: stoppind md from kicking out "bad' drives
Date: Mon, 11 Nov 2013 12:05:21 +0400
Message-ID: <52808FC1.3010200@msgid.tls.msk.ru>
References: <5280870E.6080703@msgid.tls.msk.ru> <alpine.DEB.2.02.1311110838190.26054@uplift.swm.pp.se> <52808C72.3000405@msgid.tls.msk.ru> <alpine.DEB.2.02.1311110853530.26054@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1311110853530.26054@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

11.11.2013 11:56, Mikael Abrahamsson wrote:
> On Mon, 11 Nov 2013, Michael Tokarev wrote:
>
>> No, really, that's not the solutions I was asking for.
>
> Well, it is.
>
>> Yes raid6 is better in this context.  But it has exactly the same properties
>> when drives start "semi-failing" - it is enough to have one bad sector in
>> different places of 3 drives for a catastrophic failure, while the array
>> can even continue to work normally because the bad sectors are in different
>> places.
>
> If you have timeouts set properly then md will be able to re-calculate the bad sector from parity and re-write it, even with one drive failed.

Timeouts has nothing to do with this at all.

First drive were "stuck" somewhere in its firmware or electronics and
didn't respond at all (for several MINUTES), even to device reset.
It recovered much later when a bus reset was performed.

Second drive returned "I can't read this data" rather quickly.  It
was not "timeout reading" or somesuch, it was a confident "sorry guys
I've lost this piece".

>> It is the drive kick-off - the decision made by md driver - which makes the failure catastrophic.
>
> That's what the timeout problem is. If you're running consumer drives and default linux kernel timeouts then the drive will be kicked before it can return a read error.

It's not consumer drivers, and again, it has nothing to do with the timeouts.

Even if it were really timeouts, even given infinite timeout, if the bad
sector can't be read, no games with timeouts will let to recover it.

And it is just ONE bad sector (on next drive) which makes md to kick the
WHOLE device out of the array -- exactly the moment which turns the issue
from "maybe, just maybe, lost some data" to "whole data has been lost".
(And yes I pretty much understand that md tries to rewrite the place when
it can do that)

[]
> I don't understand why you would be running a RAID5+spare instead of RAID6 without spare.

Yet again, this is a entirely different question.

Please, pretty please, don't speak if you don't understand the topic... ;)

Thanks,

/mjt

