From: listuser@numbnuts.net
Subject: SCSI disk error, I/O eror
Date: Sun, 18 May 2003 04:47:22 -0500 (CDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0305180408200.13419-100000@bubba.numbnuts.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Howdy.  I'm having some trouble with a hardware RAID-0 array I'm setting
up.  First let me give you some background.

The controller is a HighPoint Tech RocketRAID 404 running on a Tyan Tiger
MPX mobo with 2 x 2400MP CPUs and 1GB PC2100.  This is a RH 7.3 box and
I'm running a custom 2.4.21-rc2 on it.  I'm using two Maxtor 6Y200P0
(200GB 8MB cache 7200RPM)  drives in this array.  The controller can
handle up to 8 drives on it's 4 channels.  I have a single drive connected
to channel 1 and channel 2 with new round cables from newegg.com.  Both
drives are set as masters.

The HighPoint 374 driver in 2.4.21-rc2 (CONFIG_BLK_DEV_HPT366) didn't
allow the controller to operate as a RAID controller.  Instead it appeared
to treat it as a generic IDE controller.  Each of the two drives which I'd
already configured to be an array in the BIOS configuration utility
appeared as two seperate drives (hde and hdg).  I did (and still do) have
SCSI support compiled into the kernel.  I then gave HighPoint's own Linux 
drivers a try.

http://www.highpoint-tech.com/rr404_down.htm

Unfortunately their precompiled modules only work on the specific packaged
kernels released by a handful of vendors.  Ie, RedHat's 2.4.18-3smp was
supported but my custom 2.4.21-rc2 wasn't.  Note, I did however compile my
kernel with CONFIG_MODVERSIONS which might have prevented the module from
working.  I'll have to recompile without that in the morning and test it
out.  HighPoint also releases source to some of their modules but
unfortunately they are embarassingly old (v1.11 as compared to 2.01.  I
ended up compiling 1.11.  That allowed the array to work.  I made it into
a single large partition.  I then created and ext3 filesystem for it (no
root reserve).  To stress test the array I started filling it with data,
both from across the network via samba and from another local ATA hard
drive on an onboard IDE port.  The copy performed flawlessly, averaging
around 10-40MBps.  Not too shabby.  At around 9.5GB the copy died and the
machine dumped out large amounts of I/O errors to the screen.  The ones
below are a sample:

May 17 19:23:21 bubba kernel: hpt374: Disk failure: Controller 1 bus 1 id 
1, Maxtor 6Y200P0       err=254
May 17 19:23:21 bubba kernel: bug: kernel timer added twice at f8917978.
May 17 19:23:21 bubba samba(pam_unix)[10772]: session opened for user 
macdaddy by (uid=0)
May 17 19:23:21 bubba samba(pam_unix)[10601]: session closed for user 
macdaddy
May 17 19:23:21 bubba kernel: SCSI disk error : host 0 channel 0 id 0 lun 
0 return code = 25040000
May 17 19:23:21 bubba kernel:  I/O error: dev 08:01, sector 59754992
May 17 19:23:21 bubba kernel:  I/O error: dev 08:01, sector 59755000
May 17 19:23:21 bubba kernel:  I/O error: dev 08:01, sector 59755120
May 17 19:23:21 bubba kernel:  I/O error: dev 08:01, sector 59755248

When this happened access to the array volume came to a halt.  Umounts 
were tyically unsucessful at this point and time.  Any access attempts to 
the array died.  A reboot was the only fix.  Ususally I 
had to reformat the array at that point and time as 
well.  /proc/scsi/hpt374/0 contained some status info about the array(s) 
after they bombed out:

[listuser@bubba ~]$> cat /proc/scsi/hpt374/0 
Device Driver for HPT374 UDMA/ATA133 RAID Controller Version 1.11

Physical device list
Controller/Bus/ID  Model                Capacity  Status   Array
-------------------------------------------------------------------
1 Channel 1 Master Maxtor 6Y200P0        194480MB  Disabled JUMBO2
1 Channel 2 Master Maxtor 6Y200P0        194480MB  Normal   JUMBO2

Logical device list
No. Type         Name                 Capacity  Status
-------------------------------------------------------------------
 1  RAID 0       JUMBO2                388961MB  Disabled


Each time this happens it's always channel 1, master 1.  I never have
figured out what is device 08:01.  I first started working with these
drives Friday night.  That's when I first noticed the problem.  Saturday I
swapped the two drives around to reverse their order.  The cables didn't
follow them.  I hoped the problem would follow the drive.  Unfortunatelty
it didn't.

I haven't yet swapped the cables to see if one of them is bad.  It's 
possible.  I have extra cales to work with.  I'm going to test this 
tomorrow.  I'm also going to switch to other channels and see if they 
work.  Finally I'll stress test reach drive on the onboard IDe to make 
sure each drive works by themselves.

Can anyone think of anything that would cause this.  I did a google search
for hits on the error message and found a few hits.  Ultimately it led me
to this list.  I'd like to make the array reasonably stable before I copy
large amounts of data to it.  If anyone can think of anything I missed,
I'd love to hear it.  Thanks.

Justin

