From: "David Lethe" <david@santools.com>
Subject: RE: Wipe failed RAID-5 disk before RMA
Date: Wed, 21 May 2008 11:11:05 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C71B4E9@34093-C3-EVS3.exchange.rackspace.com>
References: <loom.20080520T190131-192@post.gmane.org> <483448D1.9050808@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <483448D1.9050808@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>, Cry <cry_regarder@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Bill Davidsen
Sent: Wednesday, May 21, 2008 11:08 AM
To: Cry
Cc: linux-raid@vger.kernel.org
Subject: Re: Wipe failed RAID-5 disk before RMA

Cry wrote:
> Folks,
>
> Do any of you have suggestions on how to wipe a failed raid drive
before RMA
> back to vendor/manufacturer?  I need something that keeps going when
it reaches
> a bad block.  The tool doesn't have to do multiple passes with random
numbers. 
> It shouldn't need to be nursed along.
>   

dban.

=====================
A low-level format, (media init).  Assuming this is a seagate drive,
then download the DOS version of seatools from the Seagate site. It is
free. The problem with these other utilities is that they leave a small
security hole ... they do not write zeros to any blocks that have
already been marked as bad.

David


