From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Stupid Question?
Date: Mon, 24 May 2004 12:33:33 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16561.24317.771846.481608@cse.unsw.edu.au>
References: <134.2f7071f3.2de27730@aol.com>
	<20040524020156.31599.qmail@paris.rubylane.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from jim@rubylane.com on Sunday May 23
To: jim@rubylane.com
Cc: AndyLiebman@aol.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday May 23, jim@rubylane.com wrote:
> > 
> > Hi, 
> > 
> > I feel like this is a stupid question. But I actually don't know the answer 
> > to it. If I'm going to make a Software RAID array with a bunch of identical 
> > disks, do the disks have to have at least one partition on them? Or can I use 
> > disks with NO partitions? 
> 
> Yes, the disks have to have partitions.  When you specify "make a raid
> out of X, Y, Z", the X, Y, and Z are partition names, like /dev/hda1,
> /dev/hdb1.  You can't make a raid out of /dev/hda and /dev/hdb - whole
> devices.

Why not?  I do it all the time.

You cannot get the kernel to auto-detect the raid if it is made from
whole devices, but I don't care much about that.  It works for me.

NeilBrown
