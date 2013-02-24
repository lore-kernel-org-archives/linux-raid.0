From: Stone <stone@heisl.org>
Subject: Re: Brocken Raid & LUKS
Date: Sun, 24 Feb 2013 19:22:18 +0100
Message-ID: <512A5A5A.5020904@heisl.org>
References: <5123A1CC.2000003@heisl.org> <51265824.4030407@heisl.org> <51265B0B.9020108@turmel.org> <51265DA7.2030209@heisl.org> <512660B9.8090609@turmel.org> <5126629A.1090002@heisl.org> <51266360.9030402@turmel.org> <5126678D.9030101@heisl.org> <51266D73.5020700@turmel.org> <51267192.6090205@heisl.org> <51267467.9040603@turmel.org> <512675A6.1000801@heisl.org> <5126797C.8090105@heisl.org> <51269DE0.5070905@heisl.org> <512748FA.2000709@heisl.org> <51277876.30008@turmel.org> <51278793.80904@heisl.org> <512790AE.2080102@turmel.org> <5127B64A.3000808@heisl.org> <5127D857.9090204@heisl.org> <5127F2B8.4050601@turmel.org> <5127F45F.5020608@heisl.org> <512827FC.7010403@turmel.org> <5128336E.5060809@heisl.org> <51284762.2080202@turmel.org> <51289798.7050500@heisl.org> <5128E9F4.5040700@turmel.org
 > <5129421C.7070105@heisl.org> <51295599.5040907@turmel.org> <51295B1B.2030404@heisl.org> <51299135.1000206@turmel.org> <5129BCCC.7090202@heisl.org> <512A2094.3020008@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <512A2094.3020008@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am 24.02.2013 15:15, schrieb Phil Turmel:
> On 02/24/2013 02:10 AM, Stone wrote:
>
>> e2fsck: aborted
>>
>> the output have 711mb..
>> do you ned more examples?
>> what do you say to case1?
> I think you need to see case2.  Case #1 isn't very good.
>
> Phil
>
roger.

  print
Model: ATA WDC WD20EARS-00M (scsi)
Disk /dev/sdc: 3907029168s
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start  End          Size         File system  Name     Flags
  1      34s    3907029118s  3907029085s               primary


fsck:
One or more block group descriptor checksums are invalid.  Fix? no

Group descriptor 0 checksum is invalid.  IGNORED.
Group descriptor 1 checksum is invalid.  IGNORED.
Group descriptor 2 checksum is invalid.  IGNORED.
Group descriptor 3 checksum is invalid.  IGNORED. -> up to 44712
...
....
HTREE directory inode 6140 has an invalid root node.
Clear HTree index? no

Inode 6140 should not have EOFBLOCKS_FL set (size 11864516288231708776, 
lblk -1)
Clear? no

Inode 6140, i_size is 11864516288231708776, should be 0.  Fix? no

Inode 6140, i_blocks is 146149627678319, should be 0.  Fix? no

Inode 6141 is in use, but has dtime set.  Fix? no

Inode 6141 has imagic flag set.  Clear? no

Inode 6141 has a extra size (39571) which is invalid
Fix? no

Inode 6141 has compression flag set on filesystem without compression 
support.  Clear? no

Inode 6141, i_size is 9532800016578411510, should be 0.  Fix? no

Inode 6141, i_blocks is 44690332653787, should be 0.  Fix? no
.....
....
....
Suppress messages? no

Illegal block #2039 (1737394854) in inode 5693.  IGNORED.
Illegal block #2040 (2008213591) in inode 5693.  IGNORED.
Illegal block #2041 (2130466482) in inode 5693.  IGNORED.
Illegal block #2042 (1739888040) in inode 5693.  IGNORED.
Illegal block #2043 (1807109420) in inode 5693.  IGNORED.
Illegal block #2044 (3445204660) in inode 5693.  IGNORED.
Illegal block #2045 (1712689420) in inode 5693.  IGNORED.
Illegal block #2046 (1938106967) in inode 5693.  IGNORED.
Illegal block #2047 (3704437218) in inode 5693.  IGNORED.
Illegal block #2048 (2131383249) in inode 5693.  IGNORED.
Illegal block #2049 (2676662235) in inode 5693.  IGNORED.
Illegal block #2050 (2662461689) in inode 5693.  IGNORED.
Too many illegal blocks in inode 5693.
Clear inode? no

Suppress messages? no

Illegal block #2051 (4286896066) in inode 5693.  IGNORED.
Illegal block #2055 (3899334065) in inode 5693.  IGNORED.
Illegal block #2056 (3410742419) in inode 5693.  IGNORED.
Illegal block #2057 (3944198843) in inode 5693.  IGNORED.
Illegal block #2058 (3374907392) in inode 5693.  IGNORED.
Illegal indirect block (2165853531) in inode 5693.  IGNORED.
Error while iterating over blocks in inode 5693: Illegal indirect block 
found
e2fsck: aborted

same shit different partion.
the logfile have 708mb
:(


