From: Mike Hartman <mike@hartmanipulation.com>
Subject: New RAID causing system lockups
Date: Sat, 11 Sep 2010 14:20:40 -0400
Message-ID: <AANLkTimTvPupaPuFbfpcCGC=0Ys9fQWihAgaADsrowqq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

PART 3:

Update:

I'm even more concerned about this now, because I just started the
newest reshaping to add a new drive with:

mdadm --grow -c 256 --raid-devices=5 --backup-file=/grow_md0.bak /dev/md0

And the system output:

mdadm: Need to backup 768K of critical section..

cat /proc/mdstat shows the reshaping is proceeding,

Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active raid6 sdi1[0] sdf1[5] md1p1[4] sdj1[3] sdh1[1]
      2929691136 blocks super 1.2 level 6, 128k chunk, algorithm 2 [5/5] [UUUUU]
      [>....................]  reshape =  0.0% (56576/1464845568)
finish=2156.9min speed=11315K/sec

md1 : active raid0 sdg1[0] sdk1[1]
      1465141760 blocks super 1.2 128k chunks

unused devices: <none>

but I've checked for /grow_md0.bak and it's not there. So it looks
like for some reason it ignored my backup file option.

This scares me, because if I experience the lockup again and am forced
to reboot, without a backup file I'm afraid my array will be hosed.
I'm also afraid to stop it cleanly right now for the same reason.

So in addition to fixing the lockup itself, does anyone know if
there's a way to either cancel this reshaping or belatedly add the
backup file in a different way so it will be recoverable? It's only at
1% and says it will take another 2193 minutes.

Mike
