From: "Sandu Mihai" <mihai.sandu@kpnqwest.ro>
Subject: Raid Persistent Superblock Question..
Date: Sun, 19 Jan 2003 22:50:58 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <006301c2bffc$77e2c7d0$c7e60c0a@mihaisandu2>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Is there any tool that can help someone edit the persistent superblock of a
partition/device that is a member of an RAID array?

Problem:
    I have md0 - raid1 - /dev/sda1 + /dev/sdb1 + persistent-superblock 1
md0 happens to be my / partition.
    If I will insert another two disks in that box (/dev/sdd, /dev/sdc  with
/dev/sdc1, /dev/sdd1 being members of md0 RAID1 array, the disks are from
another box..) the kernel will mess-up the things, by 'autodetecting' the
newly added disks as md0, and not _my_ disks.
    If I could alter the superblock info on the newly added disks, well,
that will be good.
So far, no HOWTO, and no docs mention the existence of a tool like this (you
can only query the superblock, and that is all..)

Best regards,
    Sandu Mihai - KPNQwest Romania Network Engineer

