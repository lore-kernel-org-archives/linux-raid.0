From: Neil Brown <neilb@suse.de>
Subject: Re: Cutting power without breaking RAID
Date: Thu, 29 Jun 2006 14:00:09 +1000
Message-ID: <17571.20553.319133.437688@cse.unsw.edu.au>
References: <20060628214350.GA23970@rigacci.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Niccolo Rigacci on Wednesday June 28
Sender: linux-raid-owner@vger.kernel.org
To: Niccolo Rigacci <niccolo@rigacci.org>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday June 28, niccolo@rigacci.org wrote:
> Hello,
> 
> I'm facing this problem:
> 
> when my Linux box detects a POWER FAIL event from the UPS, it 
> starts a normal shutdown. Just before the normal kernel poweroff, 
> it sends to the UPS a signal on the serial line which says 
> "cut-off the power to the server and switch-off the UPS".
> 
> This is required to reboot the server as soon as the power is 
> restored.
> 
> The problem is that the root partition is on top of a RAID-1 
> filesystem which is still mounted when the program that kills the 
> power is run, so the system goes down with a non clean RAID 
> volume.
> 
> What can be the proper action to do before killing the power to 
> ensure that RAID will remain clean? It seems that remounting 
> the partition read-only is not sufficient.

Are you running a 2.4 kernel or a 2.6 kernel?

With 2.4, you cannot do what you want to do.

With 2.6, 
   killall -9 md0_raid1

should do the trick (assuming root is on /dev/md0.  If it is elsewhere,
choose a different process name).
After you "kill -9" the raid thread, the array will be marked clean
immediately all writes complete, and marked dirty again before
allowing another write.

NeilBrown
