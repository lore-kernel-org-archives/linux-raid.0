From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Array of disks attached to multiple controllers
Date: Tue, 14 Sep 2004 10:59:52 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200409141459.i8EExv332327@watkins-home.com>
References: <4146FB2F.9080103@opf.slu.cz>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4146FB2F.9080103@opf.slu.cz>
To: 'Lukas Kubin' <kubin@opf.slu.cz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well I have a clue!
<Device size> X (<Number of disks> - 1)
195360896 X (16-1) = 2930413440 (a very nice number!)

I think you have crossed a 2T limit.
Subtract 2T from the expected size and you get you size.
2930413440 - 2^31 = 782929792  (This is your size!)

2^31 = 2T. (we have 1K blocks)

You have exceeded a 2T limit somewhere.  I don't know where the limit is.  I
thought I read that devices were limited to 2T, but arrays could be larger.
Maybe you have an older kernel that only supports 2T.  My 14 disk monster
array is just over 200Gig, so I have not had this problem.  A new kernel may
help, but I don't know.  Time for Neil to help! :)

I think you will be fine if you only use 11 disks!
195360896 * (11-1) = 1953608960 (this is under the 2T limit).

Guy

-----Original Message-----
From: Lukas Kubin [mailto:kubin@opf.slu.cz] 
Sent: Tuesday, September 14, 2004 10:08 AM
To: Guy
Cc: linux-raid@vger.kernel.org
Subject: Re: Array of disks attached to multiple controllers

Ok, the output follows:

=====

/dev/md0:
         Version : 00.90.00
   Creation Time : Tue Sep 14 16:02:42 2004
      Raid Level : raid5
      Array Size : 782929792 (746.66 GiB 801.72 GB)
     Device Size : 195360896 (186.31 GiB 200.05 GB)
    Raid Devices : 16
   Total Devices : 17
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Tue Sep 14 16:02:42 2004
           State : dirty, recovering
  Active Devices : 16
Working Devices : 17
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 128K

  Rebuild Status : 0% complete

     Number   Major   Minor   RaidDevice State
        0       8       16        0      active sync   /dev/sdb
        1       8       32        1      active sync   /dev/sdc
        2       8       48        2      active sync   /dev/sdd
        3       8       64        3      active sync   /dev/sde
        4       8       80        4      active sync   /dev/sdf
        5       8       96        5      active sync   /dev/sdg
        6       8      112        6      active sync   /dev/sdh
        7       8      128        7      active sync   /dev/sdi
        8       8      144        8      active sync   /dev/sdj
        9       8      160        9      active sync   /dev/sdk
       10       8      176       10      active sync   /dev/sdl
       11       8      192       11      active sync   /dev/sdm
       12       8      208       12      active sync   /dev/sdn
       13       8      224       13      active sync   /dev/sdo
       14       8      240       14      active sync   /dev/sdp
       15      65        0       15      active sync   /dev/sdq
       16      65       16       16      spare   /dev/sdr
            UUID : c18d1ba9:d7d4f338:6d83a4e1:023cbbdb
          Events : 0.1

=====

All the disks are SATA 200GB, the first controller (for drives sd{a..f}) 
is 3ware 8xxx, the second is 3ware 9000 ATA Raid controller. The first 
controller uses 3w-xxxx kernel module, the second one 3x-9xxx on linux 
2.4.27.

Thank you for any help.

lukas

Guy wrote:
> Give us more info.
> Output from mdadm -D /dev/md?
> 
> Guy
> 
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Lukas Kubin
> Sent: Tuesday, September 14, 2004 9:22 AM
> To: linux-raid@vger.kernel.org
> Subject: Array of disks attached to multiple controllers
> 
> I'm having troubles creating Raid-5 array consisted of 16 (+1 spare) 
> disks attached to two 3ware (not same version) SATA controllers.
> 
> Mkraid creates the array without problems, however the array's total 
> size only equals the sum of space on drives attached to the first of 2 
> controllers. Ie, sd{b..f} are on scsi0 and sd{g..r} on scsi1. The space 
> of created array is close to the sum of drives attechted to scsi0 only.
> 
> Is it possible to combine drives on 2 controllers into one array? If 
> not, what solution should I use to have one filesystem containing whole 
> the drivespace on Raid-5?
> 
> Thank you.
> 
> lukas
> 

-- 
Lukas Kubin

phone: +420596398275
email: kubin@opf.slu.cz

Information centre
The School of Business Administration in Karvina
Silesian University in Opava
Czech Republic
http://www.opf.slu.cz

