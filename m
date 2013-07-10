From: Ole Tange <tange@binf.ku.dk>
Subject: Re-shape raid0 acts up
Date: Wed, 10 Jul 2013 13:56:49 +0200
Message-ID: <CANU9nT=Fz0QkBm6FQkTcfN_iZk9BC_fhDRacXUKs=0SJ33H_zQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I tested reshaping a raid0 on 2 devices to 4 devices.

It seems the reshape first converted to RAID4 and then quickly
converted to RAID0.

I have now done that on a bigger array. The only change that I am aware of is:

* The 2+2 devices are much larger (25 TB each compared to 1 GB each)
* The system has crashed during the reshape

So right now the system looks like this:

Personalities : [raid6] [raid5] [raid4]
md3 : active raid4 md1[0] md5[3] md4[4] md2[1]
      109396484096 blocks super 1.2 level 4, 512k chunk, algorithm 0
[5/4] [UUUU_]

which looks like the RAID4 just before the final step.

I then tried:

# mdadm --grow /dev/md3 -n 4 -l 0 --backup-file reshape.bak

But that seems to cause the reshape to go through the full 100 TB again:

root@lemaitre:/lemaitre-internal# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md3 : active raid4 dm-0[0] dm-3[3] dm-2[4] dm-1[1]
      109396484096 blocks super 1.2 level 4, 512k chunk, algorithm 0
[5/4] [UUUU_]
      [>....................]  reshape =  0.0% (28100/27349121024)
finish=32428.7min speed=14050K/sec

So I cancelled that and rolled back to the situation before (this was
possible because I ran this on overlay files):

Personalities : [raid6] [raid5] [raid4]
md3 : active raid4 md1[0] md5[3] md4[4] md2[1]
      109396484096 blocks super 1.2 level 4, 512k chunk, algorithm 0
[5/4] [UUUU_]

Can I convert that to RAID0? Can I do that without having to wait the
2-3 weeks a full reshape takes?


/Ole
