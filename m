From: Max Waterman <davidmaxwaterman@fastmail.co.uk>
Subject: shuffled disks by mistake
Date: Thu, 10 Mar 2005 22:17:21 +0800
Message-ID: <423056F1.2020403@fastmail.co.uk>
Reply-To: mwaterman@jingmei.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have 6 WD800Jb disk drives. I used 4 of them in a RAID5 (using the 
whole disk - no partitions) array.

I have mixed them all up, and now want to get some data off the array.

How best to find out which drives were in the array?

Here are the partition tables (obtained using fdisk on OS X):

WCAHL6712963.txt
Disk: /dev/rdisk2       geometry: 9729/255/63 [156301488 sectors]
Signature: 0x0
          Starting       Ending
  #: id  cyl  hd sec -  cyl  hd sec [     start -       size]
------------------------------------------------------------------------
  1: 00    0   0   0 -    0   0   0 [         0 -          0] unused
  2: 00    0   0   0 -    0   0   0 [         0 -          0] unused
  3: 00    0   0   0 -    0   0   0 [         0 -          0] unused
  4: 00    0   0   0 -    0   0   0 [         0 -          0] unused

WCAHL6713265.txt
Disk: /dev/rdisk2       geometry: 9729/255/63 [156301488 sectors]
Signature: 0x6972
          Starting       Ending
  #: id  cyl  hd sec -  cyl  hd sec [     start -       size]
------------------------------------------------------------------------
  1: 00    0   0   0 -    0   0   0 [         0 -          0] unused
  2: 69 1023  53  45 - -108478 -118  -1 [1210083443 - 1342177348] Novell 

  3: 00    0   0   0 -    0   0   0 [         0 -          0] unused
  4: 00    0   0   0 -    0   0   0 [         0 -          0] unused

WCAHL6727415.txt
Disk: /dev/rdisk2       geometry: 9729/255/63 [156301488 sectors]
Signature: 0x0
          Starting       Ending
  #: id  cyl  hd sec -  cyl  hd sec [     start -       size]
------------------------------------------------------------------------
  1: 00    0   0   0 -    0   0   0 [         0 -          0] unused
  2: 00    0   0   0 -    0   0   0 [         0 -          0] unused
  3: 00    0   0   0 -    0   0   0 [         0 -          0] unused
  4: 00    0   0   0 -    0   0   0 [         0 -          0] unused

WCAHL6731043.txt
Disk: /dev/rdisk2       geometry: 9729/255/63 [156301488 sectors]
Signature: 0x6972
          Starting       Ending
  #: id  cyl  hd sec -  cyl  hd sec [     start -       size]
------------------------------------------------------------------------
  1: 00    0   0   0 -    0   0   0 [         0 -          0] unused
  2: 69 1023  53  45 - -108478 -118  -1 [1210083443 - 1342177348] Novell 

  3: 00    0   0   0 -    0   0   0 [         0 -          0] unused
  4: 00    0   0   0 -    0   0   0 [         0 -          0] unused

WCAJ93156707.txt
Disk: /dev/rdisk2       geometry: 9729/255/63 [156301488 sectors]
Signature: 0xAA55
          Starting       Ending
  #: id  cyl  hd sec -  cyl  hd sec [     start -       size]
------------------------------------------------------------------------
*1: 83    0   1   1 -   12 254  63 [        63 -     208782] Linux files*
  2: 8E   13   0   1 - 1023 254  63 [    208845 -  156087540] <Unknown ID>
  3: 00    0   0   0 -    0   0   0 [         0 -          0] unused
  4: 00    0   0   0 -    0   0   0 [         0 -          0] unused

WMA8E2951092.txt
Disk: /dev/rdisk2       geometry: 9729/255/63 [156301488 sectors]
Signature: 0x0
          Starting       Ending
  #: id  cyl  hd sec -  cyl  hd sec [     start -       size]
------------------------------------------------------------------------
  1: 00    0   0   0 -    0   0   0 [         0 -          0] unused
  2: 00    0   0   0 -    0   0   0 [         0 -          0] unused
  3: 00    0   0   0 -    0   0   0 [         0 -          0] unused
  4: 00    0   0   0 -    0   0   0 [         0 -          0] unused

Max.
