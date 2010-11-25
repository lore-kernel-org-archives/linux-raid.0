From: dujun <dujun@perabytes.com>
Subject: Re: raid related kernel hang in 2.6.36
Date: Thu, 25 Nov 2010 11:12:43 +0800
Message-ID: <1290654763.5416.31.camel@dujun.perabytes.com>
References: <4CED17A4.7050604@perabytes.com>
	 <AANLkTinfbPDQhmKRVibUv+Rm50wDkGizeYLGXQqY_xOu@mail.gmail.com>
	 <4CED226D.6090602@perabytes.com>  <20101125070155.277a0d62@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-tTa3TroIzFgwoPnXgweM"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101125070155.277a0d62@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Mathias =?ISO-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-tTa3TroIzFgwoPnXgweM
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hi, Neil, 
attached is the mdadm -E and mdadm -D information for md10(raid5 with 16
disks) and md11 (raid6 with 16 disks). 

I recompiled the 2.6.36 kernel with kernel sysrq and softlock dectet
option, then setup two mds to reproduce the softlock bug. 

First create two md using mdadm: 
mdadm -C /dev/md10 -l 5 -n 16 /dev/sd[b-q]
mdadm -C /dev/md10 -l 6 -n 16 /dev/sd[r-z] /dev/sda[a-g]

then use dd :
dd if=/dev/zero of=/dev/md10 bs=1M & 
dd if=/dev/zero of=/dev/md11 bs=1M& 

After a while, the system is hung with lots of softlock kernel trace on
screen. following are some netconsole output:
Nov 25 11:01:35 10.10.20.20 [ 1236.027001] BUG: soft lockup - CPU#0
stuck for 67s! [top:5690]
Nov 25 11:01:40 10.10.20.20 [ 1236.027001] Stack:
Nov 25 11:01:45 10.10.20.20 [ 1236.027001] Call Trace:
Nov 25 11:01:50 10.10.20.20 [ 1236.027001] Code: 
Nov 25 11:01:55 10.10.20.20 03
Nov 25 11:02:00 10.10.20.20 81
Nov 25 11:02:05 10.10.20.20 48
Nov 25 11:02:10 10.10.20.20 c7
Nov 25 11:02:15 10.10.20.20 c1
Nov 25 11:02:20 10.10.20.20 91
Nov 25 11:02:25 10.10.20.20 19
Nov 25 11:02:30 10.10.20.20 03
Nov 25 11:02:35 10.10.20.20 81
Nov 25 11:02:40 10.10.20.20 e9
Nov 25 11:02:45 10.10.20.20 dd
Nov 25 11:02:50 10.10.20.20 fe
Nov 25 11:02:55 10.10.20.20 ff
Nov 25 11:03:00 10.10.20.20 ff
Nov 25 11:03:05 10.10.20.20 90
Nov 25 11:03:10 10.10.20.20 90
Nov 25 11:03:15 10.10.20.20 90
Nov 25 11:03:20 10.10.20.20 90
Nov 25 11:03:25 10.10.20.20 90
Nov 25 11:03:30 10.10.20.20 90
Nov 25 11:03:35 10.10.20.20 90
Nov 25 11:03:40 10.10.20.20 90
Nov 25 11:03:45 10.10.20.20 90
Nov 25 11:03:50 10.10.20.20 90
Nov 25 11:03:55 10.10.20.20 90
Nov 25 11:04:00 10.10.20.20 90
Nov 25 11:04:05 10.10.20.20 90
Nov 25 11:04:10 10.10.20.20 b8
Nov 25 11:04:15 10.10.20.20 00
Nov 25 11:04:20 10.10.20.20 01
Nov 25 11:04:25 10.10.20.20 00
Nov 25 11:04:30 10.10.20.20 00
Nov 25 11:04:35 10.10.20.20 f0
Nov 25 11:04:40 10.10.20.20 66
Nov 25 11:04:45 10.10.20.20 0f
Nov 25 11:04:50 10.10.20.20 c1
Nov 25 11:04:55 10.10.20.20 07
Nov 25 11:05:00 10.10.20.20 38
Nov 25 11:05:05 10.10.20.20 e0
Nov 25 11:05:10 10.10.20.20 74
Nov 25 11:05:15 10.10.20.20 06
Nov 25 11:05:20 10.10.20.20 f3
Nov 25 11:05:25 10.10.20.20 90

Message from syslogd@10.10.20.20 at Nov 25 11:05:30 ...
 a>
Nov 25 11:05:35 10.10.20.20 07
Nov 25 11:05:40 10.10.20.20 eb
Nov 25 11:05:45 10.10.20.20 f6
Nov 25 11:05:50 10.10.20.20 c3
Nov 25 11:05:55 10.10.20.20 66
Nov 25 11:06:00 10.10.20.20 66
Nov 25 11:06:05 10.10.20.20 2e
Nov 25 11:06:10 10.10.20.20 0f
Nov 25 11:06:15 10.10.20.20 1f
Nov 25 11:06:20 10.10.20.20 84
Nov 25 11:06:25 10.10.20.20 00
Nov 25 11:06:30 10.10.20.20 00
Nov 25 11:06:35 10.10.20.20 00
Nov 25 11:06:40 10.10.20.20 00
Nov 25 11:06:45 10.10.20.20 00
Nov 25 11:06:50 10.10.20.20 0f
Nov 25 11:06:55 10.10.20.20 b7
Nov 25 11:07:00 10.10.20.20 07
Nov 25 11:07:05 10.10.20.20 38
Nov 25 11:07:10 10.10.20.20 e0
Nov 25 11:07:15 10.10.20.20 
Nov 25 11:07:21 10.10.20.20 [ 1236.099000] BUG: soft lockup - CPU#1
stuck for 67s! [pvscan:6172]
Nov 25 11:07:26 10.10.20.20 [ 1236.099001] Stack:
Nov 25 11:07:31 10.10.20.20 [ 1236.099001] Call Trace:
Nov 25 11:07:36 10.10.20.20 [ 1236.099001] Code: 
Nov 25 11:07:41 10.10.20.20 39
Nov 25 11:07:46 10.10.20.20 ea
Nov 25 11:07:51 10.10.20.20 0f
Nov 25 11:07:56 10.10.20.20 1f
Nov 25 11:08:01 10.10.20.20 00
Nov 25 11:08:06 10.10.20.20 77
Nov 25 11:08:11 10.10.20.20 a8
Nov 25 11:08:16 10.10.20.20 89
Nov 25 11:08:21 10.10.20.20 de
Nov 25 11:08:26 10.10.20.20 89
Nov 25 11:08:31 10.10.20.20 e9
Nov 25 11:08:36 10.10.20.20 49
Nov 25 11:08:41 10.10.20.20 8d
Nov 25 11:08:46 10.10.20.20 34
Nov 25 11:08:51 10.10.20.20 f7
Nov 25 11:08:56 10.10.20.20 29
Nov 25 11:09:01 10.10.20.20 d9
Nov 25 11:09:06 10.10.20.20 45
Nov 25 11:09:11 10.10.20.20 89
Nov 25 11:09:16 10.10.20.20 e1
Nov 25 11:09:21 10.10.20.20 4c
Nov 25 11:09:26 10.10.20.20 8d
Nov 25 11:09:31 10.10.20.20 44
Nov 25 11:09:36 10.10.20.20 24
Nov 25 11:09:41 10.10.20.20 08


the sysrq-T just print "showstate" on screen. no more useful
information. 

thanks. 

Johnson

在 2010-11-25四的 07:01 +1100，Neil Brown写道：
> On Wed, 24 Nov 2010 22:34:21 +0800 Du Jun <dujun@perabytes.com> wrote:
> 
> > Their's no dmesg information at all before the hang. The system just 
> > hangs suddenly without any kernel printk or oops.
> > 
> > mdadm version is debian lenny version 2.6.7.2-3
> > 
> > I will get mdadm -E & mdadm -D informations tomorrow but I doubt they 
> > are useful.
> 
> Probably not, but they wouldn't hurt either.
> 
> What would really help is if you could capture the result of
>     sysrq-T
> 
> which I accept might be a challenge depending on how hard the machine really
> has frozen.
> 
> Also, make sure the LOCKUP_DETECTOR config options are set, and wait a few
> minutes after the hand to see if something pops up.
> 
> I'll try to see if I can reproduce, but I don't have 16 disks so it may not
> work.
> 
> NeilBrown
> 
> 
> > 
> > Johnson
> > on 2010/11/24 22:19, Mathias Burén  wrote:
> > > Hi,
> > >
> > > I suppose a few logs would be interesting. (dmesg, mdadm -E (hdds),
> > > mdadm -D md10, zcat /proc/config.gz, mdadm version)
> > >
> > > Regards,
> > > // Mathias
> > >
> > > 2010/11/24 Du Jun<dujun@perabytes.com>:
> > >    
> > >> Hi,
> > >> We just quick tested the raid stability under the vanilla 2.6.36 kernel
> > >> and got an unstable result.
> > >>
> > >> first, we create a raid5 array using 16 sata disks:
> > >>
> > >> mdadm -C /dev/md10 -l 5 -n 16 /dev/sd[b-q]
> > >>
> > >> then use dd to stress the io:
> > >>
> > >> dd if=/dev/zero of=/dev/md10 bs=1M
> > >>
> > >> After a while, usually several minutes, the system hangs. It looks like
> > >> some kind of kernel deadlock. ping to this machine could get timely
> > >> response, however, any other process just hangs.
> > >>
> > >> It is easily reproducible and everytime the test result is a system hang.
> > >>
> > >> Johnson
> > >>
> > >> --
> > >> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > >> the body of a message to majordomo@vger.kernel.org
> > >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >>
> > >>      
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >
> > >
> > >    
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

--=-tTa3TroIzFgwoPnXgweM
Content-Disposition: attachment; filename=md10.txt
Content-Type: text/plain; name=md10.txt; charset=utf-8
Content-Transfer-Encoding: 7bit

/dev/md10:
        Version : 00.90
  Creation Time : Thu Nov 25 10:24:11 2010
     Raid Level : raid5
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 10
    Persistence : Superblock is persistent

    Update Time : Thu Nov 25 10:42:10 2010
          State : clean, degraded, recovering
 Active Devices : 15
Working Devices : 16
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

 Rebuild Status : 2% complete

           UUID : f7187a5e:3e368fe2:d64d9ae0:217d735e (local to host DigiOcean)
         Events : 0.4

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync   /dev/sdb
       1       8       32        1      active sync   /dev/sdc
       2       8       48        2      active sync   /dev/sdd
       3       8       64        3      active sync   /dev/sde
       4       8       80        4      active sync   /dev/sdf
       5       8       96        5      active sync   /dev/sdg
       6       8      112        6      active sync   /dev/sdh
       7       8      128        7      active sync   /dev/sdi
       8       8      144        8      active sync   /dev/sdj
       9       8      160        9      active sync   /dev/sdk
      10       8      176       10      active sync   /dev/sdl
      11       8      192       11      active sync   /dev/sdm
      12       8      208       12      active sync   /dev/sdn
      13       8      224       13      active sync   /dev/sdo
      14       8      240       14      active sync   /dev/sdp
      16      65        0       15      spare rebuilding   /dev/sdq

--=-tTa3TroIzFgwoPnXgweM
Content-Disposition: attachment; filename=md11.txt
Content-Type: text/plain; name=md11.txt; charset=utf-8
Content-Transfer-Encoding: 7bit

/dev/md11:
        Version : 00.90
  Creation Time : Thu Nov 25 10:43:51 2010
     Raid Level : raid5
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 11
    Persistence : Superblock is persistent

    Update Time : Thu Nov 25 10:43:51 2010
          State : clean, degraded, recovering
 Active Devices : 15
Working Devices : 16
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

 Rebuild Status : 2% complete

           UUID : 012dcc5b:f09d21e4:d64d9ae0:217d735e (local to host DigiOcean)
         Events : 0.2

    Number   Major   Minor   RaidDevice State
       0      65       16        0      active sync   /dev/sdr
       1      65       32        1      active sync   /dev/sds
       2      65       48        2      active sync   /dev/sdt
       3      65       64        3      active sync   /dev/sdu
       4      65       80        4      active sync   /dev/sdv
       5      65       96        5      active sync   /dev/sdw
       6      65      112        6      active sync   /dev/sdx
       7      65      128        7      active sync   /dev/sdy
       8      65      144        8      active sync   /dev/sdz
       9      65      160        9      active sync   /dev/sdaa
      10      65      176       10      active sync   /dev/sdab
      11      65      192       11      active sync   /dev/sdac
      12      65      208       12      active sync   /dev/sdad
      13      65      224       13      active sync   /dev/sdae
      14      65      240       14      active sync   /dev/sdaf
      16      66        0       15      spare rebuilding   /dev/sdag

--=-tTa3TroIzFgwoPnXgweM
Content-Disposition: attachment; filename=sdds.txt
Content-Type: text/plain; name=sdds.txt; charset=utf-8
Content-Transfer-Encoding: 7bit

/dev/sdaa:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 012dcc5b:f09d21e4:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:43:51 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 11

    Update Time : Thu Nov 25 10:51:55 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 66d62d61 - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     9      65      160        9      active sync   /dev/sdaa

   0     0      65       16        0      active sync   /dev/sdr
   1     1      65       32        1      active sync   /dev/sds
   2     2      65       48        2      active sync   /dev/sdt
   3     3      65       64        3      active sync   /dev/sdu
   4     4      65       80        4      active sync   /dev/sdv
   5     5      65       96        5      active sync   /dev/sdw
   6     6      65      112        6      active sync   /dev/sdx
   7     7      65      128        7      active sync   /dev/sdy
   8     8      65      144        8      active sync   /dev/sdz
   9     9      65      160        9      active sync   /dev/sdaa
  10    10      65      176       10      active sync   /dev/sdab
  11    11      65      192       11      active sync   /dev/sdac
  12    12      65      208       12      active sync   /dev/sdad
  13    13      65      224       13      active sync   /dev/sdae
  14    14      65      240       14      active sync   /dev/sdaf
  15    15       0        0       15      faulty removed
  16    16      66        0       16      spare   /dev/sdag
/dev/sdab:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 012dcc5b:f09d21e4:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:43:51 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 11

    Update Time : Thu Nov 25 10:51:55 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 66d62d73 - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    10      65      176       10      active sync   /dev/sdab

   0     0      65       16        0      active sync   /dev/sdr
   1     1      65       32        1      active sync   /dev/sds
   2     2      65       48        2      active sync   /dev/sdt
   3     3      65       64        3      active sync   /dev/sdu
   4     4      65       80        4      active sync   /dev/sdv
   5     5      65       96        5      active sync   /dev/sdw
   6     6      65      112        6      active sync   /dev/sdx
   7     7      65      128        7      active sync   /dev/sdy
   8     8      65      144        8      active sync   /dev/sdz
   9     9      65      160        9      active sync   /dev/sdaa
  10    10      65      176       10      active sync   /dev/sdab
  11    11      65      192       11      active sync   /dev/sdac
  12    12      65      208       12      active sync   /dev/sdad
  13    13      65      224       13      active sync   /dev/sdae
  14    14      65      240       14      active sync   /dev/sdaf
  15    15       0        0       15      faulty removed
  16    16      66        0       16      spare   /dev/sdag
/dev/sdac:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 012dcc5b:f09d21e4:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:43:51 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 11

    Update Time : Thu Nov 25 10:51:55 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 66d62d85 - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    11      65      192       11      active sync   /dev/sdac

   0     0      65       16        0      active sync   /dev/sdr
   1     1      65       32        1      active sync   /dev/sds
   2     2      65       48        2      active sync   /dev/sdt
   3     3      65       64        3      active sync   /dev/sdu
   4     4      65       80        4      active sync   /dev/sdv
   5     5      65       96        5      active sync   /dev/sdw
   6     6      65      112        6      active sync   /dev/sdx
   7     7      65      128        7      active sync   /dev/sdy
   8     8      65      144        8      active sync   /dev/sdz
   9     9      65      160        9      active sync   /dev/sdaa
  10    10      65      176       10      active sync   /dev/sdab
  11    11      65      192       11      active sync   /dev/sdac
  12    12      65      208       12      active sync   /dev/sdad
  13    13      65      224       13      active sync   /dev/sdae
  14    14      65      240       14      active sync   /dev/sdaf
  15    15       0        0       15      faulty removed
  16    16      66        0       16      spare   /dev/sdag
/dev/sdad:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 012dcc5b:f09d21e4:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:43:51 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 11

    Update Time : Thu Nov 25 10:51:55 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 66d62d97 - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    12      65      208       12      active sync   /dev/sdad

   0     0      65       16        0      active sync   /dev/sdr
   1     1      65       32        1      active sync   /dev/sds
   2     2      65       48        2      active sync   /dev/sdt
   3     3      65       64        3      active sync   /dev/sdu
   4     4      65       80        4      active sync   /dev/sdv
   5     5      65       96        5      active sync   /dev/sdw
   6     6      65      112        6      active sync   /dev/sdx
   7     7      65      128        7      active sync   /dev/sdy
   8     8      65      144        8      active sync   /dev/sdz
   9     9      65      160        9      active sync   /dev/sdaa
  10    10      65      176       10      active sync   /dev/sdab
  11    11      65      192       11      active sync   /dev/sdac
  12    12      65      208       12      active sync   /dev/sdad
  13    13      65      224       13      active sync   /dev/sdae
  14    14      65      240       14      active sync   /dev/sdaf
  15    15       0        0       15      faulty removed
  16    16      66        0       16      spare   /dev/sdag
/dev/sdae:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 012dcc5b:f09d21e4:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:43:51 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 11

    Update Time : Thu Nov 25 10:51:55 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 66d62da9 - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    13      65      224       13      active sync   /dev/sdae

   0     0      65       16        0      active sync   /dev/sdr
   1     1      65       32        1      active sync   /dev/sds
   2     2      65       48        2      active sync   /dev/sdt
   3     3      65       64        3      active sync   /dev/sdu
   4     4      65       80        4      active sync   /dev/sdv
   5     5      65       96        5      active sync   /dev/sdw
   6     6      65      112        6      active sync   /dev/sdx
   7     7      65      128        7      active sync   /dev/sdy
   8     8      65      144        8      active sync   /dev/sdz
   9     9      65      160        9      active sync   /dev/sdaa
  10    10      65      176       10      active sync   /dev/sdab
  11    11      65      192       11      active sync   /dev/sdac
  12    12      65      208       12      active sync   /dev/sdad
  13    13      65      224       13      active sync   /dev/sdae
  14    14      65      240       14      active sync   /dev/sdaf
  15    15       0        0       15      faulty removed
  16    16      66        0       16      spare   /dev/sdag
/dev/sdaf:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 012dcc5b:f09d21e4:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:43:51 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 11

    Update Time : Thu Nov 25 10:51:55 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 66d62dbb - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    14      65      240       14      active sync   /dev/sdaf

   0     0      65       16        0      active sync   /dev/sdr
   1     1      65       32        1      active sync   /dev/sds
   2     2      65       48        2      active sync   /dev/sdt
   3     3      65       64        3      active sync   /dev/sdu
   4     4      65       80        4      active sync   /dev/sdv
   5     5      65       96        5      active sync   /dev/sdw
   6     6      65      112        6      active sync   /dev/sdx
   7     7      65      128        7      active sync   /dev/sdy
   8     8      65      144        8      active sync   /dev/sdz
   9     9      65      160        9      active sync   /dev/sdaa
  10    10      65      176       10      active sync   /dev/sdab
  11    11      65      192       11      active sync   /dev/sdac
  12    12      65      208       12      active sync   /dev/sdad
  13    13      65      224       13      active sync   /dev/sdae
  14    14      65      240       14      active sync   /dev/sdaf
  15    15       0        0       15      faulty removed
  16    16      66        0       16      spare   /dev/sdag
/dev/sdag:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 012dcc5b:f09d21e4:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:43:51 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 11

    Update Time : Thu Nov 25 10:51:55 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 66d62cca - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    16      66        0       16      spare   /dev/sdag

   0     0      65       16        0      active sync   /dev/sdr
   1     1      65       32        1      active sync   /dev/sds
   2     2      65       48        2      active sync   /dev/sdt
   3     3      65       64        3      active sync   /dev/sdu
   4     4      65       80        4      active sync   /dev/sdv
   5     5      65       96        5      active sync   /dev/sdw
   6     6      65      112        6      active sync   /dev/sdx
   7     7      65      128        7      active sync   /dev/sdy
   8     8      65      144        8      active sync   /dev/sdz
   9     9      65      160        9      active sync   /dev/sdaa
  10    10      65      176       10      active sync   /dev/sdab
  11    11      65      192       11      active sync   /dev/sdac
  12    12      65      208       12      active sync   /dev/sdad
  13    13      65      224       13      active sync   /dev/sdae
  14    14      65      240       14      active sync   /dev/sdaf
  15    15       0        0       15      faulty removed
  16    16      66        0       16      spare   /dev/sdag
/dev/sdb:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : f7187a5e:3e368fe2:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:24:11 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 10

    Update Time : Thu Nov 25 10:51:49 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : aa5a4090 - correct
         Events : 6

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       16        0      active sync   /dev/sdb

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8       96        5      active sync   /dev/sdg
   6     6       8      112        6      active sync   /dev/sdh
   7     7       8      128        7      active sync   /dev/sdi
   8     8       8      144        8      active sync   /dev/sdj
   9     9       8      160        9      active sync   /dev/sdk
  10    10       8      176       10      active sync   /dev/sdl
  11    11       8      192       11      active sync   /dev/sdm
  12    12       8      208       12      active sync   /dev/sdn
  13    13       8      224       13      active sync   /dev/sdo
  14    14       8      240       14      active sync   /dev/sdp
  15    15       0        0       15      faulty removed
  16    16      65        0       16      spare   /dev/sdq
/dev/sdc:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : f7187a5e:3e368fe2:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:24:11 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 10

    Update Time : Thu Nov 25 10:51:49 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : aa5a40a2 - correct
         Events : 6

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       32        1      active sync   /dev/sdc

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8       96        5      active sync   /dev/sdg
   6     6       8      112        6      active sync   /dev/sdh
   7     7       8      128        7      active sync   /dev/sdi
   8     8       8      144        8      active sync   /dev/sdj
   9     9       8      160        9      active sync   /dev/sdk
  10    10       8      176       10      active sync   /dev/sdl
  11    11       8      192       11      active sync   /dev/sdm
  12    12       8      208       12      active sync   /dev/sdn
  13    13       8      224       13      active sync   /dev/sdo
  14    14       8      240       14      active sync   /dev/sdp
  15    15       0        0       15      faulty removed
  16    16      65        0       16      spare   /dev/sdq
/dev/sdd:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : f7187a5e:3e368fe2:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:24:11 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 10

    Update Time : Thu Nov 25 10:51:49 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : aa5a40b4 - correct
         Events : 6

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       48        2      active sync   /dev/sdd

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8       96        5      active sync   /dev/sdg
   6     6       8      112        6      active sync   /dev/sdh
   7     7       8      128        7      active sync   /dev/sdi
   8     8       8      144        8      active sync   /dev/sdj
   9     9       8      160        9      active sync   /dev/sdk
  10    10       8      176       10      active sync   /dev/sdl
  11    11       8      192       11      active sync   /dev/sdm
  12    12       8      208       12      active sync   /dev/sdn
  13    13       8      224       13      active sync   /dev/sdo
  14    14       8      240       14      active sync   /dev/sdp
  15    15       0        0       15      faulty removed
  16    16      65        0       16      spare   /dev/sdq
/dev/sde:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : f7187a5e:3e368fe2:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:24:11 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 10

    Update Time : Thu Nov 25 10:51:49 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : aa5a40c6 - correct
         Events : 6

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       64        3      active sync   /dev/sde

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8       96        5      active sync   /dev/sdg
   6     6       8      112        6      active sync   /dev/sdh
   7     7       8      128        7      active sync   /dev/sdi
   8     8       8      144        8      active sync   /dev/sdj
   9     9       8      160        9      active sync   /dev/sdk
  10    10       8      176       10      active sync   /dev/sdl
  11    11       8      192       11      active sync   /dev/sdm
  12    12       8      208       12      active sync   /dev/sdn
  13    13       8      224       13      active sync   /dev/sdo
  14    14       8      240       14      active sync   /dev/sdp
  15    15       0        0       15      faulty removed
  16    16      65        0       16      spare   /dev/sdq
/dev/sdf:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : f7187a5e:3e368fe2:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:24:11 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 10

    Update Time : Thu Nov 25 10:51:49 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : aa5a40d8 - correct
         Events : 6

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       80        4      active sync   /dev/sdf

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8       96        5      active sync   /dev/sdg
   6     6       8      112        6      active sync   /dev/sdh
   7     7       8      128        7      active sync   /dev/sdi
   8     8       8      144        8      active sync   /dev/sdj
   9     9       8      160        9      active sync   /dev/sdk
  10    10       8      176       10      active sync   /dev/sdl
  11    11       8      192       11      active sync   /dev/sdm
  12    12       8      208       12      active sync   /dev/sdn
  13    13       8      224       13      active sync   /dev/sdo
  14    14       8      240       14      active sync   /dev/sdp
  15    15       0        0       15      faulty removed
  16    16      65        0       16      spare   /dev/sdq
/dev/sdg:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : f7187a5e:3e368fe2:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:24:11 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 10

    Update Time : Thu Nov 25 10:51:49 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : aa5a40ea - correct
         Events : 6

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8       96        5      active sync   /dev/sdg

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8       96        5      active sync   /dev/sdg
   6     6       8      112        6      active sync   /dev/sdh
   7     7       8      128        7      active sync   /dev/sdi
   8     8       8      144        8      active sync   /dev/sdj
   9     9       8      160        9      active sync   /dev/sdk
  10    10       8      176       10      active sync   /dev/sdl
  11    11       8      192       11      active sync   /dev/sdm
  12    12       8      208       12      active sync   /dev/sdn
  13    13       8      224       13      active sync   /dev/sdo
  14    14       8      240       14      active sync   /dev/sdp
  15    15       0        0       15      faulty removed
  16    16      65        0       16      spare   /dev/sdq
/dev/sdh:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : f7187a5e:3e368fe2:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:24:11 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 10

    Update Time : Thu Nov 25 10:51:49 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : aa5a40fc - correct
         Events : 6

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     6       8      112        6      active sync   /dev/sdh

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8       96        5      active sync   /dev/sdg
   6     6       8      112        6      active sync   /dev/sdh
   7     7       8      128        7      active sync   /dev/sdi
   8     8       8      144        8      active sync   /dev/sdj
   9     9       8      160        9      active sync   /dev/sdk
  10    10       8      176       10      active sync   /dev/sdl
  11    11       8      192       11      active sync   /dev/sdm
  12    12       8      208       12      active sync   /dev/sdn
  13    13       8      224       13      active sync   /dev/sdo
  14    14       8      240       14      active sync   /dev/sdp
  15    15       0        0       15      faulty removed
  16    16      65        0       16      spare   /dev/sdq
/dev/sdi:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : f7187a5e:3e368fe2:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:24:11 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 10

    Update Time : Thu Nov 25 10:51:49 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : aa5a410e - correct
         Events : 6

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     7       8      128        7      active sync   /dev/sdi

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8       96        5      active sync   /dev/sdg
   6     6       8      112        6      active sync   /dev/sdh
   7     7       8      128        7      active sync   /dev/sdi
   8     8       8      144        8      active sync   /dev/sdj
   9     9       8      160        9      active sync   /dev/sdk
  10    10       8      176       10      active sync   /dev/sdl
  11    11       8      192       11      active sync   /dev/sdm
  12    12       8      208       12      active sync   /dev/sdn
  13    13       8      224       13      active sync   /dev/sdo
  14    14       8      240       14      active sync   /dev/sdp
  15    15       0        0       15      faulty removed
  16    16      65        0       16      spare   /dev/sdq
/dev/sdj:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : f7187a5e:3e368fe2:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:24:11 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 10

    Update Time : Thu Nov 25 10:51:49 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : aa5a4120 - correct
         Events : 6

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     8       8      144        8      active sync   /dev/sdj

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8       96        5      active sync   /dev/sdg
   6     6       8      112        6      active sync   /dev/sdh
   7     7       8      128        7      active sync   /dev/sdi
   8     8       8      144        8      active sync   /dev/sdj
   9     9       8      160        9      active sync   /dev/sdk
  10    10       8      176       10      active sync   /dev/sdl
  11    11       8      192       11      active sync   /dev/sdm
  12    12       8      208       12      active sync   /dev/sdn
  13    13       8      224       13      active sync   /dev/sdo
  14    14       8      240       14      active sync   /dev/sdp
  15    15       0        0       15      faulty removed
  16    16      65        0       16      spare   /dev/sdq
/dev/sdk:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : f7187a5e:3e368fe2:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:24:11 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 10

    Update Time : Thu Nov 25 10:51:49 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : aa5a4132 - correct
         Events : 6

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     9       8      160        9      active sync   /dev/sdk

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8       96        5      active sync   /dev/sdg
   6     6       8      112        6      active sync   /dev/sdh
   7     7       8      128        7      active sync   /dev/sdi
   8     8       8      144        8      active sync   /dev/sdj
   9     9       8      160        9      active sync   /dev/sdk
  10    10       8      176       10      active sync   /dev/sdl
  11    11       8      192       11      active sync   /dev/sdm
  12    12       8      208       12      active sync   /dev/sdn
  13    13       8      224       13      active sync   /dev/sdo
  14    14       8      240       14      active sync   /dev/sdp
  15    15       0        0       15      faulty removed
  16    16      65        0       16      spare   /dev/sdq
/dev/sdl:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : f7187a5e:3e368fe2:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:24:11 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 10

    Update Time : Thu Nov 25 10:51:49 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : aa5a4144 - correct
         Events : 6

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    10       8      176       10      active sync   /dev/sdl

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8       96        5      active sync   /dev/sdg
   6     6       8      112        6      active sync   /dev/sdh
   7     7       8      128        7      active sync   /dev/sdi
   8     8       8      144        8      active sync   /dev/sdj
   9     9       8      160        9      active sync   /dev/sdk
  10    10       8      176       10      active sync   /dev/sdl
  11    11       8      192       11      active sync   /dev/sdm
  12    12       8      208       12      active sync   /dev/sdn
  13    13       8      224       13      active sync   /dev/sdo
  14    14       8      240       14      active sync   /dev/sdp
  15    15       0        0       15      faulty removed
  16    16      65        0       16      spare   /dev/sdq
/dev/sdm:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : f7187a5e:3e368fe2:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:24:11 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 10

    Update Time : Thu Nov 25 10:51:49 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : aa5a4156 - correct
         Events : 6

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    11       8      192       11      active sync   /dev/sdm

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8       96        5      active sync   /dev/sdg
   6     6       8      112        6      active sync   /dev/sdh
   7     7       8      128        7      active sync   /dev/sdi
   8     8       8      144        8      active sync   /dev/sdj
   9     9       8      160        9      active sync   /dev/sdk
  10    10       8      176       10      active sync   /dev/sdl
  11    11       8      192       11      active sync   /dev/sdm
  12    12       8      208       12      active sync   /dev/sdn
  13    13       8      224       13      active sync   /dev/sdo
  14    14       8      240       14      active sync   /dev/sdp
  15    15       0        0       15      faulty removed
  16    16      65        0       16      spare   /dev/sdq
/dev/sdn:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : f7187a5e:3e368fe2:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:24:11 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 10

    Update Time : Thu Nov 25 10:51:49 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : aa5a4168 - correct
         Events : 6

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    12       8      208       12      active sync   /dev/sdn

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8       96        5      active sync   /dev/sdg
   6     6       8      112        6      active sync   /dev/sdh
   7     7       8      128        7      active sync   /dev/sdi
   8     8       8      144        8      active sync   /dev/sdj
   9     9       8      160        9      active sync   /dev/sdk
  10    10       8      176       10      active sync   /dev/sdl
  11    11       8      192       11      active sync   /dev/sdm
  12    12       8      208       12      active sync   /dev/sdn
  13    13       8      224       13      active sync   /dev/sdo
  14    14       8      240       14      active sync   /dev/sdp
  15    15       0        0       15      faulty removed
  16    16      65        0       16      spare   /dev/sdq
/dev/sdo:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : f7187a5e:3e368fe2:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:24:11 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 10

    Update Time : Thu Nov 25 10:51:49 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : aa5a417a - correct
         Events : 6

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    13       8      224       13      active sync   /dev/sdo

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8       96        5      active sync   /dev/sdg
   6     6       8      112        6      active sync   /dev/sdh
   7     7       8      128        7      active sync   /dev/sdi
   8     8       8      144        8      active sync   /dev/sdj
   9     9       8      160        9      active sync   /dev/sdk
  10    10       8      176       10      active sync   /dev/sdl
  11    11       8      192       11      active sync   /dev/sdm
  12    12       8      208       12      active sync   /dev/sdn
  13    13       8      224       13      active sync   /dev/sdo
  14    14       8      240       14      active sync   /dev/sdp
  15    15       0        0       15      faulty removed
  16    16      65        0       16      spare   /dev/sdq
/dev/sdp:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : f7187a5e:3e368fe2:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:24:11 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 10

    Update Time : Thu Nov 25 10:51:49 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : aa5a418c - correct
         Events : 6

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    14       8      240       14      active sync   /dev/sdp

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8       96        5      active sync   /dev/sdg
   6     6       8      112        6      active sync   /dev/sdh
   7     7       8      128        7      active sync   /dev/sdi
   8     8       8      144        8      active sync   /dev/sdj
   9     9       8      160        9      active sync   /dev/sdk
  10    10       8      176       10      active sync   /dev/sdl
  11    11       8      192       11      active sync   /dev/sdm
  12    12       8      208       12      active sync   /dev/sdn
  13    13       8      224       13      active sync   /dev/sdo
  14    14       8      240       14      active sync   /dev/sdp
  15    15       0        0       15      faulty removed
  16    16      65        0       16      spare   /dev/sdq
/dev/sdq:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : f7187a5e:3e368fe2:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:24:11 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 10

    Update Time : Thu Nov 25 10:51:49 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : aa5a40d3 - correct
         Events : 6

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    16      65        0       16      spare   /dev/sdq

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8       96        5      active sync   /dev/sdg
   6     6       8      112        6      active sync   /dev/sdh
   7     7       8      128        7      active sync   /dev/sdi
   8     8       8      144        8      active sync   /dev/sdj
   9     9       8      160        9      active sync   /dev/sdk
  10    10       8      176       10      active sync   /dev/sdl
  11    11       8      192       11      active sync   /dev/sdm
  12    12       8      208       12      active sync   /dev/sdn
  13    13       8      224       13      active sync   /dev/sdo
  14    14       8      240       14      active sync   /dev/sdp
  15    15       0        0       15      faulty removed
  16    16      65        0       16      spare   /dev/sdq
/dev/sdr:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 012dcc5b:f09d21e4:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:43:51 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 11

    Update Time : Thu Nov 25 10:51:55 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 66d62cbf - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0      65       16        0      active sync   /dev/sdr

   0     0      65       16        0      active sync   /dev/sdr
   1     1      65       32        1      active sync   /dev/sds
   2     2      65       48        2      active sync   /dev/sdt
   3     3      65       64        3      active sync   /dev/sdu
   4     4      65       80        4      active sync   /dev/sdv
   5     5      65       96        5      active sync   /dev/sdw
   6     6      65      112        6      active sync   /dev/sdx
   7     7      65      128        7      active sync   /dev/sdy
   8     8      65      144        8      active sync   /dev/sdz
   9     9      65      160        9      active sync   /dev/sdaa
  10    10      65      176       10      active sync   /dev/sdab
  11    11      65      192       11      active sync   /dev/sdac
  12    12      65      208       12      active sync   /dev/sdad
  13    13      65      224       13      active sync   /dev/sdae
  14    14      65      240       14      active sync   /dev/sdaf
  15    15       0        0       15      faulty removed
  16    16      66        0       16      spare   /dev/sdag
/dev/sds:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 012dcc5b:f09d21e4:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:43:51 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 11

    Update Time : Thu Nov 25 10:51:55 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 66d62cd1 - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1      65       32        1      active sync   /dev/sds

   0     0      65       16        0      active sync   /dev/sdr
   1     1      65       32        1      active sync   /dev/sds
   2     2      65       48        2      active sync   /dev/sdt
   3     3      65       64        3      active sync   /dev/sdu
   4     4      65       80        4      active sync   /dev/sdv
   5     5      65       96        5      active sync   /dev/sdw
   6     6      65      112        6      active sync   /dev/sdx
   7     7      65      128        7      active sync   /dev/sdy
   8     8      65      144        8      active sync   /dev/sdz
   9     9      65      160        9      active sync   /dev/sdaa
  10    10      65      176       10      active sync   /dev/sdab
  11    11      65      192       11      active sync   /dev/sdac
  12    12      65      208       12      active sync   /dev/sdad
  13    13      65      224       13      active sync   /dev/sdae
  14    14      65      240       14      active sync   /dev/sdaf
  15    15       0        0       15      faulty removed
  16    16      66        0       16      spare   /dev/sdag
/dev/sdt:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 012dcc5b:f09d21e4:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:43:51 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 11

    Update Time : Thu Nov 25 10:51:55 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 66d62ce3 - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2      65       48        2      active sync   /dev/sdt

   0     0      65       16        0      active sync   /dev/sdr
   1     1      65       32        1      active sync   /dev/sds
   2     2      65       48        2      active sync   /dev/sdt
   3     3      65       64        3      active sync   /dev/sdu
   4     4      65       80        4      active sync   /dev/sdv
   5     5      65       96        5      active sync   /dev/sdw
   6     6      65      112        6      active sync   /dev/sdx
   7     7      65      128        7      active sync   /dev/sdy
   8     8      65      144        8      active sync   /dev/sdz
   9     9      65      160        9      active sync   /dev/sdaa
  10    10      65      176       10      active sync   /dev/sdab
  11    11      65      192       11      active sync   /dev/sdac
  12    12      65      208       12      active sync   /dev/sdad
  13    13      65      224       13      active sync   /dev/sdae
  14    14      65      240       14      active sync   /dev/sdaf
  15    15       0        0       15      faulty removed
  16    16      66        0       16      spare   /dev/sdag
/dev/sdu:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 012dcc5b:f09d21e4:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:43:51 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 11

    Update Time : Thu Nov 25 10:51:55 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 66d62cf5 - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3      65       64        3      active sync   /dev/sdu

   0     0      65       16        0      active sync   /dev/sdr
   1     1      65       32        1      active sync   /dev/sds
   2     2      65       48        2      active sync   /dev/sdt
   3     3      65       64        3      active sync   /dev/sdu
   4     4      65       80        4      active sync   /dev/sdv
   5     5      65       96        5      active sync   /dev/sdw
   6     6      65      112        6      active sync   /dev/sdx
   7     7      65      128        7      active sync   /dev/sdy
   8     8      65      144        8      active sync   /dev/sdz
   9     9      65      160        9      active sync   /dev/sdaa
  10    10      65      176       10      active sync   /dev/sdab
  11    11      65      192       11      active sync   /dev/sdac
  12    12      65      208       12      active sync   /dev/sdad
  13    13      65      224       13      active sync   /dev/sdae
  14    14      65      240       14      active sync   /dev/sdaf
  15    15       0        0       15      faulty removed
  16    16      66        0       16      spare   /dev/sdag
/dev/sdv:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 012dcc5b:f09d21e4:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:43:51 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 11

    Update Time : Thu Nov 25 10:51:55 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 66d62d07 - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4      65       80        4      active sync   /dev/sdv

   0     0      65       16        0      active sync   /dev/sdr
   1     1      65       32        1      active sync   /dev/sds
   2     2      65       48        2      active sync   /dev/sdt
   3     3      65       64        3      active sync   /dev/sdu
   4     4      65       80        4      active sync   /dev/sdv
   5     5      65       96        5      active sync   /dev/sdw
   6     6      65      112        6      active sync   /dev/sdx
   7     7      65      128        7      active sync   /dev/sdy
   8     8      65      144        8      active sync   /dev/sdz
   9     9      65      160        9      active sync   /dev/sdaa
  10    10      65      176       10      active sync   /dev/sdab
  11    11      65      192       11      active sync   /dev/sdac
  12    12      65      208       12      active sync   /dev/sdad
  13    13      65      224       13      active sync   /dev/sdae
  14    14      65      240       14      active sync   /dev/sdaf
  15    15       0        0       15      faulty removed
  16    16      66        0       16      spare   /dev/sdag
/dev/sdw:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 012dcc5b:f09d21e4:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:43:51 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 11

    Update Time : Thu Nov 25 10:51:55 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 66d62d19 - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5      65       96        5      active sync   /dev/sdw

   0     0      65       16        0      active sync   /dev/sdr
   1     1      65       32        1      active sync   /dev/sds
   2     2      65       48        2      active sync   /dev/sdt
   3     3      65       64        3      active sync   /dev/sdu
   4     4      65       80        4      active sync   /dev/sdv
   5     5      65       96        5      active sync   /dev/sdw
   6     6      65      112        6      active sync   /dev/sdx
   7     7      65      128        7      active sync   /dev/sdy
   8     8      65      144        8      active sync   /dev/sdz
   9     9      65      160        9      active sync   /dev/sdaa
  10    10      65      176       10      active sync   /dev/sdab
  11    11      65      192       11      active sync   /dev/sdac
  12    12      65      208       12      active sync   /dev/sdad
  13    13      65      224       13      active sync   /dev/sdae
  14    14      65      240       14      active sync   /dev/sdaf
  15    15       0        0       15      faulty removed
  16    16      66        0       16      spare   /dev/sdag
/dev/sdx:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 012dcc5b:f09d21e4:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:43:51 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 11

    Update Time : Thu Nov 25 10:51:55 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 66d62d2b - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     6      65      112        6      active sync   /dev/sdx

   0     0      65       16        0      active sync   /dev/sdr
   1     1      65       32        1      active sync   /dev/sds
   2     2      65       48        2      active sync   /dev/sdt
   3     3      65       64        3      active sync   /dev/sdu
   4     4      65       80        4      active sync   /dev/sdv
   5     5      65       96        5      active sync   /dev/sdw
   6     6      65      112        6      active sync   /dev/sdx
   7     7      65      128        7      active sync   /dev/sdy
   8     8      65      144        8      active sync   /dev/sdz
   9     9      65      160        9      active sync   /dev/sdaa
  10    10      65      176       10      active sync   /dev/sdab
  11    11      65      192       11      active sync   /dev/sdac
  12    12      65      208       12      active sync   /dev/sdad
  13    13      65      224       13      active sync   /dev/sdae
  14    14      65      240       14      active sync   /dev/sdaf
  15    15       0        0       15      faulty removed
  16    16      66        0       16      spare   /dev/sdag
/dev/sdy:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 012dcc5b:f09d21e4:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:43:51 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 11

    Update Time : Thu Nov 25 10:51:55 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 66d62d3d - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     7      65      128        7      active sync   /dev/sdy

   0     0      65       16        0      active sync   /dev/sdr
   1     1      65       32        1      active sync   /dev/sds
   2     2      65       48        2      active sync   /dev/sdt
   3     3      65       64        3      active sync   /dev/sdu
   4     4      65       80        4      active sync   /dev/sdv
   5     5      65       96        5      active sync   /dev/sdw
   6     6      65      112        6      active sync   /dev/sdx
   7     7      65      128        7      active sync   /dev/sdy
   8     8      65      144        8      active sync   /dev/sdz
   9     9      65      160        9      active sync   /dev/sdaa
  10    10      65      176       10      active sync   /dev/sdab
  11    11      65      192       11      active sync   /dev/sdac
  12    12      65      208       12      active sync   /dev/sdad
  13    13      65      224       13      active sync   /dev/sdae
  14    14      65      240       14      active sync   /dev/sdaf
  15    15       0        0       15      faulty removed
  16    16      66        0       16      spare   /dev/sdag
/dev/sdz:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 012dcc5b:f09d21e4:d64d9ae0:217d735e (local to host DigiOcean)
  Creation Time : Thu Nov 25 10:43:51 2010
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 14651437440 (13972.70 GiB 15003.07 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 11

    Update Time : Thu Nov 25 10:51:55 2010
          State : clean
 Active Devices : 15
Working Devices : 16
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 66d62d4f - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     8      65      144        8      active sync   /dev/sdz

   0     0      65       16        0      active sync   /dev/sdr
   1     1      65       32        1      active sync   /dev/sds
   2     2      65       48        2      active sync   /dev/sdt
   3     3      65       64        3      active sync   /dev/sdu
   4     4      65       80        4      active sync   /dev/sdv
   5     5      65       96        5      active sync   /dev/sdw
   6     6      65      112        6      active sync   /dev/sdx
   7     7      65      128        7      active sync   /dev/sdy
   8     8      65      144        8      active sync   /dev/sdz
   9     9      65      160        9      active sync   /dev/sdaa
  10    10      65      176       10      active sync   /dev/sdab
  11    11      65      192       11      active sync   /dev/sdac
  12    12      65      208       12      active sync   /dev/sdad
  13    13      65      224       13      active sync   /dev/sdae
  14    14      65      240       14      active sync   /dev/sdaf
  15    15       0        0       15      faulty removed
  16    16      66        0       16      spare   /dev/sdag

--=-tTa3TroIzFgwoPnXgweM--

