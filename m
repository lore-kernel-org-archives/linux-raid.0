From: Catalin BOIE <util@deuroconsult.ro>
Subject: 2.422 + RAID 1 + SATA + 2 disks => no maximum speed
Date: Fri, 29 Aug 2003 07:35:09 +0300 (EEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0308290730560.31668@hosting.rdsbv.ro>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

I have a machine with 2 SATA disks on 2 separate buses.
hdparm /dev/hda reports 50MB/s
hdparm /dev/hdb reports 50MB/s

I created a raid1 array with hda3 and hdc3, same partition sizes.

If I do hdparm /dev/md0 it reports 50MB/s

If I do cat /dev/md0 > /dev/null, vmstat reports 50MB/s
If I start two command like above, simultaneously I get 100MB/s.

Why I don't get 100MB/s on a single cat command?
Thank you very much!

---
Catalin(ux) BOIE
catab@deuroconsult.ro
