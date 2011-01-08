From: Matthew Gabeler-Lee <cheetah@fastcat.org>
Subject: Re: Bug#597563: grub-common: grub-probe segfaults scanning lvm devices
Date: Sat, 08 Jan 2011 18:38:55 -0500
Message-ID: <4D28F58F.7000401@fastcat.org>
References: <20100920202854.27101.8288.reportbug@cheetah.fastcat.org> <4D274FF9.8010004@gmail.com> <alpine.DEB.2.00.1101072241560.25170@cheetah.fastcat.org> <4D285B79.9040100@gmail.com> <alpine.DEB.2.00.1101081739500.14736@cheetah.fastcat.org> <4D28F48C.1030806@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030002090204090605050507"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D28F48C.1030806@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= <phcoder@gmail.com>
Cc: 597563@bugs.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------030002090204090605050507
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/8/2011 18:34, Vladimir 'φ-coder/phcoder' Serbinenko wrote:
> Sorry, I've noticed that I've looked into the wrong place all the long.
> md2 is fine. I suppose it's a problem with md0 (all mdraid are assembled
> at the beginning). Since md0 is raid1, its misassembly wouldn't have any
> influence (we don't write to devices). mdstat lists both md0 and md1 as
> having no duplicate indices. I would need info on md0 for this (now
> minor) remaining bug.
$ sudo mdadm -QD /dev/md0
/dev/md0:
         Version : 0.90
   Creation Time : Mon Mar 27 14:03:04 2006
      Raid Level : raid1
      Array Size : 2008000 (1961.27 MiB 2056.19 MB)
   Used Dev Size : 2008000 (1961.27 MiB 2056.19 MB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Sat Jan  8 18:35:47 2011
           State : clean
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

            UUID : 9364f7a2:d74695d5:7d8db3a0:3b5f9e48
          Events : 0.10758124

     Number   Major   Minor   RaidDevice State
        0       8       17        0      active sync   /dev/sdb1
        1       8       33        1      active sync   /dev/sdc1
        2       8        1        2      active sync   /dev/sda1
        3       8       49        3      active sync   /dev/sdd1

Output of "for i in a b c d ; do sudo dd if=/dev/sd${i}1 
of=sd${i}1.last64k.img skip=$((2008000)) bs=1024 count=64 ; done" is attached.

-- 
	-Matt
"Reality is that which, when you stop believing in it, doesn't go away".
                 -- Philip K. Dick
GPG pubkey fingerprint: A57F B354 FD30 A502 795B 9637 3EF1 3F22 A85E 2AD1


--------------030002090204090605050507
Content-Type: application/octet-stream;
 name="last64k.md0.tar.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="last64k.md0.tar.bz2"

QlpoOTFBWSZTWQcPIEcAClT///3AIkFgyf+MBUOkFP7ungZAAhoBXSAIAEAEgoAARAOcwAHc
AAOMjTJiaDJkwmmQMhoDQGmTQwAmgMcZGmTE0GTJhNMgZDQGgNMmhgBNAY4yNMmJoMmTCaZA
yGgNAaZNDACaAwVJTREyFHhT9UbRB6ZIeoYRtR6Zqj1BjJtJpPUeZTpNR0jXjGaw9Oc3zjNJ
4dgum/9JdtkyZCxiKIi8oiElSkrdjwReNyPKfXFofKLxmNsq668Wi0WjWi+KRSQsUREg3ign
Bw7WW6+NYcJg3MIwjw5TCLIn1USiiQDiKjkO7iMQviXl90Li6wtCbBUSqXVE8xpuI0GWOeLI
7hunefobJmKjYjIZsyyRniiRuH6+g+SSXqilRj5ebPkwjLGONmNrLFm8Xx4orYONRS4xxNrJ
iXxWSLRi7y2ufdC/HiipL85RxlGg6CxqNGX/dGsTsOsuj6MUnTC61Vn90W0Go5HUwPG33rMp
PshccHd1ToL46zzD3jXjKdB/RaHZGA3Ycu4ujsjsPgYf+VvGk7TUc5pO0Y/+O8zQsdx3n5nM
feYppKkSSSajSTA+Iu5IpwoSAOHkCOA=
--------------030002090204090605050507--
