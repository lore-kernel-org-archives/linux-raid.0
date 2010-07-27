From: Marco <jjletho67-diar@yahoo.it>
Subject: Re: raid1 performance
Date: Tue, 27 Jul 2010 16:10:36 +0000 (GMT)
Message-ID: <379853.84515.qm@web28502.mail.ukl.yahoo.com>
References: <443220.14357.qm@web28508.mail.ukl.yahoo.com> <20100725211926.7547c12e@natsu> <23123.42111.qm@web28503.mail.ukl.yahoo.com> <20100726210324.6a4077e6@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100726210324.6a4077e6@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <nfbrown@novell.com>
Cc: Roman Mamedov <roman@rm.pp.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids





>If you look at /proc/diskstats and particularly the 4th and 6th fields for
>the device that you are interested in, and then take the differences for each
>field between 'before' and 'after' running a test you will get
> - the number of IO requests
>  - the number of sectors
>
>that were serviced during that time.  Taking a ratio will get you the number
>of sectors per IO.  Normally more is better.

Hi Neil,
are you sure the right value are the 4th and the 6th fields ? I see strange 
value in them (the 4th field is bigger then the 6th while i was expecting the 
contrary)
looking in the iostats.txt file (kernel documentation) i suspect the fields you 
are interested are the first and the third.
In this hypothesis (1st and 3rd fields) the ratio i obtain are:

sda 84.02 
sdb 113,69
md2 8,01

md2 and his meber have a very different ratio....

>It might be interesting to find out what the data offset is for your RAID1
>(mdadm --examine will tell you if there is one), and compare the
> request/sector numbers and see if they show anything.

this is the output of mdadm --examine /dev/sda3

/dev/sda3:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : d7ca6fdd:8cf9e3ed:bea46eb0:98c63a97
  Creation Time : Tue Sep 23 15:49:29 2008
     Raid Level : raid1
  Used Dev Size : 237826176 (226.81 GiB 243.53 GB)
     Array Size : 237826176 (226.81 GiB 243.53 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 2

    Update Time : Tue Jul 27 18:07:41 2010
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 8afc34a - correct
         Events : 18156


      Number   Major   Minor   RaidDevice State
this     0       8        3        0      active sync   /dev/sda3

   0     0       8        3        0      active sync   /dev/sda3
   1     1       8       19        1      active sync   /dev/sdb3

Do you have some hypothesis ?

thank you all

Marco



      
