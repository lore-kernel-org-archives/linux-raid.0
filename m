From: Stone <stone@heisl.org>
Subject: Re: Brocken Raid & LUKS
Date: Sun, 24 Feb 2013 08:10:04 +0100
Message-ID: <5129BCCC.7090202@heisl.org>
References: <5123A1CC.2000003@heisl.org> <51265132.7070706@turmel.org> <512656B5.4090505@heisl.org> <51265824.4030407@heisl.org> <51265B0B.9020108@turmel.org> <51265DA7.2030209@heisl.org> <512660B9.8090609@turmel.org> <5126629A.1090002@heisl.org> <51266360.9030402@turmel.org> <5126678D.9030101@heisl.org> <51266D73.5020700@turmel.org> <51267192.6090205@heisl.org> <51267467.9040603@turmel.org> <512675A6.1000801@heisl.org> <5126797C.8090105@heisl.org> <51269DE0.5070905@heisl.org> <512748FA.2000709@heisl.org> <51277876.30008@turmel.org> <51278793.80904@heisl.org> <512790AE.2080102@turmel.org> <5127B64A.3000808@heisl.org> <5127D857.9090204@heisl.org> <5127F2B8.4050601@turmel.org> <5127F45F.5020608@heisl.org> <512827FC.7010403@turmel.org> <5128336E.5060809@heisl.org> <51284762.2080202@turmel.org
 > <51289798.7050500@heisl.org> <5128E9F4.5040700@turmel.org> <5129421C.7070105@heisl.org> <51295599.5040907@turmel.org> <51295B1B.2030404@heisl.org> <51299135.1000206@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51299135.1000206@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am 24.02.2013 05:04, schrieb Phil Turmel:
> On 02/23/2013 07:13 PM, Stone wrote:
>> Am 24.02.2013 00:49, schrieb Phil Turmel:
>>>>> 1) The partition doesn't go far enough to the end of the disk,
>>> For this, repartition /dev/sdc to start at sector 2048 and end at
>>> 3907029118.  Then re-create the array, open luks, and do "fsck -n" and
>>> show the results.
>> roger that.
>> i would do this:
>> parted /dev/sdc
>> unit s
>> resize 1 2048 3907029118
>> parted /dev/sdc unit s print -> to check my new settings
>> recreate the md2 device with chunk 512 and the order we find out.
>> open luks
>> check it with fsck -n and report you my (errors) result.
> Do not use "resize".  (And it doesn't exist in current versions of
> parted anyways.)  Use rm then mkpart.
>
> Otherwise, Yes.
frist try:
parted /dev/sdc unit s print
Model: ATA WDC WD20EARS-00M (scsi)
Disk /dev/sdc: 3907029168s
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start  End          Size         File system  Name     Flags
  1      2048s  3907029118s  3907027071s               primary

One or more block group descriptor checksums are invalid.  Fix? no

Group descriptor 0 checksum is invalid.  IGNORED.
Group descriptor 1 checksum is invalid.  IGNORED.
Group descriptor 2 checksum is invalid.  IGNORED.
Group descriptor 3 checksum is invalid.  IGNORED. -> Up to 44712
...
...
Inode 12130 has a extra size (40545) which is invalid
Fix? no

Inode 12131 is in use, but has dtime set.  Fix? no

Inode 12131 has a extra size (60293) which is invalid
Fix? no

Inode 12131, i_size is 10232047334267190319, should be 0.  Fix? no

Inode 12131, i_blocks is 205664983023728, should be 0.  Fix? no

Inode 12132 is in use, but has dtime set.  Fix? no

Inode 12132 has a extra size (15477) which is invalid
Fix? no
...
...
and on the end
Suppress messages? no

Illegal block #1020 (3776472337) in inode 11884.  IGNORED.
Illegal block #1023 (4146244532) in inode 11884.  IGNORED.
Illegal block #1026 (3701080588) in inode 11884.  IGNORED.
Illegal block #1028 (3560657754) in inode 11884.  IGNORED.
Illegal block #1029 (3846570075) in inode 11884.  IGNORED.
Illegal block #1030 (2560600395) in inode 11884.  IGNORED.
Illegal block #1031 (2695974737) in inode 11884.  IGNORED.
Illegal block #1034 (3747644559) in inode 11884.  IGNORED.
Illegal block #1035 (3005116177) in inode 11884.  IGNORED.
Illegal indirect block (3855214404) in inode 11884.  IGNORED.
Error while iterating over blocks in inode 11884: Illegal indirect block 
found
e2fsck: aborted

the output have 711mb..
do you ned more examples?
what do you say to case1?

>
>>>>> 2) The partition starts too far into the disk (move start sector to 34
>>>>> like sdb and sde).
>>>>>
>>>>> For this, repartition /dev/sdc to start at 34 and end at 3907029118.
>>>>> This makes it match sdb and sde.  Then re-create the array, open luks,
>>>>> and do "fsck -n" and show the results.
>> this is the next step if you say step one is the wrong one.
>> parted /dev/sdc
>> unit s
>> resize 1 34 3907029118
>> parted /dev/sdc1 unit s print -> to check my new settings
>> recreate the md2 device with chunk 512 and the order we find out.
>> open luks
>> check it with fsck -n and report you again my (errors) result.
> Same here.  Delete the partition with rm, then create it at the new
> location and size.
>
> Phil

