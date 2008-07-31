From: "David Lethe" <david@santools.com>
Subject: RE: RAID1 write order fidelity
Date: Thu, 31 Jul 2008 13:20:50 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C01501345@34093-C3-EVS3.exchange.rackspace.com>
References: <20080731090330.285131sc3ypxzwhu@webmail.ualberta.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20080731090330.285131sc3ypxzwhu@webmail.ualberta.ca>
Sender: linux-raid-owner@vger.kernel.org
To: aristizb@ualberta.ca, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of aristizb@ualberta.ca
> Sent: Thursday, July 31, 2008 10:04 AM
> To: linux-raid@vger.kernel.org
> Subject: RAID1 write order fidelity
> 
> Hi,
> 
> I am currently working with a software Linux RAID1, with external
> bitmap and no write-behind option. Does the RAID controller keep the
> write order fidelity?.
> 
> If an application writes some blocks on the RAID device in a
> particular order, can I ensure that these blocks will be written to
> the devices conforming the RAID on the same order, or at least on the
> main disk? (disk 0 on the RAID).
> 
> 
> The version of mdadm I am suing is 2.6.2.
> 
> 
> Thank you.
> 
> 
> Juan Aristizabal.

The answer is no.  Well-designed RAID controllers will prioritize queued
I/Os for best performance.  And, for that matter, device drivers, BIOS,
even some file systems will move around I/Os for purposes of
optimization and response time, so this isn't necessarily a
RAID-controller specific response.  They may even eliminate writes
completely based on cache settings, what is in the queue, the block
range, and the number of blocks for the I/O requests.  
David @ santools dot com


