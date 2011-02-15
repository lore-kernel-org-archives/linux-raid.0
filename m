From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: failed to write superblock errors, and more!
Date: Mon, 14 Feb 2011 22:00:46 -0600
Message-ID: <AANLkTinedfgQ5xjqKvM_v3Y6D2Fz=Eq0H1ZjmTcLuz+C@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm wondering what's going on here:

turnip:~ # mdadm /dev/md1 --create --level=1 --bitmap=internal
--raid-devices=2 /dev/sdd1 missing
mdadm: array /dev/md1 started.
turnip:~ # mdadm /dev/md2 --create --level=1 --bitmap=internal
--raid-devices=2 /dev/md1 missing
mdadm: failed to write superblock to /dev/md1
mdadm: array /dev/md2 started.
turnip:~ # mdadm /dev/md2 --stop
turnip:~ # mdadm --zero-superblock /dev/md1
mdadm: Couldn't open /dev/md1 for write - not zeroing
turnip:~ # mdadm /dev/md1 --stop
turnip:~ # mdadm --zero-superblock /dev/sdd1
mdadm: Couldn't open /dev/sdd1 for write - not zeroing
turnip:~ # mdadm /dev/md2 --stop
turnip:~ # mdadm /dev/md2 --stop --force
turnip:~ # ls /sys/block/md1/holders/
md2
turnip:~ #

The kernel is 2.6.34.7-0.7-default (x86_64).  openSUSE 11.3.
mdadm 3.0.3

-- 
Jon
