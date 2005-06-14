From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Stacked devices (Was: Is there a good reason why I can't "mdadm -Gfn1 /dev/md1" ?)
Date: Tue, 14 Jun 2005 10:59:23 +1000
Message-ID: <17070.11243.842543.918168@cse.unsw.edu.au>
References: <E1DgFzi-0007K9-00@mta2.cl.cam.ac.uk>
	<17064.9218.919914.356958@cse.unsw.edu.au>
	<20050609112055.GA26006@percy.comedia.it>
	<17064.16812.95215.185952@cse.unsw.edu.au>
	<20050612172251.GA11412@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Luca Berra on Sunday June 12
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday June 12, bluca@comedia.it wrote:
> 
> i did some investigation and found the issue that caused mdadm failing
> for me with stacked device.
> I am an udev user and i use the --auto flag to assemble to create the
> device files.
> mdadm does create a device list at the beginning and while reloading the
> /proc/partitions file does not add new md devices to the device list, so
> i plugged add_dev into open_mddev() and now everything seems to work
> perfectly.

Sounds like a very sensible fix, thanks.

> also please add the manpage for mdassemble (also attached)

Yep, it will be in the next mdadm.
Thanks again.
NeilBrown
