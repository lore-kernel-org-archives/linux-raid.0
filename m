From: John Dawson <linux@celticblues.com>
Subject: Re: Can't mount Old RHEL 6 Raid with new install of CentOS 7, now
 can't mount with original RHEL 6
Date: Tue, 16 Aug 2016 11:35:51 -0600
Message-ID: <57d23adc6db12d6a365dd2c6f50d4bf5@celticblues.com>
References: <42cee2e2d85a5b0e39efc34117e597a2@celticblues.com>
 <CAJCQCtQfBjhKh2Fu+W76JyXODFJJ9Qxjbyn7KK0i3ALs1xREgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtQfBjhKh2Fu+W76JyXODFJJ9Qxjbyn7KK0i3ALs1xREgQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sorry.. my bad... I am not using RHEL... I am using CentOS...

     mdadm --version = mdadm - v3.2.3 - 23rd December 2011


When I try to assemble the raid I get the following errors:

      sudo mdadm --assemble /dev/md127 /dev/sdb1 /dev/sdc1

I get the following:

      mdadm: /dev/md127 has been started with 2 drives.

When I try to mount

      sudo mount /dev/md127 /proj

I get the following:

      mount: you must specify the filesystem type

When I specify the filesystem type,

      sudo mount -t ext4 /dev/md127 /proj/

I get the following:

      mount: wrong fs type, bad option, bad superblock on /dev/md127, 
missing codepage or helper program, or other error In some cases useful 
info is found in syslog - try       dmesg | tail  or so


===============================================
dmesg | tail
===============================================
md: md127 stopped.
md: bind<sdb1>
md: bind<sdc1>
bio: create slab <bio-1> at 1
md/raid0:md127: md_size is 3907039232 sectors.
md: RAID0 configuration for md127 - 1 zone
md: zone0=[sdc1/sdb1]
       zone-offset=         0KB, device-offset=         0KB, 
size=1953519616KB
EXT4-fs (md127): VFS: Can't find ext4 filesystem

===============================================
"sudo mdadm -D /dev/md127" results
===============================================

/dev/md127:
         Version : 1.2
   Creation Time : Fri Aug  5 16:46:10 2016
      Raid Level : raid0
      Array Size : 1953519616 (1863.02 GiB 2000.40 GB)
    Raid Devices : 2
   Total Devices : 2
     Persistence : Superblock is persistent

     Update Time : Fri Aug  5 16:46:10 2016
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

      Chunk Size : 512K

            Name : mymachine:0  (local to host mymachine)
            UUID : 8217dfb5:a97a15df:94a85926:3fea6697
          Events : 0

     Number   Major   Minor   RaidDevice State
        0       8       33        0      active sync   /dev/sdc1
        1       8       17        1      active sync   /dev/sdb1



===============================================
"sudo mdadm --examine /dev/sdb1" results
===============================================

/dev/sdb1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 8217dfb5:a97a15df:94a85926:3fea6697
            Name : mymachine:0  (local to host mymachine)
   Creation Time : Fri Aug  5 16:46:10 2016
      Raid Level : raid0
    Raid Devices : 2

  Avail Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : d9bab0d7:793e5168:4457d25b:24614a41

     Update Time : Fri Aug  5 16:46:10 2016
        Checksum : 744c405e - correct
          Events : 0

      Chunk Size : 512K

    Device Role : Active device 1
    Array State : AA ('A' == active, '.' == missing)


===============================================
"sudo mdadm --examine /dev/sdc1" results
===============================================

/dev/sdc1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 8217dfb5:a97a15df:94a85926:3fea6697
            Name : mymachine:0  (local to host mymachine)
   Creation Time : Fri Aug  5 16:46:10 2016
      Raid Level : raid0
    Raid Devices : 2

  Avail Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : a0dfb805:18718fed:6985075a:12fbb196

     Update Time : Fri Aug  5 16:46:10 2016
        Checksum : 7b2f5fd6 - correct
          Events : 0

      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AA ('A' == active, '.' == missing)




On 2016-08-11 20:38, Chris Murphy wrote:
> On Thu, Aug 11, 2016 at 6:19 AM, John Dawson <linux@celticblues.com> 
> wrote:
>> I have a machine which had a drive with RHEL 6.X installed with a raid
>> device setup on separate disk(s). Installed a new hard disk in machine 
>> and
>> installed CentOS 7. CentOS 7 wouldn't mount the raid. Put the old 
>> drive
>> back in and now RHEL 6.X won't mount the raid. Is the raid permanently
>> hosed? Can I get the data on it back? How? Thx.
> 
> RHEL comes with a support contract so you should contact Red Hat about
> that part.
> 
> Also, not anywhere near enough information has been provided, almost
> like you think what you're experiencing is a widely known problem with
> a known solution. But it isn't. So you should provide mdadm -E
> information for each member block device, whether or not the array
> assembles manually, if not what error do you get in user and kernel
> space, and what command you're using to mount the array that you say
> fails, and what the error message is.
> 
> Also include mdadm version on both systems because few people will
> have any idea what mdadm version is on the particular installation of
> RHEL and CentOS you're using, as these things aren't standardized at
> all across distros.

