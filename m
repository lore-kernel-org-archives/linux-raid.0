From: "BO MOON" <bmoon@anthologysolutions.com>
Subject: Raid0 or Raid1 READ performance
Date: Thu, 16 Dec 2004 13:49:53 -0800
Message-ID: <000401c4e3b9$2cef1f20$040a10ac@asitest>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I tested and measured the Copy performance using "time cp".
My system Config:  Redhat9.0, RocketRAID404 HPT374 card,

            Hdd1  ---> /mnt/disk1
            Hdd2, Hdd3, Hdd4 -->  RAID0  : /mnt/disk2
OR
            Hdd1  ------> /mnt/disk1
            Hdd3, Hdd4 --> RAID1  : /mnt/disk2

I got the almost same performance on WRITE( disk1 --> disk2) and 
                              READ  ( disk2 -> disk1).
   EX: >time cp disk1/2gfile disk2,        >time cp disk2/2gfile disk1

I am expecting the faster performance on READ than WRITE because of
parallel read from disks more than 2(2 for RAID1, 3 for RAID0) at the
same time.

I heard that old linux ide driver did not support this parallelism but
must be fixed by now(linux2.4.20 or greater).

Any suggestion or opinion?

Thanks,

Bo



