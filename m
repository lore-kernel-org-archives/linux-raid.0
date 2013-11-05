From: Alex <mysqlstudent@gmail.com>
Subject: Disk failure questions
Date: Tue, 5 Nov 2013 09:08:50 -0500
Message-ID: <CAB1R3sgi=AQ82kBsdaASNL8=sQK52=vuH_QYriZG9-bVoT6Mfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I have a fedora15 server with four 1TB disks in a RAID5 array and one
disk appears to have gone bad. I'd appreciate it if someone could
confirm these are unrecoverable errors and replacing the disk is the
only solution.

[10704375.779356] ata1.00: failed command: READ FPDMA QUEUED
[10704375.779428] ata1.00: cmd 60/08:40:40:87:9d/00:00:14:00:00/40 tag
8 ncq 4096 in
[10704375.779430]          res 40/00:00:00:00:00/00:00:00:00:00/00
Emask 0x4 (timeout)

[10704435.967343] ata1.00: device reported invalid CHS sector 0
[10704435.967424] sd 0:0:0:0: [sda]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[10704435.967554] sd 0:0:0:0: [sda]  Sense Key : Aborted Command
[current] [descriptor]
[10704435.967690] Descriptor sense data with sense descriptors (in hex):
[10704435.967760]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[10704435.967869]         00 00 00 00
[10704435.967944] sd 0:0:0:0: [sda]  Add. Sense: No additional sense information
[10704435.968029] sd 0:0:0:0: [sda] CDB: Read(10): 28 00 14 9d 87 00 00 00 08 00
[10704435.968174] end_request: I/O error, dev sda, sector 345868032

This repeated a number of times with different sectors.

[10704435.995540] md/raid:md1: Disk failure on sda3, disabling device.
[10704435.995542] md/raid:md1: Operation continuing on 3 devices.

[10704436.065083] sd 0:0:0:0: [sda] Unhandled error code
[10704436.065161] sd 0:0:0:0: [sda]  Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[10704436.065298] sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 00 d1 43 78
00 00 10 00
[10704436.065470] end_request: I/O error, dev sda, sector 13714296
[10704436.065619] md/raid:md0: Disk failure on sda2, disabling device.
[10704436.065622] md/raid:md0: Operation continuing on 3 devices.

Thanks for any ideas.
Alex
