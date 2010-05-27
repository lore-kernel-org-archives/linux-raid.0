From: "jose nuno neto" <jose.neto@liber4e.com>
Subject: md strange sync?
Date: Thu, 27 May 2010 12:31:57 -0000 (GMT)
Message-ID: <609221b5db6a42062f7b353d66e424dd.squirrel@fela.liber4e.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi2all

I have RedHat 5.5 ( kernel  2.6.18-194.el5 ) and 2hard disk with raid1
with md

I have this setup on several machines, and recently notice this messages
in /var/log/messages

Are this normal? Seems a re-sync but happened on several machines..

May 23 04:22:01 <kern.info> dc2-x6250-a kernel: md: syncing RAID array md0
May 23 04:22:01 <kern.info> dc2-x6250-a kernel: md: minimum _guaranteed_
reconstruction speed: 1000 KB/sec/disc.
May 23 04:22:01 <kern.info> dc2-x6250-a kernel: md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
reconstruction.
May 23 04:22:01 <kern.info> dc2-x6250-a kernel: md: using 128k window,
over a total of 256896 blocks.
May 23 04:22:01 <kern.info> dc2-x6250-a kernel: md: delaying resync of md1
until md0 has finished resync (they share one or more physical units)
May 23 04:22:04 <kern.info> dc2-x6250-a kernel: md: md0: sync done.
May 23 04:22:04 <kern.info> dc2-x6250-a kernel: md: syncing RAID array md1
May 23 04:22:04 <kern.info> dc2-x6250-a kernel: md: minimum _guaranteed_
reconstruction speed: 1000 KB/sec/disc.
May 23 04:22:04 <kern.info> dc2-x6250-a kernel: md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
reconstruction.
May 23 04:22:04 <kern.info> dc2-x6250-a kernel: md: using 128k window,
over a total of 8193024 blocks.
May 23 04:23:41 <kern.info> dc2-x6250-a kernel: md: md1: sync done.


thanks for any info

regards
jose

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

