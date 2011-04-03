From: Dennis Grant <reccedg@gmail.com>
Subject: Re: Mounting array at boot - works with some kernels but not others
Date: Sun, 3 Apr 2011 13:32:40 -0400
Message-ID: <BANLkTimA2wjitNzzqssqcuvRWNVJgLoEkw@mail.gmail.com>
References: <BANLkTinSwLgNze-EdRB6wu1o5QYApHbLXQ@mail.gmail.com>
	<4D98AAD3.2050700@turmel.org>
	<BANLkTimogoGPhRCq-+aT=TobByyp4fdfAA@mail.gmail.com>
	<4D98AE73.3040204@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D98AE73.3040204@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Retry:

Ah, I'm an idiot:

sudo mdadm --examine /dev/sda5
/dev/sda5:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : e0cc58c7:6f841366:7a44a462:94a1d56a (local to host karzai)
  Creation Time : Sat Apr 25 08:43:26 2009
     Raid Level : raid1
  Used Dev Size : 769706176 (734.05 GiB 788.18 GB)
     Array Size : 769706176 (734.05 GiB 788.18 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1

    Update Time : Sun Apr  3 13:31:15 2011
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : ce2583e5 - correct
         Events : 2844822


      Number   Major   Minor   RaidDevice State
this     0       8        5        0      active sync   /dev/sda5

   0     0       8        5        0      active sync   /dev/sda5
   1     1       8       21        1      active sync   /dev/sdb5

sudo mdadm --examine /dev/sdb5
/dev/sdb5:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : e0cc58c7:6f841366:7a44a462:94a1d56a (local to host karzai)
  Creation Time : Sat Apr 25 08:43:26 2009
     Raid Level : raid1
  Used Dev Size : 769706176 (734.05 GiB 788.18 GB)
     Array Size : 769706176 (734.05 GiB 788.18 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1

    Update Time : Sun Apr  3 13:31:15 2011
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : ce2583f7 - correct
         Events : 2844822


      Number   Major   Minor   RaidDevice State
this     1       8       21        1      active sync   /dev/sdb5

   0     0       8        5        0      active sync   /dev/sda5
   1     1       8       21        1      active sync   /dev/sdb5

DG
