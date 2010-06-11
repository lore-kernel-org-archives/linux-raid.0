From: "Graham Mitchell" <gmitch@woodlea.com>
Subject: RE: RAID6 and crashes (reporting back re. --bitmap)
Date: Fri, 11 Jun 2010 08:25:22 -0400
Message-ID: <003e01cb0961$2a556bb0$7f004310$@woodlea.com>
References: <4C1128C2.4020105@meetinghouse.net> <20100611005743.43664e5b@natsu> <4C11578B.8010202@meetinghouse.net> <20100611034108.6a2cdbc4@natsu> <4C1169CB.1030903@meetinghouse.net> <20100611085112.5f33b06f@natsu> <4C11BFB7.7050907@meetinghouse.net> <20100611150811.3c3f03bb@notabene.brown> <4C12199F.60108@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C12199F.60108@xs4all.nl>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: 'Miles Fidelman' <mfidelman@meetinghouse.net>, 'Neil Brown' <neilb@suse.de>, 'John Hendrikx' <hjohn@xs4all.nl>
List-Id: linux-raid.ids

> I was interested as well, so I ran this command:
> 


I also was interested, and did mdadm -X /dev/md0, and this is my output...

mdadm -X /dev/md0
        Filename : /dev/md0
           Magic : 00000000
mdadm: invalid bitmap magic 0x0, the bitmap file appears to be corrupted
         Version : 0
mdadm: unknown bitmap version 0, either the bitmap file is corrupted or you
need to upgrade your tools



mdadm --version
mdadm - v3.0.3 - 22nd October 2009


uname -a
Linux file00bert.woodlea.org.uk 2.6.32.12-115.fc12.i686.PAE #1 SMP Fri Apr
30 20:14:08 UTC 2010 i686 i686 i386 GNU/Linux

cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid6 sdh1[0] sda1[14] sdp1[13] sdg1[12] sdo1[11] sdf1[10]
sdk1[9] sdn1[8] sde1[7] sdj1[6] sdm1[5] sdd1[4] sdi1[3] sdl1[2] sdc1[1]
      6348985344 blocks super 1.2 level 6, 512k chunk, algorithm 2 [15/15]
[UUUUUUUUUUUUUUU]
      bitmap: 0/2 pages [0KB], 131072KB chunk

unused devices: <none>




