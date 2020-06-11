From: Robert Kudyba <rkudyba@fordham.edu>
Subject: Recovering a failed software RAI, where does parallel -j0 dd to?
Date: Wed, 10 Jun 2020 22:55:45 -0400
Message-ID: <CAFHi+KQCDok8bRTWTZcDGpOkdBvbH+szC5=qK0PZz2okdULsNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm trying to go through
https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID
echo $DEVICES
/dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
parallel -j0 dd if={} of=/dev/null bs=1M ::: $DEVICES

dd: error reading '/dev/sdd1': Input/output error
23510+1 records in
23510+1 records out
24652464128 bytes (25 GB, 23 GiB) copied, 173.685 s, 142 MB/s

Or is that just doing a scan and just checking which drive are bad? I
sure would like to get that 25GB back. Is that possible?

I also see this:
ddrescue -r 3 /dev/old /dev/new my_log
ddrescue -R -r 3 /dev/old /dev/new my_log

Can I just use a mount point for /dev/new?
