From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Bonnie numbers for RAID-6
Date: 26 Dec 2003 22:59:14 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <bsjak2$b2t$1@cesium.transmeta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Some quick Bonnie numbers run on the RAID-6 code.  The machine has one
P4/1.8 CPU and 512 MB RAM; the file size was 1024 MB and the filesystem a
"virgin" ext3.  Each partition was 10 GB; each disk is a 40 GB ATA/100
drive.  The stripe size was 256 KB.

I suspect RAID-6 write performance should be possible to improve;
currently it doesn't do read-modify-write for the syndrome drives, for
example.


RAID-6 across 6 disks:

              -------Sequential Output-------- ---Sequential Input-- --Random--
              -Per Char- --Block--- -Rewrite-- -Per Char- --Block--- --Seeks---
Machine    MB K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU  /sec %CPU
         1024  4579 95.7 21733  8.4 10993  4.1  4483 93.8 28751  6.5 331.5  3.0

RAID-5 across 5 disks (same capacity):

              -------Sequential Output-------- ---Sequential Input-- --Random--
              -Per Char- --Block--- -Rewrite-- -Per Char- --Block--- --Seeks---
Machine    MB K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU  /sec %CPU
         1024  4622 96.4 56730 23.5 17249  6.4  4651 97.4 29761  6.1 322.4  2.8

RAID-5 across 6 disks:

              -------Sequential Output-------- ---Sequential Input-- --Random--
              -Per Char- --Block--- -Rewrite-- -Per Char- --Block--- --Seeks---
Machine    MB K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU  /sec %CPU
         1024  4597 96.0 28771 11.2 12890  4.7  4558 95.4 29133  6.5 344.3  3.0

Single disk:

              -------Sequential Output-------- ---Sequential Input-- --Random--
              -Per Char- --Block--- -Rewrite-- -Per Char- --Block--- --Seeks---
Machine    MB K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU  /sec %CPU
         1024  4738 98.8 33435 14.2 16157  5.9  4718 97.7 34268  4.3 151.3  0.7
-- 
<hpa@transmeta.com> at work, <hpa@zytor.com> in private!
If you send me mail in HTML format I will assume it's spam.
"Unix gives you enough rope to shoot yourself in the foot."
Architectures needed: ia64 m68k mips64 ppc ppc64 s390 s390x sh v850 x86-64
