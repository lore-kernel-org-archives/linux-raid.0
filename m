From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Linux 2.6.10 / RAID1 problem
Date: Thu, 6 Jan 2005 09:55:06 +1100
Message-ID: <16860.28746.956794.569542@cse.unsw.edu.au>
References: <41DC515C.7030208@anduras.de>
	<200501052246.XAA07775@node130.rhm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from bernd@rhm.de on Wednesday January 5
Sender: linux-raid-owner@vger.kernel.org
To: bernd@rhm.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday January 5, bernd@rhm.de wrote:
> Hi Sven,
> 
> we used RAID1 under Kernel 2.4.x without any problems (except the counters
> for activ- and spare disks became wrong). With kernel 2.6.x RAID1 is a 
> desaster. This problem was dicussed in this newsgroup in the second half
> of last year. The kernel dies if a disk fails
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This was true in 2.6.9 and earlier.  It is fixed in 2.6.10.

>                                               or if the system is heavy 
                                                ^^^^^^^^^^^^^^^^^^^^^^^^^
> loaded (the latter one we can't reproduce but it happens, may be there
  ^^^^^^
> will be some other issues on the SCSI bus for other reasons leading to
> the same result). 

This one I am not aware of.  More details would be most helpful.

NeilBrown
