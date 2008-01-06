From: Neil Brown <neilb@suse.de>
Subject: Re: Raid 1, can't get the second disk added back in.
Date: Mon, 7 Jan 2008 09:34:01 +1100
Message-ID: <18305.22361.482483.331552@notabene.brown>
References: <477FAAAC.2090107@fayettedigital.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jim on Saturday January 5
Sender: linux-raid-owner@vger.kernel.org
To: jim@fayettedigital.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday January 5, jim@fayettedigital.com wrote:
> root@chinaberry:~# mdadm /dev/md0 --add /dev/hdb5
> mdadm: Cannot open /dev/hdb5: Device or resource busy
> 
> All the solutions I've been able to google fail with the busy.  There is 
> nothing that I can find that might be  using /dev/hdb5 except the raid 
> device and it appears it's not either.

Very odd. But something must be using it.

What does
   ls -l /sys/block/hdb/hdb5/holders
show?
What about
   cat /proc/mounts
   cat /proc/swaps
   lsof /dev/hdb5
  
??
NeilBrown
