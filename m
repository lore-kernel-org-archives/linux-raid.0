From: Neil Brown <neilb@suse.de>
Subject: Re: Followup: Adding a device to an active RAID1 array
Date: Tue, 24 Jan 2006 15:01:57 +1100
Message-ID: <17365.42677.815057.932378@cse.unsw.edu.au>
References: <43D03D2E.3000504@rcn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Cizek on Thursday January 19
Sender: linux-raid-owner@vger.kernel.org
To: Bill Cizek <cizek@rcn.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday January 19, cizek@rcn.com wrote:
> 
> The patch you gave me worked, Neil, but the I ran into an odd problem where
>  the change is lost after a reboot.
> 
> I have raid1 devices for both superblocks 0.90.? and 1.0
> If I update the superblock 1.0 device,  mdadm --detail shows the update, 
> but if I reboot it is lost.

Thanks for the report.  I've just sent of a patch which fixes the
problem... you should see it go past on linux-raid.

NeilBrown
