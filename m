From: Catalin BOIE <util@deuroconsult.ro>
Subject: 2.4.22 + RAID 1 + SATA + 2 disks => no maximum speed
Date: Fri, 5 Sep 2003 08:01:31 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0309050757360.18124@hosting.rdsbv.ro>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: linux-admin@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Hi!

I have a machine with 2 SATA disks on 2 separate buses.
hdparm -t /dev/hda reports 50MB/s
hdparm -t /dev/hdb reports 50MB/s

I created a raid1 array with hda3 and hdc3, same partition sizes.

If I do hdparm -t /dev/md0 it reports 50MB/s

If I do cat /dev/md0 > /dev/null, vmstat reports 50MB/s
If I start another cat /dev/md0 > /dev/null, in another console, I get
100MB/s from vmstat.

Why I don't get 100MB/s on a single cat command?


Some other test:
cat /dev/hda3 > /dev/null&
cat /dev/hdc3 > /dev/null&
vmstat shows 100MB/s.

Also, seems that writing is very slow (8MB/s).

Any ideas?

Thank you very much!

---
Catalin(ux) BOIE
catab@deuroconsult.ro
