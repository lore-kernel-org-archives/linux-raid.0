From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: feature suggestion to handle read errors during re-sync of
 raid5
Date: Sat, 30 Jan 2010 23:25:16 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1001302323050.15329@uplift.swm.pp.se>
References: <alpine.DEB.1.10.1001301331560.15329@uplift.swm.pp.se> <4B6471A1.2070407@texsoft.it> <4B6482BD.6090102@anonymous.org.uk> <alpine.DEB.1.10.1001302228540.15329@uplift.swm.pp.se> <4B64ACD9.7020207@shiftmail.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B64ACD9.7020207@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 30 Jan 2010, Asdo wrote:

> Anyone knows if the error rate is so high on those drives too?
> Do they also use 4k sectors? Mikael, how do you find this out?

http://www.anandtech.com/storage/showdoc.aspx?i=3691

Guess you have to look at the data sheet.

> Is the 4k sectors a RMW emulation as written in
>   http://lwn.net/Articles/322777/
> or Linux sees them really as 4k block devices?

I think you can choose (jumper). Default is 512b block emulation.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
