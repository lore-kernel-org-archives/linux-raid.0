From: Danilo Godec <danilo.godec@agenda.si>
Subject: SATA errors?
Date: Wed, 01 Oct 2008 11:25:53 +0200
Message-ID: <48E34221.1000008@agenda.si>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020203070705050902020004"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------020203070705050902020004
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

I've been searching the web, Google, mailing lists for a while now, but
can't really find the answer - so I'm hoping for a 'SATA guru' here...

On one of my server, I use 4 drive RAID5 Linux raid. One of the drives
keeps reporting these errors:

> Oct  1 10:11:29 bigxen2 kernel: ata1.00: exception Emask 0x10 SAct 0x0
> SErr 0x10002 action 0x2 frozen
> Oct  1 10:11:29 bigxen2 kernel: ata1.00: (irq_stat 0x04400000, PHY RDY
> changed)
> Oct  1 10:11:29 bigxen2 kernel: ata1.00: cmd
> 25/00:08:5c:be:60/00:00:14:00:00/e0 tag 0 cdb 0x0 data 4096 in
> Oct  1 10:11:29 bigxen2 kernel:          res
> 50/00:00:6b:6a:60/00:00:14:00:00/e0 Emask 0x10 (ATA bus error)
> Oct  1 10:11:30 bigxen2 kernel: ata1: waiting for device to spin up (7
> secs)
> Oct  1 10:11:40 bigxen2 kernel: ata1: soft resetting port
> Oct  1 10:11:41 bigxen2 kernel: ata1: softreset failed (1st FIS failed)
> Oct  1 10:11:41 bigxen2 kernel: ata1: softreset failed, retrying in 5 secs
> Oct  1 10:11:46 bigxen2 kernel: ata1: hard resetting port
> Oct  1 10:11:47 bigxen2 kernel: ata1: SATA link up 3.0 Gbps (SStatus
> 123 SControl 300)
> Oct  1 10:11:47 bigxen2 kernel: ata1.00: configured for UDMA/133
> Oct  1 10:11:47 bigxen2 kernel: ata1: EH complete
> Oct  1 10:11:47 bigxen2 kernel: SCSI device sda: 976771055 512-byte
> hdwr sectors (500107 MB)
> Oct  1 10:11:47 bigxen2 kernel: sda: Write Protect is off
> Oct  1 10:11:47 bigxen2 kernel: sda: Mode Sense: 00 3a 00 00
> Oct  1 10:11:47 bigxen2 kernel: SCSI device sda: drive cache: write back
As far as I can tell these happen randomly - sometimes it's 8 hours
between two, sometimes it's a couple of minutes. There are about 5-20 of
those per day, however Linux raid never kicks the drive out of the
array. There are also no other signs of drive not functioning properly
(such as filesystem corruption or similar).

Any ideas? Can anyone 'decode' the above errors?

 Thanks, Danilo

-- 
Danilo Godec, sistemska podpora

Predlog! Obiscite prenovljeno spletno stran http://www.agenda.si

ODPRTA KODA IN LINUX
STORITVE : POSLOVNE RESITVE : UPRAVLJANJE IT : INFRASTRUKTURA IT : IZOBRAZEVANJE : PROGRAMSKA OPREMA

Visit our updated web page at http://www.agenda.si

OPEN SOURCE AND LINUX
SERVICES : BUSINESS SOLUTIONS : IT MANAGEMENT : IT INFRASTRUCTURE : TRAINING : SOFTWARE 


--------------020203070705050902020004
Content-Type: text/x-vcard; charset=utf-8;
 name="danilo_godec.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="danilo_godec.vcf"

YmVnaW46dmNhcmQNCmZuOkRhbmlsbyBHb2RlYw0KbjpHb2RlYztEYW5pbG8NCm9yZzpBZ2Vu
ZGEgT3BlblN5c3RlbXMNCmFkcjo7O1VsLiBQb2hvcnNrZWdhIGJhdGFsam9uYSA0OTtNYXJp
Ym9yOzsyMDAwO1Nsb3ZlbmlhDQplbWFpbDtpbnRlcm5ldDpkYW5pbG8uZ29kZWNAYWdlbmRh
LnNpDQp0ZWw7d29yazorMzg2IDIgNDIxNjEzOA0KdGVsO2ZheDorMzg2IDIgNDIxNjE0MQ0K
dGVsO2NlbGw6KzM4NiA0MCA2MTg4MDINCngtbW96aWxsYS1odG1sOkZBTFNFDQp1cmw6aHR0
cDovL3d3dy5hZ2VuZGEuc2kvDQp2ZXJzaW9uOjIuMQ0KZW5kOnZjYXJkDQoNCg==
--------------020203070705050902020004--
