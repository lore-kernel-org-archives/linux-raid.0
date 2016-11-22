From: "theelectricengineer@gmail.com" <theelectricengineer@gmail.com>
Subject: Re:Please help RAID1 complete fail no superblock
Date: Tue, 22 Nov 2016 20:38:20 +0000
Message-ID: <869594.583611132-sendEmail@optimum>
Mime-Version: 1.0
Content-Type: multipart/related; boundary="----MIME delimiter for sendEmail-574363.299719156"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "philip@turmel.org" <philip@turmel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "antlists@youngman.org.uk" <antlists@youngman.org.uk>, "george.rapp@gmail.com" <george.rapp@gmail.com>
List-Id: linux-raid.ids

This is a multi-part message in MIME format. To properly display this message you need a MIME-Version 1.0 compliant Email program.

------MIME delimiter for sendEmail-574363.299719156
Content-Type: text/plain;
        charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Hi Yaniv,
> 
> { Convention on kernel.org is to reply-to-all, trim quotes, and either
> reply at the bottom or interleaved with the questions.  CC list
> repaired. And please don't break threading. }
> 
> On 11/22/2016 11:24 AM, theelectricengineer@gmail.com wrote:
> 
> >>> One more piece of information that would be helpful is the partition
> >>> tables for each drive:
> >>>
> >>> # fdisk -l /dev/sdb /dev/sdc
> 
> Per the warnings in the output, fdisk is not appropriate for your
> drives.  You must use gdisk or parted:
> 
> gdisk -l /dev/sdb
> gdisk -l /dev/sdc
> 
> parted /dev/sdb print
> parted /dev/sdc print
> 
> Phil

Thank you for informing me about the conventions,
I'll try to conform to all of them.
(what does trim quotes mean?)
I tried sending these emails through gmail and Thunderbird
but kept getting an automatic reply saying that the emails were blocked,
so I'm sending this via the command line (linux terminal).
I don't know how to avoid breaking the thread this way.

I ran both gdisk and parted, here is the output:

gdisk -l /dev/sdb
GPT fdisk (gdisk) version 0.8.5

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/sdb: 5860533168 sectors, 2.7 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): 3DE466AD-A3E5-4258-93E8-6DCF186E851D
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 5860533134
Partitions will be aligned on 2048-sector boundaries
Total free space is 2925 sectors (1.4 MiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048      5860532223   2.7 TiB     0700 

gdisk -l /dev/sdc
GPT fdisk (gdisk) version 0.8.5

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/sdc: 5860533168 sectors, 2.7 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): 88439314-5789-4E07-B7D5-775D6D5D98C1
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 5860533134
Partitions will be aligned on 2048-sector boundaries
Total free space is 5860533101 sectors (2.7 TiB)

Number  Start (sector)    End (sector)  Size       Code  Name


parted /dev/sdb print
Model: ATA WDC WD30EZRX-00D (scsi)
Disk /dev/sdb: 3001GB
Sector size (logical/physical): 512B/4096B
Partition Table: gpt

Number  Start   End     Size    File system  Name  Flags
 1      1049kB  3001GB  3001GB  ext4


parted /dev/sdc print
Model: ATA WDC WD30EZRX-00D (scsi)
Disk /dev/sdc: 3001GB
Sector size (logical/physical): 512B/4096B
Partition Table: gpt

Number  Start  End  Size  File system  Name  Flags

(there are no values for sdc in both gdisk and parted, looks bad)

I greatly appreciate your help.

Thank you,

Yaniv 


------MIME delimiter for sendEmail-574363.299719156--

