From: "Mark Cuss" <mcuss@cdlsystems.com>
Subject: How to force a spare drive to take over in a RAID5?
Date: Fri, 5 Aug 2005 08:31:47 -0600
Message-ID: <006301c599ca$69410700$ab0e10ac@pinchy>
References: <45138.213.188.237.106.1123086677.squirrel@localhost><20050804195853.0866ade9.akpm@osdl.org><34082.213.188.237.106.1123228569.squirrel@localhost> <20050805010236.12d811ff.akpm@osdl.org>
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

Hi!

I have a 4 drive SW RAID5 running on my machine.  One of the drives is upset 
for some reason - I'm not sure if the drive itself is bad, but that's not 
too important right now.  The important thing is to get the RAID5 to stop 
using this drive and start using a spare drive that I just added.

The current raid status is:
[root@hal cdl]# lsraid -a /dev/md4
lsraid: Unable to read raid superblock from device "/dev/sdr1": Input/output 
error
lsraid: Device "/dev/sdr1" does not have a valid raid superblock
lsraid: Unable to read raid superblock from device "/dev/sdr1": Input/output 
error
lsraid: Device "/dev/sdr1" does not have a valid raid superblock
lsraid: Unable to read raid superblock from device "/dev/sdr1": Input/output 
error
lsraid: Device "/dev/sdr1" does not have a valid raid superblock
lsraid: Unable to read raid superblock from device "/dev/sdr1": Input/output 
error
lsraid: Device "/dev/sdr1" does not have a valid raid superblock
lsraid: Unable to read raid superblock from device "/dev/sdr1": Input/output 
error
lsraid: Device "/dev/sdr1" does not have a valid raid superblock
[dev   9,   4] /dev/md4         24989439.D4F0D908.67494E4A.97B3BA91 online
[dev   ?,   ?] (unknown)        00000000.00000000.00000000.00000000 missing
[dev   8,  161] /dev/sdk1        24989439.D4F0D908.67494E4A.97B3BA91 good
[dev   8,  177] /dev/sdl1        24989439.D4F0D908.67494E4A.97B3BA91 good
[dev   8,  193] /dev/sdm1        24989439.D4F0D908.67494E4A.97B3BA91 good
[dev  65,  33] /dev/sds1        24989439.D4F0D908.67494E4A.97B3BA91 spare

[root@hal cdl]#

Clearly, sdr is unhappy.  However, /proc/mdstat says that all the drives are 
online:
md4 : active raid5 sds1[4] sdr1[0] sdm1[3] sdl1[2] sdk1[1]
      430115904 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

I did a raidhotadd to add in a new drive, sds.  Now, I would like the array 
to stop using sdr and reconstruct all of the parity tables on sds so I can 
pull sdr and get it replaced or whatever...

Any ideas?

Thanks
Mark


