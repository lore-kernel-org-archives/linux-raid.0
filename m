From: "James R Bamford" <jim@jimtreats.com>
Subject: Is my raid setup speed ok?!
Date: Tue, 18 Nov 2003 22:05:01 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <PPEOJEIEFLAONFNHJPOOOEIAGOAA.jim@jimtreats.com>
References: <Pine.LNX.4.56.0311181431340.11397@nemesis.cs.yorku.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0311181431340.11397@nemesis.cs.yorku.ca>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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

