From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Check not actually reading drives
Date: Wed, 28 Mar 2012 18:19:11 -0500
Message-ID: <4F739C6F.5040701@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I just loaded 3.3.0-4.fc16.x86_64 and started a check by running...

echo check > /sys/block/md1/md/sync_action

I'm getting the following from mdstat:

md1 : active raid5 sdl2[8] sde2[1] sdf2[4] sda2[9] sdb2[10] sdc2[3]
sdd2[0] sdk2[6]
      2180641792 blocks super 1.2 level 5, 64k chunk, algorithm 2 [8/8]
[UUUUUUUU]
      [==>..................]  check = 14.9% (46442632/311520256)
finish=21.9min speed=201328K/sec

I can tell you for certain that these drives are not able to do 200MB/s.
Further, iostat shows no disk activity (other than normal usage).

mdadm - v3.2.3 - 23rd December 2011

Do I just need to wait for a new kernel from Fedora?

--Larkin
