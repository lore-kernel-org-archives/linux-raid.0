From: Asdo <asdo@shiftmail.org>
Subject: Re: feature suggestion to handle read errors during re-sync of raid5
Date: Sat, 30 Jan 2010 23:04:09 +0100
Message-ID: <4B64ACD9.7020207@shiftmail.org>
References: <alpine.DEB.1.10.1001301331560.15329@uplift.swm.pp.se>
 <4B6471A1.2070407@texsoft.it> <4B6482BD.6090102@anonymous.org.uk>
 <alpine.DEB.1.10.1001302228540.15329@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <alpine.DEB.1.10.1001302228540.15329@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael Abrahamsson wrote:
> I think the 4k sector size on WD20EARS (for instance) is supposed to 
> add more ECC information but I'm not sure how this will affect the 
> 10^14 error rate. I think the manufacturers need to work a bit more on 
> it, I don't see how these drives can be used in single drive 
> configuration with the current 10^14 value.
>
> I don't have experience with any other drives than the WD20EADS but 
> they develop read errors at a rate higher than any other drive I've 
> experienced before....

We are thinking about buying a large number of WD2002FYPS RE4-GP for a 
large array (raid-6)

Anyone knows if the error rate is so high on those drives too?
Do they also use 4k sectors? Mikael, how do you find this out?

Is the 4k sectors a RMW emulation as written in
    http://lwn.net/Articles/322777/
or Linux sees them really as 4k block devices?
And if it's the second, were there side effects on this?

Thank you
