From: "MediaHost \(TM\)" <webmaster@startcom.org>
Subject: Continued from Difference between faulty and non-fresh
Date: Sun, 8 Aug 2004 03:15:01 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <0d6801c47ce5$24403840$0200a8c0@internal.startcom.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was reading some entries in the archive and run the following:

mdctl --assemble --force /dev/md3 /dev/hda2 /dev/hde1 /dev/hdg1

But now I get this when I run lsraid -R -a /dev/md3 -d /dev/hda2

raiddev /dev/md3
        raid-level              5
        nr-raid-disks           3
        nr-spare-disks          0
        persistent-superblock   1
        chunk-size              64

        device          /dev/hda2
        raid-disk               0
        device          /dev/hde1
        spare-disk              0
        device          /dev/null
        failed-disk             1
        device          /dev/null
        failed-disk             2

From where comes the spare-disk and why are there suddenly 4 devices listed?
My /etc/raidtab list the following:

raiddev             /dev/md3
raid-level                  5
nr-raid-disks               3
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
device      /dev/hda2
raid-disk     0
device      /dev/hde1
raid-disk     1
device      /dev/hdg1
raid-disk     2

What now? When running raidstart I get:

Aug  8 03:37:22 apache-7 kernel: md: running: <hda2><hde1><hdg1>
Aug  8 03:37:22 apache-7 kernel: md: hda2's event counter: 0000009a
Aug  8 03:37:22 apache-7 kernel: md: hde1's event counter: 00000099
Aug  8 03:37:22 apache-7 kernel: md: hdg1's event counter: 00000096
Aug  8 03:37:22 apache-7 kernel: md: superblock update time inconsistency -- 
using the most recent one
Aug  8 03:37:22 apache-7 kernel: md: freshest: hda2
Aug  8 03:37:22 apache-7 kernel: md: kicking non-fresh hdg1 from array!
Aug  8 03:37:22 apache-7 kernel: md: unbind<hdg1,2>
Aug  8 03:37:22 apache-7 kernel: md: export_rdev(hdg1)
Aug  8 03:37:22 apache-7 kernel: md: md3: raid array is not clean -- 
starting background reconstruction
Aug  8 03:37:22 apache-7 kernel: md3: max total readahead window set to 512k
Aug  8 03:37:22 apache-7 kernel: md3: 2 data-disks, max readahead per
data-disk: 256k
Aug  8 03:37:22 apache-7 kernel: raid5: device hda2 operational as raid disk
0
Aug  8 03:37:22 apache-7 kernel: raid5: spare disk hde1
Aug  8 03:37:22 apache-7 kernel: raid5: not enough operational devices for
md3 (2/3 failed)
Aug  8 03:37:22 apache-7 kernel: RAID5 conf printout:
Aug  8 03:37:22 apache-7 kernel:  --- rd:3 wd:1 fd:2
Aug  8 03:37:22 apache-7 kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:hda2
Aug  8 03:37:22 apache-7 kernel:  disk 1, s:1, o:0, n:1 rd:1 us:1 dev:hde1
Aug  8 03:37:22 apache-7 kernel:  disk 2, s:0, o:0, n:2 rd:2 us:1 dev:[dev
00:00]
Aug  8 03:37:22 apache-7 kernel: raid5: failed to run raid set md3



Regards

Signer:      Eddy Nigg
Company: StartCom Linux at http://www.startcom.org
                MediaHostT at http://www.mediahost.org


