From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: strange mdstat output
Date: Tue, 18 Jun 2002 12:11:04 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15630.38584.494524.778934@notabene.cse.unsw.edu.au>
References: <BJEGJNFFDPGMGFNGEGLLIEDMCLAA.rene@scherer-online.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Rene Scherer on Tuesday June 18
To: Rene Scherer <rene@scherer-online.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday June 18, rene@scherer-online.com wrote:
> Hi all
> 
> I've setup a RAID 1 array between 2 of my external disks (/dev/sda1 and
> /dev/sdb1).
> 
> But for some reason "cat /proc/mdstat" doesn't show the first disk as
> sda1[0]. Instead it shows [dev 08:01][0].
> 
> md0 : active raid1 sdb1[1] [dev 08:01][0]
>       10241280 blocks [2/2] [UU]
> 
> Does anyone have any idea why?

What version of linux are you using?

What is the first occurance of the string "dev 08:01" in your kernel
logs (e.g. /var/log/kern.log) since the most recent reboot.

With this information I might be able to explain.

NeilBrown
