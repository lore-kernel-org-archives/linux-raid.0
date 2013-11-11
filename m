From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: stoppind md from kicking out "bad' drives
Date: Mon, 11 Nov 2013 08:41:19 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1311110838190.26054@uplift.swm.pp.se>
References: <5280870E.6080703@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5280870E.6080703@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 11 Nov 2013, Michael Tokarev wrote:

> The question is: what's missing currently to prevent kicking drives from 
> md arrays at all?  And I really mean preventing _both_ first failed 
> drive (before start of resync) and second failed drive?

Crank up the timeout settings a lot might help (I use 180 seconds), it 
would probably have stopped the first drive from being kicked out.

But you really should be running RAID6 and not RAID5 (as you now have 
observed) to handle the failure case you just observed.

Write-intent bitmap would have stopped the initial full resync of the 
drive that was kicked out, which might have helped as well.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
