From: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Subject: RE: 3ware bad write speed.
Date: Sat, 22 Mar 2003 18:34:53 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <8075D5C3061B9441944E137377645118012EA7@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Donghui Wen <dhwen@protegonetworks.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> -----Original Message-----
>> From: Donghui Wen [mailto:dhwen@protegonetworks.com] 
>> Sent: Saturday, March 22, 2003 4:37 PM
>> To: Rechenberg, Andrew; linux-raid@vger.kernel.org
>> Subject: Re: 3ware bad write speed.
>> 
>> 
>> Thanks, Andrew:
>>     What ATA RAID controllers are you using? Do you have any 
>> benchmark data
>> about sequential write?
>> 
>> Donghui 

We're actually using SCSI disks attached to Adaptec 39160 SCSI
controllers.  I then have a monster /etc/raidtab to setup the software
RAID arrays and I use mdadm to monitor the arrays for failed disks.  We
used to use the Dell PERC3/QC (OEM LSI MegaRAID Enterprise 1600) for
hardware RAID controllers but in basic tests we could get almost 50%
better performance from software RAID.

If you want (or have) to use ATA controllers for monetary reasons I'm
not really the person to ask :)  I have a Promise Ultra100TX2 in my home
workstation that works great for my home use, but I have not tested
these cards in a production environment.

I can't recall off-hand what the sequential writes were from tiobench,
but here are some bonnie++ numbers for that 52 SCSI disk array with an
8GB file:

Seq. Output (writing)                         
Per Char     Block        Rewrite
K/sec %CPU   K/sec %CPU   K/sec  %CPU
----------------------------------------
23719  99    129707 99    99141   54

Seq. Input  (reading)
Per Char     Block      
K/sec %CPU   K/sec %CPU 
-------------------------
27551  98    301288 63


So with one bonnie++ thread I was getting ~127MB/s sequential writes and
~294MB/s sequential reads.  I ran two other tests with the same
parameters and the averages over three tests were 128.8MB/s reads and
296.7MB/s reads.  The details for these numbers are below:

Red Hat Linux 7.3
Kernel 2.4.18-26.7.xbigmem with md-seq_file and LVM 1.0.7 patches
applied
Dell PowerEdge 4600 
2x2.4GHz Xeon with HT
4GB RAM
52 15K SCSI disks with equal 17GB partitions
1 RAID10 software RAID array (~442GB usable space)
1 Linux Logical Volume Manager (LVM) Volume Group (VG) on top of the MD
device
1 300GB Logical Volume (LV) carved out of the 442GB VG
ext3 filesystem on LV (mke2fs -j /dev/vg00/lv00) mounted data=ordered

The other portion of the LV was used to test LV snapshots.

Let me know if you have any other questions.

Thanks,
Andy.
