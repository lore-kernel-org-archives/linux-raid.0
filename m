From: Neil Brown <neilb@suse.de>
Subject: Re: Convert RAID5 to RAID6?
Date: Tue, 4 Oct 2005 10:07:55 +1000
Message-ID: <17217.51163.347984.104961@cse.unsw.edu.au>
References: <dhjoc9$26u$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Robin Bowes on Friday September 30
Sender: linux-raid-owner@vger.kernel.org
To: Robin Bowes <robin-lists@robinbowes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday September 30, robin-lists@robinbowes.com wrote:
> OK,
> 
> Based on some comments I've received following my previous post about 
> large storage arrays, and having read around a bit, I think my 6-disk 
> 1TB array would be better as RAID6 rather than RAID5 plus hot spare.
> 
> Is it possible to convert from RAID5 to RAID6? Or would I have to dump 
> the whole array to tape, trash it, create the RAID6 array and restore 
> from tape?

It's possible that raidreconf might support raid6, but apart from 
that - No.  Dump-and-restore is probably the best option if it is
practical.

I hope to get online-reconf from raid5 to raid6 working after the
online raid5 resize has stablised.  But that is a little way off yet.

NeilBrown
