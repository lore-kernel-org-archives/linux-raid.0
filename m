From: Angelo Piraino <angelo.piraino@siciliajus.com>
Subject: [help] [I2O] Adaptec 2400A on FC3
Date: Wed, 5 Jan 2005 15:02:15 +0100
Message-ID: <200501051502.15924.angelo.piraino@siciliajus.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm having some troubles with an Adaptec 2400A ATA Raid controller on FC3.
Everything worked fine during installation and Operating System recognized 
automatically the RAID card.
I also installed raidutils-0.0.4 from http://i2o.shadowconnect.com, but when I 
try to use the command raidutil this is the result:

> [root@omissis ~]# raidutil -L
> osdIOrequest : File /dev/dpti17 Could Not Be OpenedEngine connect 
> failed: COMPATIBILITY number

I need to manage the raid card at least for display the status of the RAID 
array.
Can anybody help me?
Thanks

Angelo Piraino


Linux FC3 on PIII 450MHz - chipset Intel P2BF - 256Mb Ram - Ata Raid
Adaptec 2400A
