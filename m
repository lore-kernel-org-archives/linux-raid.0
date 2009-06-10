From: Michael Ole Olsen <gnu@gmx.net>
Subject: Re: Re: slow mdadm reshape, normal?
Date: Thu, 11 Jun 2009 01:36:59 +0200
Message-ID: <20090610233659.GD30825@rlogin.dk>
References: <3D76E016F4A2A749A1EB1A3FD83E22BC0285F2F4@uk-email.terastack.bluearc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090610224055.GW30825@xxxxxxxxx>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

the slow disks (them with 85MB/s) in the posting are the one on the pci 4x sata controller

the 32bit pci sata (sata_sil) controller has 3 disks connected

the onboard sata2 6x sata connectors have 6 disks connected 
(p5n32-e sli motherboard), i believe all these are sata2 and not shared with
an ide controller.

so only the pci controller should have bus limitations, but i wonder why it is
that slow on reshape compared to build.

unfortunately I have not gotten the recent postings on the mailinglist since
28th last month perhaps my subscription got cleared so I didn't see any
reshape postings, just signed up on new.

here you can see the 3 slow disks pci32bit compared to onboard sata2 (sdb):

sda
200+0 records in
200+0 records out
209715200 bytes (210 MB) copied, 2,46597 s, 85,0 MB/s
sdb
200+0 records in
200+0 records out
209715200 bytes (210 MB) copied, 1,66641 s, 126 MB/s
sdc
200+0 records in
200+0 records out
209715200 bytes (210 MB) copied, 2,51205 s, 83,5 MB/s
sdd
200+0 records in
200+0 records out
209715200 bytes (210 MB) copied, 2,33702 s, 89,7 MB/s

are there any good tools you can recommend to test bus congestion as the
probable cause of this slowness?

/Michael

