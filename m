From: "Colin McCabe" <colin.p.mccabe@gmail.com>
Subject: unreadable drives can be synchronized?
Date: Wed, 16 May 2007 11:50:15 -0400
Message-ID: <7296208f0705160850u74d9b52en835d3c9b21f54728@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I am running software RAID on Linux 2.6.21.

While experimenting with adding and removing devices from the RAID array, I
noticed something very troubling. I have a bad drive (let's call it drive B)
which gets random read errors. I also have a good drive, call it drive A.

B can synchronize with A. But then, if I remove A from the raid array, A
cannot be re-added. This is because the bad drive, B, cannot be read from.

Basically, B appears to be "write-only"; it will never return an error on a
write, but just try to read from it, and you will be sorry.

Writing is fine:
[root@cmccabe-devel root]# dd if=/dev/zero of=/dev/sdb bs=524288
dd: writing `/dev/sdb': No space left on device
114464+0 records in
114463+0 records out

Reading is not:
[root@cmccabe-devel root]# dd if=/dev/sdb of=/dev/null bs=524288
ata1.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x2 frozen
ata1.00: cmd 60/00:00:00:b0:01/01:00:00:00:00/40 tag 0 cdb 0x0 data 131072 in
[ ... copious errors ... ]

I have disabled write caching using hdparm -W0.
Both drives are: Fujitsu MHV2060BH, 60 GB, Serial ATA
The SATA controller is: ICH6

My problem is that even though B gets into the synchronized state, it is no
good at all. This is potentially misleading, and if someone removes A after
synchronizing B, the system will probably crash, since there will be no good
drives left.

I wonder if anyone else is interested in a "paranoid recovery" mode where the
md layer tests the data that has been written. Even if this doubles the
recovery time, I think that it would be desirable for many applications.

Colin
