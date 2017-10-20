From: Alex Elder <elder@ieee.org>
Subject: 3-disk RAID5 won't assemble
Date: Fri, 20 Oct 2017 14:51:02 -0500
Message-ID: <03ddf14a-845d-a6a6-714d-e4bacb77dd7a@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-CA
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a 3-disk RAID5 with identical drives that won't assemble.

The event counts on two of them are the same (20592) and one is
quite a bit less (20466).  I do not expect failing hardware.

The problem occurred while I was copying some large files to
the XFS volume on the device, while doing something else that
ate up all my memory.  (It was a long time ago so I that's
about as much detail as I can provide--I assumed the OOM killer
ultimately was to blame, somehow.)

It *sounds* like the two drives with the same event count should
be enough to recover my volume.  But forcibly doing that is scary
so I'm writing here for encouragement and guidance.

  {1156} root@meat-> mdadm --stop /dev/md0
  mdadm: stopped /dev/md0
  {1157} root@meat-> mdadm --assemble /dev/md0 /dev/sd[bcd]1
  mdadm: /dev/md0 assembled from 2 drives - not enough to start the
array  while not clean - consider --force.
  {1158} root@meat->

I can provide plenty more information, but thought I'd start by
introducing the problem.

How should I proceed?  Thanks.

					-Alex
