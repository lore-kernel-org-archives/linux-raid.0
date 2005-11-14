From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: raid5 recovery fails
Date: Mon, 14 Nov 2005 21:27:25 +0200
Message-ID: <5d96567b0511141127v63377f0and41f998230a38dd7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
Cc: raziebe@gmail.com
List-Id: linux-raid.ids

I have made the following test with my raid5:
1. created raid5 with 4 sata disks.
2. waited untill raid was fully initialized.
3. pulled a disk from the panel.
4. shut the system.
5. put back the disk.
6. turn on the system.

The raid failed failed to recver. i got message from the md layer
saying that it rejects the dirty disk.
Anyone ?
--
Raz
