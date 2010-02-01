From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: 2 drives failed, one "active", one with wrong event count
Date: Mon, 1 Feb 2010 08:13:24 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1002010810440.31777@uplift.swm.pp.se>
References: <alpine.DEB.1.10.1001280952060.15329@uplift.swm.pp.se> <alpine.DEB.1.10.1001290502140.15329@uplift.swm.pp.se> <20100129211719.04595761@notabene> <alpine.DEB.1.10.1001291306170.15329@uplift.swm.pp.se> <alpine.DEB.1.10.1001291326430.15329@uplift.swm.pp.se>
 <alpine.DEB.1.10.1001301546400.15329@uplift.swm.pp.se> <20100201093713.7ee33041@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100201093713.7ee33041@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 1 Feb 2010, Neil Brown wrote:

> You might know that nothing has been written to the array since the 
> device with the lower event count was removed, but md doesn't know that. 
> Any device with an old event count could have old and so cannot be 
> trusted (unless you assemble with --force meaning that you are taking 
> responsibility).

I did use --force, but it seems in the state "one drive with lower event 
count and another one with 0x2", the event count on the drive isn't 
forcably updated and since there is a 0x2 drive, the array isn't started.

I had the same situation again this morning (changing controller next), 
but this time I had bitmaps enabled so recovery of the array with 
--assemble --force took just a few seconds. Really nice.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
