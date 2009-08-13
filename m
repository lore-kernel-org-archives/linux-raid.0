From: Simon Jackson <sjackson@bluearc.com>
Subject: Help understanding the root cause of a member dropping out of a
 RAID 1 set.
Date: Thu, 13 Aug 2009 09:44:11 +0100
Message-ID: <ABFC24E4C13D81489F7F624E14891C860BF9A409@uk-ex-mbx1.terastack.bluearc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


I am running RAID1 partitions on some systems and a few times I have seen a raid set become degraded as a member has failed out of the md device.  Looking at the /var/log/message file I have seen output similar to below:

Can anyone help me decode what actually happened here.  

Thanks Simon.

2009-08-11T06:21:04-07:00 Metro-1 kernel: [556568.670377]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
2009-08-11T06:21:04-07:00 Metro-1 kernel: [556568.670477] ata1: hard resetting link
2009-08-11T06:21:08-07:00 Metro-1 kernel: [556573.122562] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
2009-08-11T06:21:08-07:00 Metro-1 kernel: [556573.259057] ata1.00: configured for UDMA/133
2009-08-11T06:21:08-07:00 Metro-1 kernel: [556573.348168] ata1.01: configured for UDMA/133
2009-08-11T06:21:08-07:00 Metro-1 kernel: [556573.348168] md: super_written gets error=-5, uptodate=0
2009-08-11T06:21:08-07:00 Metro-1 kernel: [556573.348168] raid1: Operation continuing on 1 devices.
2009-08-11T06:21:08-07:00 Metro-1 kernel: [556573.348168] ata1: EH complete
