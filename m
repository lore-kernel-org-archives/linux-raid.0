From: Jeremy Graham <jeremy@doghouse.agency>
Subject: Re: mdadm stuck at 0% reshape after grow
Date: Thu, 7 Dec 2017 19:40:32 +1100
Message-ID: <CAGx2nv6Nx5VuWfL46SDmMsysq+UGTb=uf3egi1ud5yHnKP-M1Q@mail.gmail.com>
References: <CAGx2nv6cZ85YCrUQsCBWfojFxOyqW4=+5OaCqU1Gf0UX=T3Gbg@mail.gmail.com>
 <1865221512489329@web5g.yandex.ru> <d34ebd38-47e5-35bc-5ee6-0da194ce1901@turmel.org>
 <CAGx2nv6YAc5jBL36K0oNG=tE5J3TNXGMvTvD9ZvcZYthXe9Y5g@mail.gmail.com>
 <20171206104905.GA4383@metamorpher.de> <61c9e4bd-1605-5b17-80ce-c738b80b7058@turmel.org>
 <20171206160346.GA5806@metamorpher.de> <1b43be27-f21a-1fba-f983-01c5356a654d@turmel.org>
 <3235751512584694@web9j.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3235751512584694@web9j.yandex.ru>
Sender: linux-raid-owner@vger.kernel.org
To: 002@tut.by
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org, Andreas Klauer <andreas.klauer@metamorpher.de>
List-Id: linux-raid.ids

A huge thank you to all who gave advice!! The issue was the BBL

I decided to just run with a --update=force-no-bbl for a few reasons
* I was sure those bad blocks were read errors generated a long time
ago due to a faulty SATA cable
* Since then I have noted a couple of corrupt files but nothing of
importance and I just generally delete anything corrupt anyway
* Anything irreplaceable on the raid was backed up elsewhere
* I did not trust myself with finding + fixing the bad blocks
manually, and felt it might just get me into more trouble
* Almost anything that touched the raid while active was hanging the
terminal (even a fdisk -l) making trying things painful

So cowboy style I just ran
mdadm --assemble --update=force-no-bbl -v /dev/md0 /dev/sd[fgdecb]1

And Boom! it started doing its thing without a hiccup. About 12h on a
reshape, then 6hr on a resync, after that I did a "fsck.ext4 -f
/dev/md0" with no issues found, so a "resize2fs /dev/md0" and finally
a mount. I have since tested a heap of data and hasn't missed a beat.

mdadm --examine isn't reporting bad blocks anymore, not sure if they
are silently waiting to cause me problems in the future but appears ok
for now.

Thanks again for all the help and advice!

Nice to see my array healthy again :)

$ mdadm --detail /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Sun Dec  2 12:04:24 2012
     Raid Level : raid5
     Array Size : 14651317760 (13972.59 GiB 15002.95 GB)
  Used Dev Size : 2930263552 (2794.52 GiB 3000.59 GB)
   Raid Devices : 6
  Total Devices : 6
    Persistence : Superblock is persistent

    Update Time : Thu Dec  7 19:26:53 2017
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : homer2:1
           UUID : f39f89d2:1bcd3d55:d173d206:d85b8bbc
         Events : 4835083

    Number   Major   Minor   RaidDevice State
       8       8       81        0      active sync   /dev/sdf1
       6       8       97        1      active sync   /dev/sdg1
       5       8       49        2      active sync   /dev/sdd1
       9       8       65        3      active sync   /dev/sde1
       7       8       33        4      active sync   /dev/sdc1
      10       8       17        5      active sync   /dev/sdb1

$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0]
[raid1] [raid10]
md0 : active raid5 sdd1[5] sdc1[7] sdb1[10] sde1[9] sdg1[6] sdf1[8]
      14651317760 blocks super 1.2 level 5, 512k chunk, algorithm 2
[6/6] [UUUUUU]

unused devices: <none>

end<div id="DAB4FAD8-2DD7-40BB-A1B8-4E2AA1F9FDF2"><br />
<table style="border-top: 1px solid #D3D4DE;">
	<tr>
        <td style="width: 55px; padding-top: 13px;"><a
href="http://www.avg.com/email-signature?utm_medium=email&utm_source=link&utm_campaign=sig-email&utm_content=webmail"
target="_blank"><img
src="https://ipmcdn.avast.com/images/icons/icon-envelope-tick-green-avg-v1.png"
alt="" width="46" height="29" style="width: 46px; height: 29px;"
/></a></td>
		<td style="width: 470px; padding-top: 12px; color: #41424e;
font-size: 13px; font-family: Arial, Helvetica, sans-serif;
line-height: 18px;">Virus-free. <a
href="http://www.avg.com/email-signature?utm_medium=email&utm_source=link&utm_campaign=sig-email&utm_content=webmail"
target="_blank" style="color: #4453ea;">www.avg.com</a>
		</td>
	</tr>
</table><a href="#DAB4FAD8-2DD7-40BB-A1B8-4E2AA1F9FDF2" width="1"
height="1"></a></div>
