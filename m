From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: ServerWorks chipset
Date: Tue, 27 Aug 2002 12:41:24 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.0.14.2.20020827123902.03dcde80@mail.harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: Danilo Godec <danci@agenda.si>
Cc: bo <bo@sosnetwork.net>, Linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

With regards to your message at 12:08 AM 8/27/02, Danilo Godec. Where you 
stated:
>I'm not going to spend a ton of money for large SCSI drives. If I can't
>get ServerWorks to work well (and fast), I'll just get an add-on IDE
>controller.


So, buy a 3Ware. Works, fast, well supported.

Here is what one of my customers said yesterday.
He's running a Serverworks GC based dual XEON P4DL6 Supermicro board:
2 x P4 XEON 2GHz
2 - 3Ware 7500-8 boards
12 - WD 1200JB 120GB disks with 8MB cache
26" IDE TPE cables
2GB DDR


Here are the results I'm getting for software raid 0, 64-kByte chunks, all
for using an ext2 file system (since my system will be the receiver I want
to write as fast as possible, I've found that updating the journal file
takes a fair bit of cpu).

12 disks (sda1 through sdl1):
        dd:  writing = 163.5 MBytes/sec
             reading = 240.9 MBytes/sec
  Bonnie++:  writing = 173.6 MBytes/sec
             reading = 217.7 MBytes/sec

  8 disks (sda1,sdb1,sdc1,sdd1,sde1,sdf1,sdg1,sdh1):
        dd:  writing = 210.9 MBytes/sec
             reading = 192.8 MBytes/sec

  Bonnie++:  writing = 215.3 MBytes/sec
             reading = 198.1 MBytes/sec

Here is the disk layout per controller:
         3ware Controller #1: sda,sdb,sdc,sdd
         3ware Controller #2: sde,sdf,sdg,sdh,sdi,sdj,sdk,sdl

Therefore the result for the 8-drive benchmark has 4 drives on each
controller.

FYI the sytax I used for Bonnie++ was:
bonnie++ -d /raid -s 8000 -r 1024 -u root


With our best regards,

Maurice W. Hilarius       Telephone: 01-780-456-9771
Hard Data Ltd.               FAX:       01-780-456-9772
11060 - 166 Avenue        mailto:maurice@harddata.com
Edmonton, AB, Canada      http://www.harddata.com/
    T5X 1Y3

2.3TB RAID5 NAS server - dual AthlonMP CPU, Linux, $10,995 CAD / $6850 USD

