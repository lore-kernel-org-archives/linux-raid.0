From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Partitioning a RAID device
Date: Fri, 6 Sep 2002 15:15:19 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15736.14823.863026.285510@notabene.cse.unsw.edu.au>
References: <Pine.LNX.4.30.0209040912270.11782-100000@jaded.cynicism.com>
	<Pine.HPX.4.43.0209051727350.11531-100000@electra.kip.uni-heidelberg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Arne Wiebalck on Thursday September 5
To: Arne Wiebalck <wiebalck@kip.uni-heidelberg.de>
Cc: Derek Vadala <derek@cynicism.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday September 5, wiebalck@kip.uni-heidelberg.de wrote:
> 
> fdisk(pid 1344) tried BLKRRPART ioctl on MD device. Should use MDP
> device.

Yes, you shold use the MDP devices... look in /proc/devices to find
the major number.
> 
> md: fdisk(pid 2486) used obsolete MD ioctl, upgrade your software to use
> new ictls.

Ignore this, it doesn't really mean anything.

> 
> so, partitioning did not work.
> 
> my fdisk version is 2.11.
> should I use another tool for partitioning?

fdisk, cfdisk, sfdisk all work fine.

> who is responsible for making the device special files?

You.  (or devfs).
The first 16 minors for mdp correspond to md0
The second 16 minors for mdp correspond to md1
etc.

NeilBrown
