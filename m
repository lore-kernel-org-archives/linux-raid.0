From: Neil Brown <neilb@suse.de>
Subject: Re: limits on raid
Date: Fri, 15 Jun 2007 13:05:03 +1000
Message-ID: <18034.479.256870.600360@notabene.brown>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from david@lang.hm on Thursday June 14
Sender: linux-raid-owner@vger.kernel.org
To: david@lang.hm
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday June 14, david@lang.hm wrote:
> what is the limit for the number of devices that can be in a single array?
> 
> I'm trying to build a 45x750G array and want to experiment with the 
> different configurations. I'm trying to start with raid6, but mdadm is 
> complaining about an invalid number of drives
> 
> David Lang

"man mdadm"  search for "limits".  (forgive typos).

NeilBrown
