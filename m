From: "Mark Cuss" <mcuss@cdlsystems.com>
Subject: write_disk_sb failed
Date: Tue, 14 Jun 2005 13:46:34 -0600
Message-ID: <015401c57119$c55db120$ab0e10ac@pinchy>
Reply-To: "Mark Cuss" <mcuss@cdlsystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello List

I have a RH 9 system (kernel 2.4.27 vanilla) running a Dell SCSI disk array 
(JBOD) with a bunch of SW RAID5 devices...  lately, I've been having a lot 
of problems with disks dropping from the RAID devices.  I've replaced these 
disks (via the usual SCSI cat > /proc/scsi/scsi and a 
raidhotremove/raidhotadd )  These devices get added OK and the RAID recovery 
goes through, but the next morning the RAIDs have bad devices again...  I've 
done this a few times during the week and doubt that all of these disks are 
bad...

Today, the system is complaining about sdq.  The kernel log is full of 
messages like:
Jun 14 09:02:50 hal kernel: md: updating md4 RAID superblock on device
Jun 14 09:02:50 hal kernel: md: sdq1 [events: 0000002f]<6>(write) sdq1's sb 
offset: 430108096
Jun 14 09:02:50 hal kernel:  I/O error: dev 41:01, sector 860216192
Jun 14 09:02:50 hal kernel: md: write_disk_sb failed for device sdq1
Jun 14 09:02:50 hal kernel: md: sdm1 [events: 0000002f]<6>(write) sdm1's sb 
offset: 143371968
Jun 14 09:02:50 hal kernel: md: sdl1 [events: 0000002f]<6>(write) sdl1's sb 
offset: 143371968
Jun 14 09:02:50 hal kernel: md: sdk1 [events: 0000002f]<6>(write) sdk1's sb 
offset: 143371968
Jun 14 09:02:50 hal kernel: md: errors occurred during superblock update, 
repeating

The system is cranky about sdq:
[root@hal dev]# mdadm --examine /dev/sdq1
mdadm: Cannot read superblock on /dev/sdq1

However, the RAID device containing sdq is still up and running (for now, 
anyways):
md4 : active raid5 sdq1[0] sdm1[3] sdl1[2] sdk1[1]
      430115904 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

All signs would point to the fact that sdq is a dead drive, but this has 
happened 2 or 3 times this week with a few fairly new drives, so I don't 
think they're all bad.  Can anyone shed any wisdom as to why this may be 
happening?  This system has been running for about 18 months and hasn't had 
a lot of problems - maybe 2 or 3 drives have quit.  The stupid Dell disk 
array sometimes kicks out disks when they're not bad, so it may be at fault 
in this case...  Can anyone offer any ideas as to how to troubleshoot?

Related to troubleshooting:  Over the past few days, SCSI devices have been 
removed and added and the SCSI disk lettering is all jumbled around...  Now, 
when I see that sdX fails in the log, I can no longer figure out which 
physical disk or which SCSI ID that sdX corresponds to.  Originally, I'd 
just count down the disk array until I arrived at the right letter, and the 
SCSI ID is marked on the array.  Now I can't do that, as the letters are 
jumbled around a little.  Is there a trick or technique to determine which 
SCSI ID that sdX corresponds to?

Thanks in advance,
Mark





Mark Cuss, B. Sc.
Real Time Systems Analyst
System Administrator
CDL Systems Ltd
Suite 230
3553 - 31 Street NW
Calgary, AB, Canada

Phone: 403 289 1733 ext 226
Fax: 403 289 3967
www.cdlsystems.com 


