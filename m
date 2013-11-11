From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: stoppind md from kicking out "bad' drives
Date: Mon, 11 Nov 2013 11:51:14 +0400
Message-ID: <52808C72.3000405@msgid.tls.msk.ru>
References: <5280870E.6080703@msgid.tls.msk.ru> <alpine.DEB.2.02.1311110838190.26054@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1311110838190.26054@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

11.11.2013 11:41, Mikael Abrahamsson wrote:
> On Mon, 11 Nov 2013, Michael Tokarev wrote:
>
>> The question is: what's missing currently to prevent kicking drives from md arrays at all?  And I really mean preventing _both_ first failed drive (before start of resync) and second failed drive?
>
> Crank up the timeout settings a lot might help (I use 180 seconds), it would probably have stopped the first drive from being kicked out.
>
> But you really should be running RAID6 and not RAID5 (as you now have observed) to handle the failure case you just observed.

No, really, that's not the solutions I was asking for.

Yes raid6 is better in this context.  But it has exactly the same properties
when drives start "semi-failing" - it is enough to have one bad sector in
different places of 3 drives for a catastrophic failure, while the array
can even continue to work normally because the bad sectors are in different
places.

It is the drive kick-off - the decision made by md driver - which makes the
failure catastrophic.

We may reduce probability of such event by using different configuration
tweaks, but the underlying problem remains.

> Write-intent bitmap would have stopped the initial full resync of the drive that was kicked out, which might have helped as well.

Nope, because the array were (re)syncing a hot spare, not the first failed
drive.

I asked about write-intent bitmap because it can act as a semi-permanent "list
of bad blocks on component devices" -- instead of kicking whole device out,
mark just the "bad place" on it in the bitmap (the place where we weren't
able to write _new_ data) and continue using it, just avoiding reading from
the marked-as-bad places (because even if it'll succees, the data will be
wrong already).

Thanks,

/mjt

