From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: RAID1, changed disk, 2nd has errors ...
Date: Fri, 26 Aug 2011 14:44:53 +0200
Message-ID: <4E579545.2030306@xunil.at>
References: <4E5787A1.7080807@xunil.at> <CADNH=7HMgJ9+wCEH5i03L6UmQw2xnMopnx09z8W0nU-q6_0Dig@mail.gmail.com> <4E578F4D.9050908@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E578F4D.9050908@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
List-Id: linux-raid.ids


Additional stuff letting me hope for a valid array:

# grep md /var/log/messages

Aug 26 11:22:02 horde mdadm[3739]: RebuildFinished event detected on md
device /dev/md/1
Aug 26 11:22:02 horde mdadm[3739]: SpareActive event detected on md
device /dev/md/1, component device /dev/sdb3
Aug 26 11:22:02 horde mdadm[3739]: RebuildStarted event detected on md
device /dev/md/2
Aug 26 12:12:02 horde mdadm[3739]: Rebuild20 event detected on md device
/dev/md/2
Aug 26 12:42:53 horde kernel: ata1.00: cmd
25/00:00:b5:73:12/00:04:28:00:00/e0 tag 0 dma 524288 in
Aug 26 12:42:59 horde kernel: ata1.00: cmd
25/00:00:b5:73:12/00:04:28:00:00/e0 tag 0 dma 524288 in
Aug 26 12:43:05 horde kernel: ata1.00: cmd
25/00:00:b5:73:12/00:04:28:00:00/e0 tag 0 dma 524288 in
Aug 26 12:43:09 horde kernel: ata1.00: cmd
25/00:00:b5:73:12/00:04:28:00:00/e0 tag 0 dma 524288 in
Aug 26 12:43:12 horde kernel: ata1.00: cmd
25/00:00:b5:73:12/00:04:28:00:00/e0 tag 0 dma 524288 in
Aug 26 12:43:15 horde kernel: ata1.00: cmd
25/00:00:b5:73:12/00:04:28:00:00/e0 tag 0 dma 524288 in
Aug 26 12:43:19 horde kernel: ata1.00: cmd
25/00:08:fd:73:12/00:00:28:00:00/e0 tag 0 dma 4096 in
Aug 26 12:43:22 horde kernel: ata1.00: cmd
25/00:08:fd:73:12/00:00:28:00:00/e0 tag 0 dma 4096 in
Aug 26 12:43:25 horde kernel: ata1.00: cmd
25/00:08:fd:73:12/00:00:28:00:00/e0 tag 0 dma 4096 in
Aug 26 12:43:28 horde kernel: ata1.00: cmd
25/00:08:fd:73:12/00:00:28:00:00/e0 tag 0 dma 4096 in
Aug 26 12:43:31 horde kernel: ata1.00: cmd
25/00:08:fd:73:12/00:00:28:00:00/e0 tag 0 dma 4096 in
Aug 26 12:43:34 horde kernel: ata1.00: cmd
25/00:08:fd:73:12/00:00:28:00:00/e0 tag 0 dma 4096 in
Aug 26 12:43:34 horde kernel: md/raid1:md2: sda: unrecoverable I/O read
error for block 643686144
Aug 26 12:43:34 horde kernel: md: md2: recovery done.
Aug 26 12:43:37 horde kernel: ata1.00: cmd
25/00:08:35:74:12/00:00:28:00:00/e0 tag 0 dma 4096 in
Aug 26 12:43:41 horde kernel: ata1.00: cmd
25/00:08:35:74:12/00:00:28:00:00/e0 tag 0 dma 4096 in
Aug 26 12:43:44 horde kernel: ata1.00: cmd
25/00:08:35:74:12/00:00:28:00:00/e0 tag 0 dma 4096 in
Aug 26 12:43:47 horde kernel: ata1.00: cmd
25/00:08:35:74:12/00:00:28:00:00/e0 tag 0 dma 4096 in
Aug 26 12:43:50 horde kernel: ata1.00: cmd
25/00:08:35:74:12/00:00:28:00:00/e0 tag 0 dma 4096 in
Aug 26 12:43:53 horde kernel: ata1.00: cmd
25/00:08:35:74:12/00:00:28:00:00/e0 tag 0 dma 4096 in
Aug 26 12:43:54 horde kernel: md/raid1:md2: sda: unrecoverable I/O read
error for block 643686272
Aug 26 12:43:54 horde mdadm[3739]: RebuildFinished event detected on md
device /dev/md/2
