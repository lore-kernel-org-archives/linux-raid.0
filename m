From: Eric Pretorious <eric@pretorious.net>
Subject: mdstat: resync=DELAYED
Date: Mon, 27 Jun 2005 14:25:36 -0700
Message-ID: <200506271425.36814.eric@pretorious.net>
Reply-To: eric@pretorious.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, All:

I'm configuring a SuperMicro 5013CM8 (with on-board Adaptec AIC-7902B U320 
SCSI controller controlling two Seagate ST373207LC 73GB U320 hard-drives) and 
am experiencing random crashes: The system ocassionally blurts out a bunch of 
stuff about the SCSI system and then freezes.

Checking the contents of /proc/mdstat I see a potential red-flag:

%> cat /proc/mdstat
Personalities : [raid1]
read_ahead 1024 sectors
Event: 5
md2 : active raid1 sdb1[1] sda1[0]
      48064 blocks [2/2] [UU]
        resync=DELAYED
md0 : active raid1 sdb2[1] sda2[0]
      7341632 blocks [2/2] [UU]
        resync=DELAYED
md1 : active raid1 sdb3[1] sda3[0]
      10482304 blocks [2/2] [UU]
        resync=DELAYED
md3 : active raid1 sdb6[1] sda6[0]
      1052160 blocks [2/2] [UU]
        resync=DELAYED
md4 : active raid1 sdb7[1] sda7[0]
      50660864 blocks [2/2] [UU]
      [======>..............]  resync = 30.4% (15410224/50660864) 
finish=56.9min speed=10315K/sec

What does this mean? How can I fix it?

-- 
Eric P.,
Truckee, CA
