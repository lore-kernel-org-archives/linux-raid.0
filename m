From: "Yuval Yeret" <yuval@exanet.com>
Subject: RE: RAID detection and activation w/o auto detection
Date: Wed, 1 May 2002 08:20:45 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4913AB320D31DC4798D6FEF5F557351F18240F@hawk.exanet-il.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: linux-raid maillist <linux-raid@vger.kernel.org>, neilb@cse.unsw.edu.au
List-Id: linux-raid.ids



Should we consider mdadm as a replacement to raidstart/raidstop ? 

I ask because we are seeing strange behaviour in starting a raid when
one of the paths is not available.

Thank,
Yuval Yeret


-----Original Message-----
From: Neil Brown [mailto:neilb@cse.unsw.edu.au]
Sent: Wednesday, May 01, 2002 7:21 AM
To: Mr. James W. Laferriere
Cc: linux-raid maillist
Subject: Re: RAID detection and activation w/o auto detection 


On Tuesday April 30, babydr@baby-dragons.com wrote:
> 
> 	Hello Neil ,  OK mia culpa .  But I don't see what good the echo
> 	below does for us then ,  as in ...
> 
> ~# more ./mdadm.conf
> /dev/hd* /dev/sd*
> ARRAY /dev/md0 level=raid5 num-devices=3
UUID=b285b144:ae0b561b:b5b55686:ed216a4c
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
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
