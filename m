From: Harry Mangalam <harry.mangalam@uci.edu>
Subject: can mdadm use /dev/sgX as devices?
Date: Sat, 9 Oct 2010 18:22:32 -0700
Message-ID: <201010091822.33148.harry.mangalam@uci.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

the short version:
  Can mdadm use /dev/sgX as devices?
  (and if so, how?)

the longer version is:

I inherited a 6-bay IBM x3655  with a ServeRAID-8k RAID controller 
(from docs, it seems to be an 8-port Adaptec 9580W SAS/SATA 
controller). I'd like to run Ubuntu 10.04. 

I can use the controller BIOS on boot to config and set up a RAID5 
(which presents to the OS as '/dev/sda' - the 'very large device'. 
However there's no way to add notification of disk failure.  There are 
some GUI Java-based packages which claim to be able to do this (a 
32bit Java RaidManager (RaidMan), which seems to be a re-badged 
Adaptec StorageManager (StorMan - also available in a true 64bit 
version) which I've managed to get running but they both lock up in 
various ugly and opaque ways.  

Along with the Java GUI apps is an Adaptec commandline app called 
'arcconf' that allows you to peek at the controller and does allow a 
primitive amount of control (but not email notification of disk 
failure).

I'd prefer to use mdadm since it's simpler and mostly 'just works and 
does email notifications. However, the controller does not translate 
the /dev/sgX addresses to the /dev/sdX devices that mdadm seems to 
want.

- lspci says:
  05:00.0 RAID bus controller: Adaptec AAC-RAID (Rocket) (rev 02)

- The boot process does not load the aacraid driver, but it can be 
modprobed manually.  This doesn't change much tho:

# lsmod |grep aacraid
aacraid                76291  0 


- dmesg shows:
[    3.394749] scsi 0:1:0:0: Attached scsi generic sg1 type 0
[    3.394877] scsi 0:1:1:0: Attached scsi generic sg2 type 0
[    3.394981] scsi 0:1:2:0: Attached scsi generic sg3 type 0
[    3.395085] scsi 0:1:3:0: Attached scsi generic sg4 type 0
[    3.395190] scsi 0:1:4:0: Attached scsi generic sg5 type 0
[    3.395296] scsi 0:1:5:0: Attached scsi generic sg6 type 0
[    3.395427] scsi 0:3:0:0: Attached scsi generic sg7 type 13 
(The last is the controller)

- # sg_scan shows
/dev/sg0: scsi1 channel=0 id=0 lun=0 [em]
/dev/sg1: scsi0 channel=1 id=0 lun=0 [em]
/dev/sg2: scsi0 channel=1 id=1 lun=0 [em]
/dev/sg3: scsi0 channel=1 id=2 lun=0 [em]
/dev/sg4: scsi0 channel=1 id=3 lun=0 [em]
/dev/sg5: scsi0 channel=1 id=4 lun=0 [em]
/dev/sg6: scsi0 channel=1 id=5 lun=0 [em]
/dev/sg7: scsi0 channel=3 id=0 lun=0 [em]
/dev/sg8: scsi2 channel=0 id=0 lun=0 [em]
/dev/sg9: scsi7 channel=0 id=0 lun=0 [em]

# sg_map
/dev/sg0  /dev/scd0 <- cdrom
/dev/sg1     < no /dev/sdX mapping 
/dev/sg2
/dev/sg3
/dev/sg4
/dev/sg5
/dev/sg6
/dev/sg7           <- controller
/dev/sg8  /dev/sda <- broadcom severworks SATA disk
/dev/sg9  /dev/sdb <- USB thumbdrive

-- 
Harry Mangalam - Research Computing, NACS, Rm 225 MSTB, UC Irvine
[ZOT 2225] / 92697  949 824-0084(o), 949 285-4487(c)
MSTB=Bldg 415 (G-5 on <http://today.uci.edu/pdf/UCI_09_map_campus.pdf>
--
Non-sarcarstic use of 'seamless' in any context having to do with 
computers immediately disqualifies the speaker as an expert.
