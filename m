From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID detection and activation w/o auto detection
Date: Wed, 1 May 2002 15:21:23 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15567.31571.62644.485302@notabene.cse.unsw.edu.au>
References: <Pine.LNX.4.44.0204302130320.14713-100000@filesrv1.baby-dragons.com>
	<Pine.LNX.4.44.0204302142570.14713-100000@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mr. James W. Laferriere on Tuesday April 30
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday April 30, babydr@baby-dragons.com wrote:
> 
> 	Hello Neil ,  OK mia culpa .  But I don't see what good the echo
> 	below does for us then ,  as in ...
> 
> ~# more ./mdadm.conf
> /dev/hd* /dev/sd*
> ARRAY /dev/md0 level=raid5 num-devices=3 UUID=b285b144:ae0b561b:b5b55686:ed216a4c
> 
> 	Without the DEVICE in front of '/dev/hd* /dev/sd*' they are
> 	meaningless .  Right ?  Tia ,  JimL

Yep.  My mistake.  It should have been:

   echo 'DEVICE /dev/hd* /dev/sd*' > /etc/mdadm.conf

As I think you realised, --config is pointless with -Dsb, as it
doesn't read the config file, it reads /proc/mdstat.
However --config would be meaningful with -Esb, and the next release
will allow it.

Thanks,

NeilBrown
