From: Nils-Henner Krueger <nhk@netuse.de>
Subject: syncing RAID1 with more than 10MB/sec
Date: Wed, 30 Mar 2005 11:12:57 +0200
Message-ID: <424A6D99.6070501@netuse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Syncing a raid1 takes long time for large disks because of
the 10MB/sec limit:

Mar 30 10:58:31 imap1 kernel: raid1: raid set md2 not clean;
reconstructing mirrors
Mar 30 10:58:31 imap1 kernel: raid1: raid set md2 active with 2 out of 2
mirrors
Mar 30 10:58:31 imap1 kernel: md: syncing RAID array md2
Mar 30 10:58:31 imap1 kernel: md: minimum _guaranteed_ reconstruction
speed: 100 KB/sec/disc.
Mar 30 10:58:31 imap1 kernel: md: using maximum available idle IO
bandwith (but not more than 10000 KB/sec) for reconstruction.

Is it possible to raise this value (without recompiling)?
I know about possible performance tradeoffs with other
processes, I'm just generally interested.

Thanks.

nils-henner
