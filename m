From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: md confused by changing device names?
Date: Fri, 8 Oct 2004 08:55:04 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16741.51528.247736.520728@cse.unsw.edu.au>
References: <16ADEDFA-1898-11D9-B27F-00039363AEBE@bitart.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Gerd Knops on Thursday October 7
To: gerti-raid@bitart.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday October 7, gerti@bitart.com wrote:
> Hi,
> 
> I am testing failures in an md RAID5 scenario, and I am stuck.
> 
> Situation: 3 SATA disks with 1 partition, sda1, sdb1 and sdc1 are used 
> to create a RAID5 array.
> 
> Now I restart the system with the 'middle' disk powered down. md starts 
> the RAID in degraded mode and works fine, but the system now renamed 
> the partition previously known as sdc1 to sdb1.
> 
> I restart, with power to the 'middle' drive restored. The 'middle' 
> drive re-asumes its original name sdb1, and the other disk moves back 
> to sdc1.
> 
> Now when md starts it accepts sda1, kicks off sdb1 as outdated, and 
> never seems to even look at sdc1. Hence it will not start the array.

Let me guess:  You are using "raidstart" to start the array.
Don't.  It doesn't work.
Use "mdadm".  It does.

NeilBrown

> 
> Looking at the superblocks with lsraid sda1 and sdb1 show a state of 
> 'good', sdc1's state is unknown. However the 'last updated' dates on 
> sda1 and sdc1 match, so at least in theory the RAID should be able to 
> start up with those 2 partitions. (see below for superblock listing, it 
> uses aliased device names which did not help though).
> 
> Am I correct to assume that md stored the fact that it ran in degraded 
> mode using sda1 and sdb1 (whiich really was sdc1), and hence it never 
> looks at sdc1 again (other than to apparently set the state to 
> 'unknown')?
> 
> I attempted to work around the renaming issues using scsidev and 
> 'fixed' device names, but apparently somehow md discovers the original 
> names and works with those at some levels.
> 
> Any suggestions? And is there a way to mark the superblock of the 3rd 
> drive as 'good' so that md considers it and will start up?
> 
> BTW: Linux xanadu2 2.6.8-1-386 #1 Mon Sep 13 23:29:55 EDT 2004 i686 
> GNU/Linux
> 
> Thanks much
> 
> Gerd
> 
> 
> xanadu2:~# lsraid -D -d /dev/scsi/cd_1_3-p1 -d /dev/scsi/cd_2_3-p1 -d 
> /dev/scsi/cd_3_3-p1 -l
> [dev 8, 1] /dev/scsi/cd_1_3-p1:
>          md version              = 0.90.0
>          superblock uuid         = 0F4274E7.6F390D6E.6521DD63.654D0072
>          md minor number         = 0
>          created                 = 1097103636 (Wed Oct  6 18:00:36 2004)
>          last updated            = 1097103991 (Wed Oct  6 18:06:31 2004)
>          raid level              = 5
>          chunk size              = 256 KB
>          apparent disk size      = 47872 KB
>          disks in array          = 2
>          required disks          = 3
>          active disks            = 2
>          working disks           = 2
>          failed disks            = 1
>          spare disks             = 0
>          position in disk list   = 0
>          position in md device   = 0
>          state                   = good
> 
> [dev 8, 17] /dev/scsi/cd_2_3-p1:
>          md version              = 0.90.0
>          superblock uuid         = 0F4274E7.6F390D6E.6521DD63.654D0072
>          md minor number         = 0
>          created                 = 1097103636 (Wed Oct  6 18:00:36 2004)
>          last updated            = 1097103744 (Wed Oct  6 18:02:24 2004)
>          raid level              = 5
>          chunk size              = 256 KB
>          apparent disk size      = 47872 KB
>          disks in array          = 3
>          required disks          = 3
>          active disks            = 3
>          working disks           = 3
>          failed disks            = 0
>          spare disks             = 0
>          position in disk list   = 2
>          position in md device   = 2
>          state                   = good
> 
> [dev 8, 33] /dev/scsi/cd_3_3-p1:
>          md version              = 0.90.0
>          superblock uuid         = 0F4274E7.6F390D6E.6521DD63.654D0072
>          md minor number         = 0
>          created                 = 1097103636 (Wed Oct  6 18:00:36 2004)
>          last updated            = 1097103991 (Wed Oct  6 18:06:31 2004)
>          raid level              = 5
>          chunk size              = 256 KB
>          apparent disk size      = 47872 KB
>          disks in array          = 2
>          required disks          = 3
>          active disks            = 2
>          working disks           = 2
>          failed disks            = 1
>          spare disks             = 0
>          position in disk list   = 2
>          position in md device   = 2
>          state                   = unknown
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
