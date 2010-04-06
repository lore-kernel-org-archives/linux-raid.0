From: Olaf Zevenboom <olaf@artefact.nl>
Subject: q: RAID1 with very unbalanced disk performance
Date: Tue, 06 Apr 2010 17:28:03 +0200
Message-ID: <4BBB5303.1090001@artefact.nl>
Reply-To: olaf@artefact.nl
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear List,

We have a setup with two SATA2 1.5 TB harddisks in MD/LVM2 RAID1 setup 
on Debian Lenny stock kernel.
As it is suffering from performance troubles I did take a closer look 
and noticed that /dev/sda is way more intensively used than /dev/sdb. I 
monitored the drives with various tools including atop.
/dev/sda is always a bit busier than /dev/sdb. This behavior can also be 
seen on other systems with a similar setup (Etch and Lenny), but on this 
particular system /dev/sda is about 10% more intensively used. Although 
I think that is quite a lot and not as it should be I can live with 
that. What worries me more is that /dev/sda can peek upto 100% 
disk-utilization causing the system to be temporary unresponsive whilest 
/dev/sdb does not seem to peek over 20% or so.
Any pointers on what is happening here and/or how I can resolve this 
issue are quite welcome.

Thanking you in advance,
Olaf Zevenboom

Details:

Running Debian Lenny with stock kernel 2.6.26-2-amd64 #1 SMP
LVM2 on top of MD

2 SATA2 1.5tb disks: lsscsi
[0:0:0:0]    disk    ATA      WDC WD15EARS-00Z 80.0  /dev/sda
[1:0:0:0]    disk    ATA      ST31500541AS     CC32  /dev/sdb

cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 sda2[0] sdb2[1]
      1464886912 blocks [2/2] [UU]
     
md0 : active raid1 sda1[0] sdb1[1]
      248896 blocks [2/2] [UU]
     
unused devices: <none>

hdparm -tT /dev/sda

/dev/sda:
 Timing cached reads:   2890 MB in  2.00 seconds = 1445.36 MB/sec
 Timing buffered disk reads:  300 MB in  3.01 seconds =  99.67 MB/sec

hdparm -tT /dev/sdb

/dev/sdb:
 Timing cached reads:   7482 MB in  2.00 seconds = 3743.83 MB/sec
 Timing buffered disk reads:  302 MB in  3.02 seconds = 100.00 MB/sec


