From: "Bodo Thiesen" <bothie@gmx.de>
Subject: RAID5, 2 out of 4 disks failed, Events value differs too much
Date: Tue, 05 Dec 2006 09:48:02 +0100
Message-ID: <20061205084802.16720@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, I have a little problem:

Some hours ago the second of four disks were kicked out of my RAID5 thu=
s rendering it unusable. As of my current knowledge, the disks are stil=
l working correctly (I assume a cable connection problem) but that's no=
t the problem. The real problem is, that the first failed disk has an e=
vent value of 9102893, the second failed disk has a value of 9324862 an=
d the other two disks have a value of 9324869. In this case, what is th=
e best to do to recover the RAID? Because just recreating the array wit=
h the 9324862-disk and the two 9324869-disks and later hotadding the 91=
02893-disk, is just unclean and as I understood it, this would trigger =
some silent data failures. Is there a chance to prevent this data failu=
res to happen at all, or is it at least possible to tell, where this er=
ror(s) are (so I can manually check the data and take appropriate steps=
)? Remember that I still have the data from the first failed disk, from=
 which parts may still be relatively up to date.

Has anyone had this problem already and found a nice solution for this?

Regards in advance, Bodo

mdadm -E on all affected disks:
--> please bite here <---> please bite here <---> please bite here <--
/dev/mapper/sda:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 876ed759:74a31656:94332345:a976171b
  Creation Time : Thu Feb  2 05:30:53 2006
     Raid Level : raid5
    Device Size : 244198464 (232.89 GiB 250.06 GB)
     Array Size : 732595392 (698.66 GiB 750.18 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Wed Nov 29 03:12:12 2006
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 7bd96cb9 - correct
         Events : 0.9102893

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     1     253        0        1      active sync   /dev/mapper/sda

   0     0     253        2        0      active sync   /dev/mapper/sdc
   1     1     253        0        1      active sync   /dev/mapper/sda
   2     2     253        1        2      active sync   /dev/mapper/sdb
   3     3     253        3        3      active sync   /dev/mapper/sdd
/dev/mapper/sdb:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 876ed759:74a31656:94332345:a976171b
  Creation Time : Thu Feb  2 05:30:53 2006
     Raid Level : raid5
    Device Size : 244198464 (232.89 GiB 250.06 GB)
     Array Size : 732595392 (698.66 GiB 750.18 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Tue Dec  5 04:31:06 2006
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 7be82e68 - correct
         Events : 0.9324862

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     2     253        1        2      active sync   /dev/mapper/sdb

   0     0     253        2        0      active sync   /dev/mapper/sdc
   1     1       0        0        1      faulty removed
   2     2     253        1        2      active sync   /dev/mapper/sdb
   3     3     253        3        3      active sync   /dev/mapper/sdd
/dev/mapper/sdc:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 876ed759:74a31656:94332345:a976171b
  Creation Time : Thu Feb  2 05:30:53 2006
     Raid Level : raid5
    Device Size : 244198464 (232.89 GiB 250.06 GB)
     Array Size : 732595392 (698.66 GiB 750.18 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Tue Dec  5 04:45:20 2006
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 4
  Spare Devices : 0
       Checksum : 7be831d7 - correct
         Events : 0.9324869

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     0     253        2        0      active sync   /dev/mapper/sdc

   0     0     253        2        0      active sync   /dev/mapper/sdc
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3     253        3        3      active sync   /dev/mapper/sdd
/dev/mapper/sdd:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 876ed759:74a31656:94332345:a976171b
  Creation Time : Thu Feb  2 05:30:53 2006
     Raid Level : raid5
    Device Size : 244198464 (232.89 GiB 250.06 GB)
     Array Size : 732595392 (698.66 GiB 750.18 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Tue Dec  5 04:45:20 2006
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 4
  Spare Devices : 0
       Checksum : 7be831de - correct
         Events : 0.9324869

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     3     253        3        3      active sync   /dev/mapper/sdd

   0     0     253        2        0      active sync   /dev/mapper/sdc
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3     253        3        3      active sync   /dev/mapper/sdd
--> please bite here <---> please bite here <---> please bite here <--
--=20
"Ein Herz f=FCr Kinder" - Ihre Spende hilft! Aktion: www.deutschlandseg=
elt.de
Unser Dankesch=F6n: Ihr Name auf dem Segel der 1. deutschen America's C=
up-Yacht!
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
