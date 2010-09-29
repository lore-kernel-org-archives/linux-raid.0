From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: raid5+hotspare: request for recommended procedure
Date: Wed, 29 Sep 2010 11:03:39 +0200
Message-ID: <4CA300EB.1070909@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Greets, raid-users,

I would like to ask for hints on how to proceed.

I have a customers server ~500kms away ... running 2 raid5-arrays w/
hotspare:

# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]
md1 : active raid1 sdb1[1] sda1[0]
      104320 blocks [2/2] [UU]

md3 : active raid5 sdd3[3](S) sdc3[2] sdb3[1] sda3[0]
      15647104 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

md4 : active raid5 sdd4[3](S) sdc4[2] sdb4[1] sda4[0]
      471941376 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

unused devices: <none>


sdb shows errors:

197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always
      -       13
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       13

--

The customer would now take the server with him and bring it to a fellow
technician who could take out sdb, clone it to a new hdd and re-insert it.

This would be plan A.

Plan B would be that I mark sdb failed now and let the raids rebuild. I
fear that a second hdd might fail when doing this.

All Seagate-drives:

sda, sdb: ST3250310NS
sdc, sdd: ST3250621NS

I also ran a "echo check > /sys/block/mdX/md/sync_action" because this
had helped to remove those errors at another server, unfortunately it
did not help here.

Could you please advise what the better and safer alternative would be?

Thanks a lot, Stefan
