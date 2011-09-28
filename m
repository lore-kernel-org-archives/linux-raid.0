From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: Recovery of failed RAID 6 and LVM
Date: Wed, 28 Sep 2011 13:02:26 -0600
Message-ID: <201109281302.26514.thomas@fjellstrom.ca>
References: <4E7EDE58.3000804@yazzy.org> <4E82F923.8080807@ziu.info> <4E831F24.9030009@fnarfbargle.com>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E831F24.9030009@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On September 28, 2011, Brad Campbell wrote:
> On 28/09/11 18:38, Michal Soltys wrote:
> > It's hard to find cases, when md driver or mdadm was really at fault for
> > something. For the most part the typical route is: [bottom barrel cheap
> > desktop ]hardware/[terribly designed sata ]cable issues -> a user
> > applying random googled suggestions (with shaking hands) -> really,
> > really bad problems. But that's not md's failure.
> 
> This really sums it up succinctly.
> 
> If you watched the cases of disaster that swing past linux-raid, the
> ones who always walk away whistling a happy tune are the ones who stop,
> think and ask for help.
> 
> The basket cases are more often than not created by people trying stuff
> out because they saw it mentioned somewhere else.
> 
> I'd suggest that users of real hardware raid suffer less "problems"
> because as they pay a bucketload of money for their raid card, they are
> far less likely to cheap out on cables, enclosures, drives and power
> supplies.
> 
> Most of the tales of woe here are related to the failures associated
> with commodity hardware. The 8TB I lost was entirely due to using a $15
> SATA controller.
> 

I completely agree. The last time I lost my array, it was because I fat 
fingered a mdadm command. Can't remember exactly what it was now, either a 
reshape, or a drive replacement. Now I try to be very very careful.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
