From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Sun, 1 Aug 2004 14:11:30 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0408011407230.7382-100000@uplift.swm.pp.se>
References: <200408011051.00300.mrwatts@fast24.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200408011051.00300.mrwatts@fast24.co.uk>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 1 Aug 2004, Mark Watts wrote:

> This doesn't help explain why some of us are experiencing crap performance and 
> un-responsive systems whereas others are having none of these problems  with 
> the same 3Ware cards.

On my 3ware equipped system running hw raid5 I get lousy write speeds 
(approx 5-15 megabyte/s) on writes. I get great read speeds. I don't sit 
directly on the console so I have no idea if the system is interactively 
responsive or not, but I notice no problems being logged in via ssh. 

On the other hand, the 3ware volume is only used for bulk data storage,
the system, swap and other often needed data that is accessed and changed
often, I have stored on SCSI drives that are RAID1 or not RAIDed at all.

I would never store the system/swap on a 3ware hw RAID5, that would be 
disasterous for performance. Could you perhaps describe your system setup 
in more detail?
 
-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

