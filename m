From: "MediaHost \(TM\)" <webmaster@startcom.org>
Subject: Difference between faulty and non-fresh
Date: Sun, 8 Aug 2004 01:41:41 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <0d4901c47cd8$1a46e350$0200a8c0@internal.startcom.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I had a multiple disk failure (so it seams) on raid 5 Kernel 4.20 RedHat 9.

When booting it shows:

Aug  7 21:32:20 apache-7 kernel: md: running: <hda2><hde1><hdg1>
Aug  7 21:32:20 apache-7 kernel: md: hda2's event counter: 0000009a
Aug  7 21:32:20 apache-7 kernel: md: hde1's event counter: 00000099
Aug  7 21:32:20 apache-7 kernel: md: hdg1's event counter: 00000096
Aug  7 21:32:20 apache-7 kernel: md: superblock update time inconsistency -- 
using the most recent one
Aug  7 21:32:20 apache-7 kernel: md: freshest: hda2
Aug  7 21:32:20 apache-7 kernel: md: kicking non-fresh hdg1 from array!
Aug  7 21:32:20 apache-7 kernel: md: unbind<hdg1,2>
Aug  7 21:32:20 apache-7 kernel: md: export_rdev(hdg1)
Aug  7 21:32:20 apache-7 kernel: md3: kicking faulty hde1!
Aug  7 21:32:20 apache-7 kernel: md: unbind<hde1,1>
Aug  7 21:32:20 apache-7 kernel: md: export_rdev(hde1)
Aug  7 21:32:20 apache-7 kernel: md: md3: raid array is not clean -- 
starting background reconstruction
Aug  7 21:32:20 apache-7 kernel: md3: max total readahead window set to 512k
Aug  7 21:32:20 apache-7 kernel: md3: 2 data-disks, max readahead per
data-disk: 256k
Aug  7 21:32:20 apache-7 kernel: raid5: device hda2 operational as raid disk
0
Aug  7 21:32:20 apache-7 kernel: raid5: not enough operational devices for
md3 (2/3 failed)
Aug  7 21:32:20 apache-7 kernel: RAID5 conf printout:
Aug  7 21:32:20 apache-7 kernel:  --- rd:3 wd:1 fd:2
Aug  7 21:32:20 apache-7 kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:hda2
Aug  7 21:32:20 apache-7 kernel:  disk 1, s:0, o:0, n:1 rd:1 us:1 dev:[dev
00:00]
Aug  7 21:32:20 apache-7 kernel:  disk 2, s:0, o:0, n:2 rd:2 us:1 dev:[dev
00:00]

What is the difference between non-fresh and faulty? Also when I run lsraid,
it shows /dev/hdg1 as /dev/null...

How do I recover the raid, which one should I mark failed-disk? Very
unclear, after googeling for a few hours now...

Thanks!

Regards

Signer:      Eddy Nigg
Company: StartCom Linux at http://www.startcom.org
                MediaHostT at http://www.mediahost.org


