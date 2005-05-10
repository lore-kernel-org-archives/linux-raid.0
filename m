From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: grow problem
Date: Wed, 11 May 2005 09:41:10 +1000
Message-ID: <17025.18070.800000.318669@cse.unsw.edu.au>
References: <42812E77.9060503@advocap.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from John McMonagle on Tuesday May 10
Sender: linux-raid-owner@vger.kernel.org
To: John McMonagle <johnm@advocap.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 10, johnm@advocap.org wrote:
> Having a problem changing my number of mirrors on a raid1 from 3 to 2.
> 
> Did it about a week ago on another system so I'm a bit perplexed.
> 
> mdadm --grow /dev/md0 --raid-disks 2
> mdadm: Cannot set device size/shape for /dev/md0: Device or resource busy
> 
>  cat /proc/mdstat
> Personalities : [raid1]
> md0 : active raid1 sda1[0] hda1[2]
>       976640 blocks [3/2] [U_U]

md/raid1 currently requires and devices that you plan to remove with
--grow, to already be missing.

So you would need to fail and re-add hda1, which would mean a full
rebuild :-(

If you can afford to:
   - wait a few days
   - recompile your kernel
   - be a guinea pig

I can get raid1 to try to move devices into earlier holes before
reducing the size.  Let me know, and I'll start working on a patch.

NeilBrown
