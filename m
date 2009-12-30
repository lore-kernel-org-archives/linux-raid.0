From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID 1 Disk added as faulty
Date: Wed, 30 Dec 2009 00:39:38 -0600
Message-ID: <6E.31.08392.1B5FA3B4@cdptpa-omtalb.mail.rr.com>
References: <20091230164203.12fcfe61@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091230164203.12fcfe61@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@suse.de>
Cc: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> As for why you cannot add the PATA drive - it seems to fail, implying a
> write error when writing to it???

	It doesn't seem to fail.  I can add it without the Write mostly
switch and it does fine...

	Well, I'll be hornswaggled!  I just tried it again and this time it
worked.  I tried it several times before on all three partitions, and it
would always mark the partition faulty when I used the -W switch.

> More info (logs etc) required.

	When I looked previously and again just now, I don't see anything
unusual from then:

Dec 23 11:36:24 Backup kernel: [  551.023531] md: recovery of RAID array md1
Dec 23 11:36:24 Backup kernel: [  551.023531] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Dec 23 11:36:24 Backup kernel: [  551.023531] md: using maximum available
idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
Dec 23 11:36:24 Backup kernel: [  551.023531] md: using 128k window, over a
total of 6144816 blocks.
Dec 23 11:37:04 Backup kernel: [  595.374568] md: bind<hda2>
Dec 23 11:37:05 Backup kernel: [  595.686827] md: delaying recovery of md2
until md1 has finished (they share one or more physical units)
Dec 23 11:37:16 Backup kernel: [  608.666908] md: bind<hda3>
Dec 23 11:37:17 Backup kernel: [  608.951395] md: delaying recovery of md3
until md1 has finished (they share one or more physical units)
Dec 23 11:43:28 Backup kernel: [ 1014.009182] md: md1: recovery done.
Dec 23 11:43:28 Backup kernel: [ 1014.117880] md: delaying recovery of md3
until md2 has finished (they share one or more physical units)
Dec 23 11:43:28 Backup kernel: [ 1014.117493] md: recovery of RAID array md2
Dec 23 11:43:28 Backup kernel: [ 1014.117496] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Dec 23 11:43:28 Backup kernel: [ 1014.117498] md: using maximum available
idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
Dec 23 11:43:28 Backup kernel: [ 1014.117502] md: using 128k window, over a
total of 277442414 blocks.
Dec 23 18:11:30 Backup kernel: [25686.451020] md: md2: recovery done.
Dec 23 18:11:30 Backup kernel: [25686.627333] md: recovery of RAID array md3
Dec 23 18:11:30 Backup kernel: [25686.627333] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Dec 23 18:11:30 Backup kernel: [25686.627333] md: using maximum available
idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
Dec 23 18:11:30 Backup kernel: [25686.627333] md: using 128k window, over a
total of 204796548 blocks.
Dec 23 22:16:36 Backup kernel: [41884.541659] md: md3: recovery done.

