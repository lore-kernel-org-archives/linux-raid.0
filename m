From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Is my raid setup speed ok?!
Date: Tue, 18 Nov 2003 23:09:31 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200311190409.hAJ49ZE22796@www.watkins-home.com>
References: <PPEOJEIEFLAONFNHJPOOOEIAGOAA.jim@jimtreats.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <PPEOJEIEFLAONFNHJPOOOEIAGOAA.jim@jimtreats.com>
To: 'James R Bamford' <jim@jimtreats.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It may be too late for this re-sync, but in the future do this:
echo 100000 > /proc/sys/dev/raid/speed_limit_max

The default speed limit is 10000, that's what you are getting.
So you have reached a software imposed limit, not a hardware limit.


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of James R Bamford
Sent: Tuesday, November 18, 2003 5:05 PM
To: linux-raid@vger.kernel.org
Subject: Is my raid setup speed ok?!

Just resyncing my full partitions now hopefully ready for use now that i've
got a grasp of how its working.. i've posted before but here is the current
progress on it sync-ing

[root@backup root]# cat /proc/mdstat
Personalities : [raid1]
read_ahead 1024 sectors
md0 : active raid1 hdg1[1] hde1[0]
      156288256 blocks [2/2] [UU]
      [====>................]  resync = 24.8% (38889996/156288256)
finish=195.6min speed=10001K/sec
unused devices: <none>

the speed varies but its around 10000k/sec

This is driven off a Promise Ultra 100 ATA controller.. a p3 450mhz ~450meg
ram (a weak link possibly), and

2 x 160gig Samsung SP1614N drives with 8meg cache

just ran hdparm to check dma was on

[root@backup root]# hdparm /dev/hde

/dev/hde:
 multcount    = 16 (on)
 IO_support   =  0 (default 16-bit)
 unmaskirq    =  0 (off)
 using_dma    =  1 (on)
 keepsettings =  0 (off)
 readonly     =  0 (off)
 readahead    =  8 (on)
 geometry     = 19457/255/63, sectors = 312581808, start = 0

[root@backup root]# hdparm /dev/hdg

/dev/hdg:
 multcount    = 16 (on)
 IO_support   =  0 (default 16-bit)
 unmaskirq    =  0 (off)
 using_dma    =  1 (on)
 keepsettings =  0 (off)
 readonly     =  0 (off)
 readahead    =  8 (on)
 geometry     = 19457/255/63, sectors = 312581808, start = 0

Is this speed normal.. someone told me drives can get up to 20-30meg/s ..
I'd of expected my drives to be near to that.. I get very good performance
with these drives in my other machines.. just wondering if its quite low...
if there is anything i can do to change this!? what kind of speeds have
other people had with IDE drives?

Thanks

Jim

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


