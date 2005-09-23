From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Software RAID1 problems
Date: Fri, 23 Sep 2005 17:52:05 +0200
Message-ID: <17204.9381.457236.785392@cse.unsw.edu.au>
References: <17189.65525.274983.671124@cse.unsw.edu.au>
	<Pine.WNT.4.63.0509231622040.2312@ender>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andy Dawson on Friday September 23
Sender: linux-raid-owner@vger.kernel.org
To: Andy Dawson <A.J.Dawson@Bradford.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday September 23, A.J.Dawson@Bradford.ac.uk wrote:
> After a fairly long time without seeing the following message:
> 
> "This is an automatically generated mail message from mdadm
> running on servername
> 
> A DegradedArray event had been detected on md device /dev/md0.
> 
> Faithfully yours, etc."
> 
> It reared its head again today.
> 
> I've checked dmesg and /var/log/messages and the only thing I've found so 
> far is the following in dmesg:
> 
> md: considering sda1 ...
> md:  adding sda1 ...
> md: created md0
> md: bind<sda1>
> md: running: <sda1>
> raid1: raid set md0 active with 1 out of 2 mirrors
> 
> md1 works fine and md sets md1 active with 2 out of 2 mirrors.
> 
> /dev/sdb2 is the device that appears to be causing the problem, so can 
> anyone tell me what might be happening?  Any ideas why it might not be 
> included in the array at boot time? (I've tried Google but found no 
> answers yet).
> 
> Any help would be appreciated!

Looks a lot like sdb2 (sure it isn't sdb1?) isn't type 'FD'.
NeilBrown
