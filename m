From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Linux Software RAID a bit of a weakness?
Date: Sat, 24 Feb 2007 17:14:53 +1300
Message-ID: <45DFBBBD.7020808@sauce.co.nz>
References: <1172258378.21648.51.camel@cowie> <17887.19894.548422.683023@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17887.19894.548422.683023@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

> The 'check' process reads all copies and compares them with one
> another,  If there is a difference it is reported.  If you use
> 'repair' instead of 'check', the difference is arbitrarily corrected.
> If a read error is detected during the 'check', md/raid1 will attempt
> to write the data from the good drive to the bad drive, then read it
> back.  If this works, the drive is assumed to be fixed.  If not, the
> bad drive is failed out of the array.
> 

One thing to note here is that 'repair' was broken for RAID1 until 
recently - see

http://marc.theaimsgroup.com/?l=linux-raid&m=116951242005315&w=2

As this patch was submitted just prior to the release of 2.6.20, this 
may be the first "fixed" kernel, but I have not checked.

Regards,

Richard

