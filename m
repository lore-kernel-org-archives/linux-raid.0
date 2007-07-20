From: mullaly <mullaly@hotmail.com>
Subject: A raid in a raid.
Date: Fri, 20 Jul 2007 07:52:28 -0700 (PDT)
Message-ID: <11709647.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

I have a raid array setup with 6 sata drives (500gb) and 4 ide drives
(250gb). My intention was to setup the disks as follows.
Personalities : [raid0] [raid6] [raid5] [raid4]
md2 : active raid6 md1[6](S) md0[7] sda[0] sdf[5] sde[4] sdd[3] sdc[2]
sdb[1]
      2930318976 blocks level 6, 64k chunk, algorithm 2 [8/6] [UUUUUU__]
      [>....................]  recovery =  0.0% (249556/488386496)
finish=880.0min speed=9242K/sec

md1 : active raid0 hdh[0] hdc[1]
      488396928 blocks 64k chunks

md0 : active raid0 hde[0] hdb[1]
      488396928 blocks 64k chunks

unused devices: <none>

All works well until a system reboot. md2 appears to be brought up before
md0 and md1 which causes the raid to start without two of its drives.

Is there anyway to fix this?
-- 
View this message in context: http://www.nabble.com/A-raid-in-a-raid.-tf4117582.html#a11709647
Sent from the linux-raid mailing list archive at Nabble.com.

