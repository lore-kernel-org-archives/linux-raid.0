From: David Greaves <david@dgreaves.com>
Subject: RAID5 - 2nd drive died whilst waiting for RMA
Date: Fri, 12 Nov 2004 10:07:33 +0000
Message-ID: <41948B65.3090504@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi
Remember I had a disk fail a couple of weeks back - and being a normal 
person and not a business I don't have hot spares lying about...
Well, it got back from RMA today.
And before I could plug it in, another drive got a bad block 
reallocation error.

So my RAID5 has 2 dead drives and is toasted :(
I had a few smaller disks on another machine which I lvm'ed together to 
do a backup - but I could only fit about a quarter of my data there. I'd 
*really* like not to have lost all this stuff.

However I do now have a 'good' drive.
Can I dd the newly dead drive (bear in mind it probably only has a bad 
block or two) onto the new drive and come back up in degraded mode?

Any other suggestions.

Then RMA *this* Maxtor and hope to resync in a couple of weeks (well, 
actually - these drives seem so damned unreliable I guess I'm going to 
*have* to buy a spare)

FYI these are 250Gb Maxtor SATA disks.

David

Nov 12 09:45:40 cu kernel: scsi0: ERROR on channel 0, id 0, lun 0, CDB: 
Read (10) 0
0 0d 3b 56 97 00 00 08 00
Nov 12 09:45:40 cu kernel: Current sda: sense key Medium Error
Nov 12 09:45:40 cu kernel: Additional sense: Unrecovered read error - 
auto realloca
te failed
Nov 12 09:45:40 cu kernel: end_request: I/O error, dev sda, sector 221992599
Nov 12 09:45:40 cu kernel: RAID5 conf printout:
Nov 12 09:45:40 cu kernel:  --- rd:5 wd:3 fd:2
Nov 12 09:45:40 cu kernel:  disk 0, o:0, dev:sda1
Nov 12 09:45:40 cu kernel:  disk 1, o:1, dev:sdc1
Nov 12 09:45:40 cu kernel:  disk 2, o:1, dev:sdb1
Nov 12 09:45:40 cu kernel:  disk 4, o:1, dev:hdb1
Nov 12 09:45:40 cu kernel: RAID5 conf printout:
Nov 12 09:45:40 cu kernel:  --- rd:5 wd:3 fd:2
Nov 12 09:45:40 cu kernel:  disk 1, o:1, dev:sdc1
Nov 12 09:45:40 cu kernel:  disk 2, o:1, dev:sdb1
Nov 12 09:45:40 cu kernel:  disk 4, o:1, dev:hdb1
Nov 12 09:45:41 cu kernel: lost page write due to I/O error on dm-0

