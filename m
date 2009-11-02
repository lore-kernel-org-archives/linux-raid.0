From: Jesse Wheeler <jwwstpete@gmail.com>
Subject: Random MD Raid resyncs?
Date: Mon, 2 Nov 2009 09:57:20 -0500
Message-ID: <f1ef83020911020657w1494e31ao716203f9fb9f0d8f@mail.gmail.com>
References: <f1ef83020911020655kf8935c5icf9aea31edb03c57@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f1ef83020911020655kf8935c5icf9aea31edb03c57@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

All:

Thanks for the invaluable resource that is this mailing list. =A0I've
learned quite a bit over the space of this month.

I have the following configuration and question:

-- SNIP --

=3D=3D

Linux version 2.6.18-164.2.1.el5 (mockbuild@builder10.centos.org) (gcc
version 4.1.2 20080704 (Red Hat 4.1.2-46)) #1 SMP Wed Sep 30 12:52:46
EDT 2009. =A0CentOS 5.4

=3D=3D

Personalities : [raid10] [raid6] [raid5] [raid4]
md1 : active raid5 sda2[0] sdb1[1] sdc1[2] sdd1[3] sde1[4] sdf1[5]
=A0 =A0 =A0393230080 blocks level 5, 256k chunk, algorithm 2 [6/6] [UUU=
UUU]

md2 : active raid5 sda4[0] sdb4[1] sdc3[2] sdd3[3] sde3[4] sdf4[5]
=A0 =A0 =A0424034560 blocks level 5, 256k chunk, algorithm 2 [6/6] [UUU=
UUU]
=A0 =A0 =A0[=3D=3D=3D>.................] =A0resync =3D 17.4% (14793792/=
84806912)
finish=3D19.4min speed=3D60024K/sec

md0 : active raid10 sdf2[5] sde2[4] sdd2[3] sdc2[2] sdb2[1] sda3[0]
=A0 =A0 =A0235938048 blocks 256K chunks 2 near-copies [6/6] [UUUUUU]

=3D=3D

[root@fatboy log]# mdadm --detail /dev/md0
/dev/md0:
=A0 =A0 =A0 =A0Version : 0.90
=A0Creation Time : Sun Nov =A01 11:24:00 2009
=A0 =A0 Raid Level : raid10
=A0 =A0 Array Size : 235938048 (225.01 GiB 241.60 GB)
=A0Used Dev Size : 78646016 (75.00 GiB 80.53 GB)
=A0 Raid Devices : 6
=A0Total Devices : 6
Preferred Minor : 0
=A0 =A0Persistence : Superblock is persistent

=A0 =A0Update Time : Mon Nov =A02 09:46:48 2009
=A0 =A0 =A0 =A0 =A0State : clean
=A0Active Devices : 6
Working Devices : 6
=A0Failed Devices : 0
=A0Spare Devices : 0

=A0 =A0 =A0 =A0 Layout : near=3D2
=A0 =A0 Chunk Size : 256K

=A0 =A0 =A0 =A0 =A0 UUID : 0d994fe1:d4b4be70:3fe15b01:0e4bd6cb
=A0 =A0 =A0 =A0 Events : 0.4

=A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
=A0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A03 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync =A0 /dev/sda3
=A0 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 18 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb2
=A0 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 34 =A0 =A0 =A0 =A02 =A0 =A0 =A0=
active sync =A0 /dev/sdc2
=A0 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 50 =A0 =A0 =A0 =A03 =A0 =A0 =A0=
active sync =A0 /dev/sdd2
=A0 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0 66 =A0 =A0 =A0 =A04 =A0 =A0 =A0=
active sync =A0 /dev/sde2
=A0 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 82 =A0 =A0 =A0 =A05 =A0 =A0 =A0=
active sync =A0 /dev/sdf2

=3D=3D

[root@fatboy log]# mdadm --detail /dev/md1
/dev/md1:
=A0 =A0 =A0 =A0Version : 0.90
=A0Creation Time : Sun Nov =A01 11:28:46 2009
=A0 =A0 Raid Level : raid5
=A0 =A0 Array Size : 393230080 (375.01 GiB 402.67 GB)
=A0Used Dev Size : 78646016 (75.00 GiB 80.53 GB)
=A0 Raid Devices : 6
=A0Total Devices : 6
Preferred Minor : 1
=A0 =A0Persistence : Superblock is persistent

=A0 =A0Update Time : Mon Nov =A02 09:39:51 2009
=A0 =A0 =A0 =A0 =A0State : clean
=A0Active Devices : 6
Working Devices : 6
=A0Failed Devices : 0
=A0Spare Devices : 0

=A0 =A0 =A0 =A0 Layout : left-symmetric
=A0 =A0 Chunk Size : 256K

=A0 =A0 =A0 =A0 =A0 UUID : f537dfcb:fe7bd1a9:68316ddd:10b55eed
=A0 =A0 =A0 =A0 Events : 0.14

=A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
=A0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A02 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync =A0 /dev/sda2
=A0 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb1
=A0 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A02 =A0 =A0 =A0=
active sync =A0 /dev/sdc1
=A0 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 =A03 =A0 =A0 =A0=
active sync =A0 /dev/sdd1
=A0 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0 65 =A0 =A0 =A0 =A04 =A0 =A0 =A0=
active sync =A0 /dev/sde1
=A0 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A05 =A0 =A0 =A0=
active sync =A0 /dev/sdf1

=3D=3D

[root@fatboy log]# mdadm --detail /dev/md2
/dev/md2:
=A0 =A0 =A0 =A0Version : 0.90
=A0Creation Time : Sun Nov =A01 11:25:03 2009
=A0 =A0 Raid Level : raid5
=A0 =A0 Array Size : 424034560 (404.39 GiB 434.21 GB)
=A0Used Dev Size : 84806912 (80.88 GiB 86.84 GB)
=A0 Raid Devices : 6
=A0Total Devices : 6
Preferred Minor : 2
=A0 =A0Persistence : Superblock is persistent

=A0 =A0Update Time : Mon Nov =A02 08:10:46 2009
=A0 =A0 =A0 =A0 =A0State : clean, resyncing
=A0Active Devices : 6
Working Devices : 6
=A0Failed Devices : 0
=A0Spare Devices : 0

=A0 =A0 =A0 =A0 Layout : left-symmetric
=A0 =A0 Chunk Size : 256K

=A0Rebuild Status : 33% complete

=A0 =A0 =A0 =A0 =A0 UUID : 0030789c:58c839d6:6529cdec:6347f0f3
=A0 =A0 =A0 =A0 Events : 0.64

=A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
=A0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A04 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync =A0 /dev/sda4
=A0 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 20 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb4
=A0 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 35 =A0 =A0 =A0 =A02 =A0 =A0 =A0=
active sync =A0 /dev/sdc3
=A0 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 51 =A0 =A0 =A0 =A03 =A0 =A0 =A0=
active sync =A0 /dev/sdd3
=A0 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0 67 =A0 =A0 =A0 =A04 =A0 =A0 =A0=
active sync =A0 /dev/sde3
=A0 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 84 =A0 =A0 =A0 =A05 =A0 =A0 =A0=
active sync =A0 /dev/sdf4

=3D=3D

-- END SNIP --

My question (please forgive the ignorance if it is showing -- I'm used
to FreeBSD and Solaris) is this..

I am noticing that my MD0 (Raid10), MD1 (Raid5), MD2 (Raid 5) arrays
"seem" to be resyncing at somewhat random intervals. =A0Mind you, I hav=
e
also noticed that the kernel has put a 'governor' on the resync
process as to limit performance issues. =A0Is this normal behavior? I'v=
e
checked CRON thinking that the resync might be a scheduled occurance,
as well as my /var/log/messages. =A0The only indication in the SYSLOG
are events like:

-- SNIP --

Nov =A02 09:15:42 fatboy dnsmasq[3648]: exiting on receipt of SIGTERM
Nov =A02 09:15:43 fatboy dnsmasq[6922]: started, version 2.45 cachesize=
 150
Nov =A02 09:15:43 fatboy dnsmasq[6922]: compile time options: IPv6
GNU-getopt no-ISC-leasefile no-DBus no-I18N TFTP
Nov =A02 09:15:43 fatboy dnsmasq[6922]: using local addresses only for
domain devotioconsulting.net
Nov =A02 09:15:43 fatboy dnsmasq[6922]: using nameserver 208.67.220.220=
#53
Nov =A02 09:15:43 fatboy dnsmasq[6922]: using nameserver 208.67.222.222=
#53
Nov =A02 09:15:43 fatboy dnsmasq[6922]: read /etc/hosts - 14 addresses
Nov =A02 09:21:04 fatboy kernel: md: syncing RAID array md1
Nov =A02 09:21:04 fatboy kernel: md: minimum _guaranteed_ reconstructio=
n
speed: 1000 KB/sec/disc.
Nov =A02 09:21:04 fatboy kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for reconstruction.
Nov =A02 09:21:04 fatboy kernel: md: using 128k window, over a total of
78646016 blocks.
Nov =A02 09:21:04 fatboy kernel: md: delaying resync of md2 until md1
has finished resync (they share one or more physical units)
Nov =A02 09:39:51 fatboy kernel: md: md1: sync done.

-- END SNIP

=2E. which do not indicate any outward hardware reason (i.e. LMSensors,
my UPS Monitoring daemon, etc) are not picking up any events to
trigger the resync process.

Is this normal?

I would think it somewhat odd to have an array just 'resync' randomly.

Please let me know if I am missing something.

--
Jesse W. Wheeler
Member-Owner
Devotio Consulting, L.L.C.
--



--=20
Jesse W. Wheeler
mailto: jwwstpete@gmail.com
Charlotte, North Carolina - U.S.A.

=3D=3D
"I'm a white male, age 18 to 49. Everyone listens to me, no matter how
dumb my suggestions are." --Homer Simpson

"I really don't understand how bipartisanship is ever going to work
when one of the parties is insane."-- John Cole

"I defy the tyranny of precedent. I cannot afford the luxury of a
closed mind. I go for anything new that might improve the past." --
Clara Barton

"Any dictator would admire the uniformity and obedience of the U.S.
media." -- Noam Chomsky

"We are called to speak for the weak, for the voiceless, for victims
of our nation and for those it calls enemy...". -- Martin Luther King,
"Beyond Vietnam"

"Be yourself; everyone else is already taken." - Oscar Wilde

* My Other Car is a Health Insurance Payment
* My Car Has Better Insurance Than I Do
* My Death Panel is an HMO
* Underinsured Baby on Board
* WWJD:   Who Would Jesus Deny? (Healthcare Reform Now!)

"Quitbull with Lipstick: She's a gift that keeps on giving; an
Everlasting Gobstopper of fail." -- SilentBrook on DKos talking about
Palin
=3D=3D
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
