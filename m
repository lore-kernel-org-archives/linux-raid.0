From: "Theepan" <tornado@linuxfromscratch.org>
Subject: IDE Performance issues
Date: Mon, 1 Sep 2003 23:12:49 +0200
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <001301c370cd$cd46ed50$0200a8c0@tornado>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Hi there,

I have a RAID5 setup with 4 x 120GB IDE disks and I have always wondered why
the performance of my RAID set never exceeded 60-66MB/s when a lot of people
talk about their RAID setup sustaining 80-100MB/s (and then some more).

Until recently I've just blamed the overhead that software RAID brings,
namely because it is software and takes up CPU cycles and I don't have the
fastest processors in the world. After a lot of tests, I found out that
RAID5 is not to blame but the IDE/PCI layer on the other hand is.

zcav, a tool from bonnie++ package, was used to measure the sequential read
rate. All disks were able to sustain minimum 30MB/s when accessed
seperately. When accessed simultaneously I get these results:

When accessing 1 disk, the read rate was 30MB/s (as expected).
When accessing 2 disks, the read rate was 60MB/s (30MB/s on each disk, as
expected)
When accessing 3 disks, the read rate was 60MB/s (20MB/s on each disk,
dropping 10Mb/s)
When accessing 4 disks, the read rate was 60MB/s (15MB/s on each disk,
dropping 15Mb/s)

When accessing md1 (RAID5 with 4 disks), the read rate was 55-63MB/s.

A quick look at the results show that the maximum performance achived was
60MB/s no matter how many disks (2+) were involved - the same performance
you could/would expect from a ATA66 system. On a 32bit system where the PCI
bus operates as 33mhz, one would expect the maximum theoretical throughput
to be 133MB/s (or 127,x MB/s).

I have 2 x Promise TX2 ATA133 Controller and 4 Maxtor 120GB disks (3 x
5400RPM and 1 x 7200RPM, all disks are ATA133 capable and operate in this
mode according to hdparm). DMA and 32bit is enabled on the disks using
hdparm
as well. The disks are attached as master only, that is one disk per IDE
channel.

The system is a Dual P3-500mhz wih 256MB RAM.
The motherboard is SOYO SY-D6IBA with 440BX chipset.
I'm running Debian Linux and kernel 2.4.22 (vanilla kernel with only
lm_sensors and i2c patched).
The RAID5 consists of 4 disks with 128KB as chunk-size.
The onboard SCSI is disabled as I have no use of it.


LILO has "ide2=ata66 ide3=ata66 ide4=ata66 ide5=ata66" appended, becase I've
read that this instructs the kernel to use some ATA66+ calls and thereby
utilizing the ATA66 (and higher).

Anyone have any idea what this is about (maybe by first hand experience) and
why? - and preferably also how I would go about "fixing" it.


If there's need for output from lcpci, dmesg etc, let me know - I have them
ready. I do not know if these lists prefer outputs attached or included as
body in the email - which is why I didn't include them at all in any way.


--
Theepan


