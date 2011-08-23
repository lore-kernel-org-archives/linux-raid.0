From: Mike Viau <viaum@sheridanc.on.ca>
Subject: Raid 5 to Raid 1 (half of the data not required)
Date: Tue, 23 Aug 2011 19:41:11 -0400
Message-ID: <BAY148-W51F7F3A42E515F76BB76EFEF2E0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello,

I am trying to convert my currently running raid 5 array into a raid 1.=
 All the guides I can see online are for the reverse direction in which=
 one is converting/migrating a raid 1 to raid 5. I have intentionally o=
nly allocated exactly half of the total raid 5 size is. I would like to=
 create the raid 1 over /dev/sdb1 and /dev/sdc1 with the data on the ra=
id 5 running with the same drives plus /dev/sde1. Is this possible, I w=
ish to have the data redundantly over two hard drive without the parity=
 which is present in raid 5?

Thanks for any help in advance :)


# mdadm -D /dev/md0
/dev/md0:
=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
=A0 Creation Time : Mon Dec 20 09:48:07 2010
=A0=A0=A0=A0 Raid Level : raid5
=A0=A0=A0=A0 Array Size : 1953517568 (1863.02 GiB 2000.40 GB)
=A0 Used Dev Size : 976758784 (931.51 GiB 1000.20 GB)
=A0=A0 Raid Devices : 3
=A0 Total Devices : 3
=A0=A0=A0 Persistence : Superblock is persistent

=A0=A0=A0 Update Time : Tue Aug 23 11:34:00 2011
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
=A0Active Devices : 3
Working Devices : 3
=A0Failed Devices : 0
=A0 Spare Devices : 0

=A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
=A0=A0=A0=A0 Chunk Size : 512K

=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : HOST:0=A0 (local to host HOST)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : 7d8a7c68:95a230d0:0a8f6e74:4c8f81=
e9
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 55750

=A0=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 17=A0=A0=A0=A0=
=A0=A0=A0 0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdb1
=A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 33=A0=A0=A0=A0=
=A0=A0=A0 1=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdc1
=A0=A0=A0=A0=A0=A0 3=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 65=A0=A0=A0=A0=
=A0=A0=A0 2=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sde1


-M
 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
