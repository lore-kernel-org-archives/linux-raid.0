From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Issue with md and 4K sector alignment
Date: Mon, 20 Aug 2012 07:36:20 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1208200735020.27104@uplift.swm.pp.se>
References: <5031556B.5050706@averageurl.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5031556B.5050706@averageurl.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kyle Brantley <kyle@averageurl.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 19 Aug 2012, Kyle Brantley wrote:

> I understand that I may need to work on the higher layers (LVM, 
> partitioning -- and if there is any insight here, it would be 
> appreciated!) with respect to the alignment, but my concern is the 
> resync times. I've tried building the array off of both the raw disks 
> and 4K aligned partitions placed on the disks -- the resync performance 
> is identical, and poor.

If you create the md directly on the device instead of doing partitions, 
you don't have to worry. LVM and md are already 4k aligned.

If you create partitions, then you have to make sure they're 4k aligned.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
