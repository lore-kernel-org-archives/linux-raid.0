From: Brock Nanson <brock@nanson.org>
Subject: Re: Md cache?
Date: Thu, 03 Jun 2004 13:16:54 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40BF8736.10101@nanson.org>
References: <200406031922.i53JMS315198@watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200406031922.i53JMS315198@watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: 'Brian Pontius' <linuxboy123@mindspring.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My IBM ServeRAID 3HB's do.  But as you say, many don't.  A UPS with a 
communications cable and shutdown software is really the only solution.

Brock

Guy wrote:

> With hardware RAID the write cache has battery backup.  So, the RAID system
> will not lose data when the power fails.  It will finish the writes when the
> power returns.
> 
> I don't think the hardware RAID cards have a battery.  The external self
> contained RAID systems that I have worked with do have batteries.
> 
> Anyone know?  Do any RAID cards have batteries?
> 
> Guy
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Brian Pontius
> Sent: Thursday, June 03, 2004 2:14 PM
> To: Neil Brown
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Md cache?
> 
> I apologze for being unclear.
> 
> As I did comparisons between software and hardware raid,  one of the
> advantage
> s that I noticed with hardware raid was cache (both read and write). With
> hard
> ware it is usually larger giving some increase in performance.  I was
> looking
> for a way to allocate more system memory specifically to be the md cache
> area
> to give that extra feature of that hardware raid. This would especially be
> ben
> efitial for a NAS that has a dedicated purpose to fast reliable storage.
> 
> 
> Thanks for your time.
> Brian Pontius
> 
> 
> -----Original Message-----
> From: Neil Brown <neilb@cse.unsw.edu.au>
> Sent: Jun 2, 2004 10:10 PM
> To: Brian Pontius <linuxboy123@mindspring.com>
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Md cache?
> 
> On Wednesday June 2, linuxboy123@mindspring.com wrote:
> 
>>to all,
>>
>>Is anyone aware of a way to cause the md devices to use some system memory
> 
> as a write cache? (maybe through mdadm?).  I have looked everywhere and
> cannot seem to find anything about such a feature.
> 
>>If not, anyone  know if this is a possibility for the future, Neil?
> 
> 
> What is it exactly that you want.
> 
> All device IO is cached in memory before being written to the device.
> The only real value of a cache with a RAID array is if it we a
> non-volatile cache.  Is that what you were thinking of.
> 
> NeilBrown
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
