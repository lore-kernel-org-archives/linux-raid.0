From: TJ <systemloc@earthlink.net>
Subject: Looking for the cause of poor I/O performance
Date: Thu, 2 Dec 2004 11:38:17 -0500
Message-ID: <200412021138.17311.systemloc@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

	I'm getting horrible performance on my samba server, and I am
unsure of the cause after reading, benchmarking, and tuning.
	My server is a K6-500 with 43MB of RAM, standard x86 hardware. The
OS is Slackware 10.0 w/ 2.6.7 kernel I've had similar problems with the
 2.4.26 kernel. I've listed my partitions below, as well as the drive models. 
I have a linear RAID array as a single element of a RAID 5 array. The RAID 5 
array is the array containing the fs being served by samba. I'm sure having 
one raid array built on another affects my I/O performance, as well as having 
root, swap, and a slice of that array all on one drive, however, I have taken 
this into account and still am unable to account for my machine's poor 
performance. All drives are on their own IDE channel, no master slave combos, 
as suggested in the RAID howto.

To tune these drives, I use:
hdparm -c3 -d1 -m16 -X68 -k1 -A1 -a128 -M128 -u1 /dev/hd[kigca]

I have tried different values for -a. I use 128, because this corresponds
closely with the 64k stripe of the raid 5 array. I ran hdparm -Tt on each
individual drive as well as both of the raid arrays and included these
numbers below. The numbers I got were pretty low for modern drives. 

In my dmesg, I'm seeing something strange.. I think this is determined by
kernel internals. It seems strange and problematic to me. I believe this
number is controller dependant, so I'm wondering if I have a controller issue
here...

hda: max request size: 128KiB
hdc: max request size: 1024KiB
hdg: max request size: 64KiB
hdi: max request size: 128KiB
hdk: max request size: 1024KiB


	I believe my hard drives are somehow not tuned properly due to the low hdparm 
numbers, especially hda and hdc. This is causing the raid array to perform 
poorly, in dbench and hdparm -tT. The fact that two drives on the same IDE 
controller are performing worse than the group, hda and hdc, further indicate 
that there may be a controller problem. I may try eliminating this controller 
and checking the results again.
	Also, I know that VIA chipsets, such as this MVP3, are known for poor PCI 
performance. I know that this is tweakable, and several programs exist for 
tweaking BIOS registers within Windows. How might I test the PCI bus to see 
if it is causing performance problems?

	Does anyone have any ideas on how to better tune these drives for more 
throughput?

My partitions are:

/dev/hda1 on /
/dev/hda2 is swap
/dev/hda3 is part of /dev/md0
/dev/hdi  is part of /dev/md0
/dev/hdk  is part of /dev/md0
/dev/md0  is a linear array. It is part of /dev/md1
/dev/hdg  is part of /dev/md1
/dev/hdc  is part of /dev/md1
/dev/md1  is a raid 5 array.

hda: WD 400JB  40GB
hdc: WD 2000JB 200GB
hdg: WD 2000JB 200GB
hdi: IBM 75 GXP  120GB
hdk: WD 1200JB 120GB

Controllers:
hda-c: Onboard controller, VIA VT82C596B (rev 12)
hdd-g: Silicon Image SiI 680 (rev 1)
hdh-k: Promise PDC 20269 (rev 2)

The results from hdparm -tT for each individual drive and each raid array
are:

/dev/hda:
 Timing buffer-cache reads:   212 MB in  2.02 seconds = 105.17 MB/sec
 Timing buffered disk reads:   42 MB in  3.07 seconds =  13.67 MB/sec
/dev/hdc:
 Timing buffer-cache reads:   212 MB in  2.00 seconds = 105.80 MB/sec
 Timing buffered disk reads:   44 MB in  3.12 seconds =  14.10 MB/sec
/dev/hdg:
 Timing buffer-cache reads:   212 MB in  2.02 seconds = 105.12 MB/sec
 Timing buffered disk reads:   68 MB in  3.04 seconds =  22.38 MB/sec
/dev/hdi:
 Timing buffer-cache reads:   216 MB in  2.04 seconds = 106.05 MB/sec
 Timing buffered disk reads:   72 MB in  3.06 seconds =  23.53 MB/sec
/dev/hdk:
 Timing buffer-cache reads:   212 MB in  2.01 seconds = 105.33 MB/sec
 Timing buffered disk reads:   66 MB in  3.05 seconds =  21.66 MB/sec
/dev/md0:
 Timing buffer-cache reads:   212 MB in  2.01 seconds = 105.28 MB/sec
 Timing buffered disk reads:   70 MB in  3.07 seconds =  22.77 MB/sec
/dev/md1:
 Timing buffer-cache reads:   212 MB in  2.03 seconds = 104.35 MB/sec
 Timing buffered disk reads:   50 MB in  3.03 seconds =  16.51 MB/sec

The results from dbench 1 are: Throughput 19.0968 MB/sec 1 procs
The results from tbench 1 are: Throughput 4.41996 MB/sec 1 procs

I would appriciate any thoughts, leads, ideas, anything at all to point me in
a direction here.

Thanks,
TJ Harrell
