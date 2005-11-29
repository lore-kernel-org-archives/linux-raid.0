From: Jeff Breidenbach <jeff@jab.org>
Subject: Re: building a disk server
Date: Tue, 29 Nov 2005 14:26:24 -0800
Message-ID: <E1EhDvc-00083b-00@toko.jab.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> I'd prefer to buy fewer, higher-capacity drives (300+ GB).  Any
> experience with the new 500's?

I currently have 3 of the 500GB Hitachi's in a RAID-1 configuration
using linux software RAID. So far, so good.  

In response to someone else's question, the mostly random reads are
pretty well balanced between the disks, judging from atsar reports.
Adding the third drive definitely helped read performance.

-Jeff
