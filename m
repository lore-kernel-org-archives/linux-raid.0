From: "RANSOM, Tony" <tony.ransom@baesystems.com>
Subject: Problem rebuild raid 1 replacement disk
Date: Mon, 20 Feb 2012 14:41:04 +1030
Message-ID: <807765805CA0DF48898D4C016E982BFC065A67CE25@MWLSVEXM002.au.baesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I'm having problems getting a replacement drive to rebuild after a disk failure. 

I'm running a 10.04 server using two 2TB WD caviar drives in a linux s/w raid 1 configuration.

The two drives were set up during Ubuntu install.

They contain three partitions, as follows:

------------------------------

Quote:
root@server2:~# gdisk /dev/sda
GPT fdisk (gdisk) version 0.8.2

Partition table scan:
MBR: protective
BSD: not present
APM: not present
GPT: present

Found valid GPT with protective MBR; using GPT.

Command (? for help): p
Disk /dev/sda: 3907029168 sectors, 1.8 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): 87B365C3-1217-47F4-9122-F8DD1F386153
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 3907029134
Partitions will be aligned on 2048-sector boundaries
Total free space is 387181 sectors (189.1 MiB)

Number Start (sector) End (sector) Size Code Name
1 2048 4095 1024.0 KiB EF02 bios
2 4096 589823 286.0 MiB FD00 boot
3 589824 906643967 1.8 TiB FD00 root

-----------------------

The disk shown above is the replacement drive. I have set it up identically to the original drive.

Below shows the array rebuilding after the disk is replaced. As you'd expect.

-----------------------

Quote:
root@server2:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md1 : active raid1 sdb3[2] sda3[1]
1953027008 blocks [2/1] [_U]
[>....................] recovery = 0.0% (225792/1953027008) finish=864.8min speed=37632K/sec

md0 : active raid1 sdb2[0] sda2[1]
292800 blocks [2/2] [UU]

---------------------------

The arrays rebuild correctly and seem to be working as they should.

The problem happens when the box is rebooted.

The array goes into degraded mode. It starts to incorrectly rebuild the array as shown below. It ignores md0, and tries to rebuild the md1 array to sdb, not sdb3.

----------------------------------

Quote:
root@server2:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md1 : active raid1 sdb[2] sda3[1]
1953027008 blocks [2/1] [_U]
[=>...................] recovery = 9.0% (177317632/1953027008) finish=453.9min speed=65198K/sec

md0 : active raid1 sda2[1]
292800 blocks [2/1] [_U]

-------------------------------

When I check the sdb disk partition table, it is corrupted ....

Quote:
root@server2:~# gdisk /dev/sdb
GPT fdisk (gdisk) version 0.8.2

Caution: invalid main GPT header, but valid backup; regenerating main header
from backup!

Caution! After loading partitions, the CRC doesn't check out!
Warning! Main partition table CRC mismatch! Loaded backup partition table
instead of main partition table!

Warning! One or more CRCs don't match. You should repair the disk!

Partition table scan:
MBR: not present
BSD: not present
APM: not present
GPT: damaged

Found invalid MBR and corrupt GPT. What do you want to do? (Using the
GPT MAY permit recovery of GPT data.)
1 - Use current GPT
2 - Create blank GPT

--------------------------------

I've checked the new disk with WD's diagnostic software. It passes the extended test.

I'm presently trying for the third time to get this to work. I'm not confident as I'm not really doing anything differently from the first two efforts.

Note: I've also posted this on the Ubuntu server forum, to date without success. http://ubuntuforums.org/showthread.php?t=1927909 

Hopefully, the people who are familiar with the workings of the software will know what the problem might be.

Any assistance is greatly appreciated.

Thanks,
Tony
"Warning:
The information contained in this email and any attached files is
confidential to BAE Systems Australia. If you are not the intended
recipient, any use, disclosure or copying of this email or any
attachments is expressly prohibited.  If you have received this email
in error, please notify us immediately. VIRUS: Every care has been
taken to ensure this email and its attachments are virus free,
however, any loss or damage incurred in using this email is not the
sender's responsibility.  It is your responsibility to ensure virus
checks are completed before installing any data sent in this email to
your computer."


