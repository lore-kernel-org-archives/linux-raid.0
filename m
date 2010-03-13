From: Kapetanakis Giannis <bilias@edu.physics.uoc.gr>
Subject: Re: large filesystem corruptions
Date: Sat, 13 Mar 2010 10:12:34 +0200
Message-ID: <4B9B48F2.7060907@edu.physics.uoc.gr>
References: <4B9A9D81.3000009@edu.physics.uoc.gr> <4B9AA5AC.9090005@redhat.com>	 <4B9ADC61.7080007@edu.physics.uoc.gr>	 <4B9AE28C.8030905@edu.physics.uoc.gr> <4877c76c1003121758w49cdeccas6865e65c9e985770@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1003121758w49cdeccas6865e65c9e985770@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/03/10 03:58, Michael Evans wrote:

> This is a really basic thing, but do you have the x86 support for very
> large block devices (I can't remember what the option is, since I've
> been running 64 bits on any system that even remotely came close to
> needing it anyway) enabled in the config as well?
>
> Here's a hit from google, CONFIG_LBD http://cateee.net/lkddb/web-lkddb/LBD.html
>
> Enable block devices of size 2TB and larger.

Yes I have LBD support
grep LBD /boot/config-2.6.18-164.11.1.el5PAE
CONFIG_LBD=y


> Since you're using a device>2TB in size, I will assume you are using
> one of the three 'version 1' superblock types.  Either at the end 1.0,
> beginning 1.1 or 4kb in from the beginning.
>
> Please provide the full output of mdadm -Dvvs

If you mean metadata then I'm at default -> 0.90
Is this the problem? I 've seen in the manual that
2 TB is the limit for raid 1 and above

"0, 0.90, default:   Use the original 0.90  format  superblock.   This 
format limits  arrays  to 28 component devices and limits component 
devices of levels 1 and greater to 2 terabytes."


[root@server ~]# mdadm -Dvvs
mdadm: bad uuid: UUID=324587ca:484d94c7:f06cbaee:5b63cd3
/dev/md0:
         Version : 0.90
   Creation Time : Sat Mar 13 02:00:23 2010
      Raid Level : raid0
      Array Size : 14627614208 (13949.98 GiB 14978.68 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Sat Mar 13 02:00:23 2010
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

      Chunk Size : 256K

            UUID : 324587ca:484d94c7:f06cbaee:5b63cd37
          Events : 0.1

     Number   Major   Minor   RaidDevice State
        0       8       16        0      active sync   /dev/sdb
        1       8       32        1      active sync   /dev/sdc



> You can use any block device as a member of an md array.  However if
> you are going 'whole drive' then it would be a very good idea to erase
> the existing partition table structure prior to putting a raid
> superblock on the device.  This way there is no confusion about if the
> device has partitions or is in fact a raid member.  Similarly when
> transitioning back the other way ensuring that the old metadata for
> the array is erased is also a good idea.

I have erased prior creating the gpt and the raid devide
dd if=/dev/zero of=/dev/sdb bs=512 count=64
dd if=/dev/zero of=/dev/sdc bs=512 count=64

(I accidentally erased my boot disk also but I managed to recover)

> The kernel you're running seems to be ... exceptionally old and
> heavily patched.  I have no way of knowing if the many, many, patches
> that fixed numerous issues over the /years/ since it's release have
> been included.  Please make sure you have the most recent release from
> your vendor and ask them for support in parallel.

This is centos 5.4 stock kernel. So this is redhat 5.4 stock kernel
They say they support all these...

thanks
Giannis
