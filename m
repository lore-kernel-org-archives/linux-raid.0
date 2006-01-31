From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [klibc] Exporting which partitions to md-configure
Date: Tue, 31 Jan 2006 01:53:32 -0500
Message-ID: <E1ADEC35-7929-4B90-9A64-14A283229121@mac.com>
References: <43DEB4B8.5040607@zytor.com> <20060131032133.GA8920@kroah.com> <20060131032438.GB8920@kroah.com>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060131032438.GB8920@kroah.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org, klibc list <klibc@zytor.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Jan 30, 2006, at 22:24, Greg KH wrote:
> Oh, an example of it working:
> 	# vol_id /dev/sda3
> 	ID_FS_USAGE=filesystem
> 	ID_FS_TYPE=ext3
> 	ID_FS_VERSION=1.0
> 	ID_FS_UUID=9d2efd53-6b5a-4f84-86cc-def71269b7ca
> 	ID_FS_LABEL=
> 	ID_FS_LABEL_SAFE=
> 	# vol_id -t /dev/sda3
> 	ext3
> 	# vol_id -u /dev/sda3
> 	9d2efd53-6b5a-4f84-86cc-def71269b7ca

That shows filesystem information, but not at all the partition table  
information.  If I look at my mac partition table (this is using the  
apple-provided tool under OS X, but it's the same using the Linux  
tool), for example:

hc6524e32:~ kyle$ sudo -H /usr/sbin/pdisk -l /dev/disk1

Partition map (with 512 byte blocks) on '/dev/disk1'
#:                type name                               length    
base      ( size )
1: Apple_partition_map Apple                                  63 @ 1
2:     Apple_Bootstrap bootstrap                            1600 @ 64
3:     Apple_UNIX_SVR2 linux_boot                        1048576 @  
1664      (512.0M)
4:     Apple_UNIX_SVR2 linux_swap                        2097152 @  
1050240   (  1.0G)
5:     Apple_UNIX_SVR2 linux_lvm                       241051200 @  
3147392   (114.9G)
6:          Apple_Boot eXternal booter                    262144 @  
244198592 (128.0M)
7:          Apple_RAID Apple_RAID_OfflineV2_Untitled_2 243936432 @  
244460736 (116.3G)

Device block size=512, Number of Blocks=488397168 (232.9G)
DeviceType=0x0, DeviceId=0x0


Now obviously linux_boot, linux_swap, and linux_lvm are not  
_actually_ Apple_UNIX_SVR2, but that's the type stored in the  
partition map.  They also have partition map labels "linux_*", but  
they do *not* have ext3 volume labels.  In fact, linux_boot is one  
slice of a RAID1 of 3 drives, linux_swap is one slice of a RAID5 of 3  
drives, and linux_lvm is one slice of a RAID5 of 3 drives that  
alltogether make an LVM PV.  If I examine each of those partitions  
individually, I get a lot of other information that is totally  
unrelated to that stored in the partition table.  It would be nice to  
be able to change the type of linux_* from Apple_UNIX_SVR2 to  
Linux_RAID (Max length is 31 characters), and have my userspace tools  
be able to detect that and do useful things with it and the pmap label.


Cheers,
Kyle Moffett

--
If you don't believe that a case based on [nothing] could potentially  
drag on in court for _years_, then you have no business playing with  
the legal system at all.
   -- Rob Landley



