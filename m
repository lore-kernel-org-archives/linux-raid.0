From: linuxraid@valli.org
Subject: Which controller is recommended for a hardware-raid
Date: Fri, 28 Nov 2003 19:16:34 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <35566.194.153.178.110.1070043394.squirrel@mail.valli.org>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,
After painful experiences with some raid-controllers, namely
   - Adaptec AIC-7902 in the HostRAID (RAID 1) configuration
     (After 9 hours trying, searching compiling, I found this
      http://mbserver.adaptec.com/view.php?bn=linux_scsi&key=1064363305&pattern=AIC-7902+hostraid
      It's a shame!)
   - FastTrak 100 (RAID 1 configuration)
     (I was forced to use either SuSE or Red Hat, download a driver, and
taint the kernel)
So I don't want to make the same mistakes (first buy, then try) again.

I expect of linux-raid-controller that,
 - the driver is opensource, means that I can use it in every linux kernel
   (also debian, gentoo, ...) without tainting the kernel
   (better would be that the driver is already part of the kernel)
 - I can receive status-information about the RAID (e.g. via /proc/.... or
   a daemon); I'll make script which sends an email to the sysadmin if
   a disk crashed
 - the raid still works, even if a disk crashed (this should be self-evident)
   without writing megabytes in /var/log/messages

I would really be appreciate any information to the following:
IDE-hardware-RAID1:
 - Which controller do you recommend (is it still available)?
 - Which driver should I use? (how to install it)
 - How and where can I find status information?
 - what about performance?
IDE-hardware-RAID5:
 - Which controller do you recommend (is it still available)?
 - Which driver should I use? (how to install it)
 - How and where can I find status information?
 - what about performance?
SCSI-hardware-RAID1:
 - Which controller do you recommend (is it still available)?
 - Which driver should I use? (how to install it)
 - How and where can I find status information?
 - what about performance?
SCSI-hardware-RAID5:
 - Which controller do you recommend (is it still available)?
 - Which driver should I use? (how to install it)
 - How and where can I find status information?
 - what about performance?

What about the following hardware:
 (found in: http://tldp.org/HOWTO/Hardware-HOWTO/raid.html)
 - Mylex RAID controllers
 (found in: http://tldp.org/HOWTO/Hardware-HOWTO/ideraid.html)
 - 3ware Escalade IDE RAID controllers
 - Promise SuperTRAK SX6000
 - Adaptec ATA RAID 2400A
 - ARCO Inc. DupliDisk IDE disk mirroring controller
 - Tekram D690CD IDE PCI Cache Controller

Thanks a lot for your answers
valli

