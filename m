From: "Sarcar, Shourya C (MED)" <Shourya.Sarcar@med.ge.com>
Subject: RE: RAID-5 and Chunk Size, What Filesystem to Use?
Date: Mon, 31 Mar 2003 08:44:14 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <EE1ED172E985D411A27B00508BE30A5E064ADE6F@uswaumsx11medge.med.ge.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: Jon Robertson <jonrobertson@sbcglobal.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon,

I assume that /dev/sda is not your root filesystem disk. IF it is, you
need to have RAID support compiled into the kernel or have appropriate
initrd images. Other wise, you may not be able to boot into the system
next time.

ext2 or ext3 should suffice very well for the job. I would have
reccommended xfs but kernel support for XFS is not a very straight
forward option if you are using a distro like RedHat.

Regards,
Shourya
Xtreamly yours !
Shourya Sarcar 
_____________________________________________________
Global Recon Engine, Computed Tomography
Edison Engineering Development Program, GE Medical Systems
3000 N Grandview Blvd., MS W 1200, Waukesha, WI 53188, USA
Tel: 262 312 7405 (O) | *320 7405 (DialComm)
 


> -----Original Message-----
> From: Jon Robertson [mailto:jonrobertson@sbcglobal.net]
> Sent: Sunday, March 30, 2003 9:37 PM
> To: linux-raid@vger.kernel.org
> Subject: RAID-5 and Chunk Size, What Filesystem to Use?
> 
> 
> I've been reading the Jakob Oostergard article...and it's 
> amazing how easy
> this can be, however I may have been typing too fast....
> 
> I have 3 SCSI that are 36GB each and I created my raidtab to 
> look like the
> following:
> 
> raid-level                     5
> chunk-size                   128
> persistent-superblock   1
> parity-algorithm            left-symmetric
> nr-raid-disks                3
> device                          /dev/sda
> raid-disk                    0
> device                          /dev/sda
> raid-disk                    1
> device                          /dev/sdb
> raid-disk                    2
> device                          /dev/sdc
> 
> my question is (are)
> 1. is 128 ok for the chunk size?
> 2. if it's not ok, do I just stop the raid-device and re-do 
> my raidtab file
> and then re-do my mkraid /dev/md0 command?
> 3. what filesystem do you recommend?   All I'm using this 
> server for is file
> sharing with SAMBA...
> 
> thanks in advance....
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
