From: Mateusz Korniak <mateusz-lists@ant.gliwice.pl>
Subject: Reads from write-mostly HDD instead from  _non_ write-mostly SDD as expected?
Date: Mon, 11 Aug 2014 16:06:50 +0200
Message-ID: <2087754.WKjlnWuPkK@matkor-toshiba>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!
I am trying to use two --write-mostly HDDs (sda5 & sdd5) and single SDD=
 (sdc1)=20
as RAID0 for my database partition.

# cat /proc/mdstat                                                     =
                                                                       =
                                                                       =
                                    =20
Personalities : [raid10] [raid1]=20
md9 : active raid1 sdc1[0] sda5[3](W) sdd5[4](W)
      117152576 blocks super 1.2 [3/3] [UUU]
      bitmap: 1/1 pages [4KB], 65536KB chunk

but seems as reads are directed to wrong drive (sdd):

Device: rrqm/s    r/s  rMB/s  avgrq-sz r_await  svctm   %util
sdc     0.00     0.00   0.00     35.24    0.00   0.82   11.50
sda     0.07     1.10   0.01     32.57   31.39   1.92   30.32
sdd     0.37   268.23   3.18     28.05   13.95   2.43  100.45
md9     0.00   268.57   3.18     24.89    0.00   0.00    0.00


How can I fix it?

At beginning it worked as expected (all reads from sdc),  later I did f=
ew --
add/--replace  --write-mostly operations and it broke.

TIA, regards,

Linux 3.14.7-1 #1 SMP Thu Jun 12 14:32:56 CEST 2014 x86_64=20
mdadm - v3.3.1 - 5th June 2014


--=20
Mateusz Korniak
"(...) mam brata - powa=C5=BCny, domator, liczykrupa, hipokryta, pobo=C5=
=BCni=C5=9B,
 	kr=C3=B3tko m=C3=B3wi=C4=85c - podpora spo=C5=82ecze=C5=84stwa."
				Nikos Kazantzakis - "Grek Zorba"

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
