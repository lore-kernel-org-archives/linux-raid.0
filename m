From: Mark Kolama <indigo8472@gmail.com>
Subject: 4 disks outage in RAID6
Date: Sat, 20 Dec 2014 18:03:05 +0100
Message-ID: <CAMvZ8g5dv-eXrgTAr58ib06LM+NhzbY7hkmFxaH7V71iL8Eg+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear List,

due to a controller failure, a raid6 with 16 drives
lost 4 drives at once. The failure was noticed a few days later.

a examine output of all 16 drive is listed at
http://pastebin.com/4WH9xp7K

As you can see the event count differs on 4 drives with
about 150 comparing to the other 12 drives.

I have already tried:
mdadm --assemble --scan:
assembled from 12 drives - not enough to start the array.

Then i tried:
mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
/dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1
/dev/sdl1 /dev/sdm1 /dev/sdn1 /dev/sdo1 /dev/sdp1 --force

/proc/mdstat after that:

Personalities : [raid6] [raid5] [raid4]
md0 : inactive sda1[0](S) sdp1[15](S) sdo1[14](S) sdn1[13](S)
sdm1[12](S) sdl1[11](S) sdk1[10](S) sdj1[9](S) sdi1[8](S) sdh1[7](S)
sdg1[6](S) sdf1[5](S) sde1[4](S) sdd1[3](S) sdc1[2](S) sdb1[1](S)
      62353932288 blocks super 1.2

No success either.

So the next try would be recreating the array ?

Any help is appreciated, thanks in advance.

Mark
