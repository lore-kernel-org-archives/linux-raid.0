From: NeilBrown <neilb@suse.de>
Subject: Re: high throughput storage server?
Date: Wed, 16 Feb 2011 07:37:56 +1100
Message-ID: <20110216073756.4c0291eb@notabene.brown>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>
	<AANLkTimOjQDjoDMLSd1Z88GhOXoumtaQP4TyE=VpQmvQ@mail.gmail.com>
	<20110215044434.GA9186@septictank.raw-sewage.fake>
	<4D5A98BF.3030704@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5A98BF.3030704@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: Matt Garman <matthew.garman@gmail.com>, Doug Dumitru <doug@easyco.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 15 Feb 2011 10:16:15 -0500 Joe Landman <joe.landman@gmail.com> wrote:

> As a tie in to the Linux RAID list, we use md raid for our OS drives 
> (SSD pairs), and other utility functions within the unit, as well as 
> striping over our hardware accelerated RAIDs.  We would like to use 
> non-power of two chunk sizes, but haven't delved into the code as much 
> as we'd like to see if we can make this work.
> 

md/raid0 (striping) currently supports non-power-of-two chunk sizes, though
it is a relatively recent addition.
(raid4/5/6 doesn't).

Just FYI.

NeilBrown

