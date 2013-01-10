From: Adam Goryachev <adam@websitemanagers.com.au>
Subject: Re: Linear raid extend component
Date: Thu, 10 Jan 2013 23:14:46 +1100
Message-ID: <50EEB0B6.20505@websitemanagers.com.au>
References: <CE9AB803-93DD-4A9A-BA97-FD5F323833DE@websitemanagers.com.au> <E2F855BB-D735-4186-8A0A-92DB8024A5DE@colorremedies.com> <50DF5168.9050703@hardwarefreak.com> <50ED18A3.7050203@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50ED18A3.7050203@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/01/13 18:13, Adam Goryachev wrote:
> Actually, once I remembered that I did this before when I upgraded, I
> went to google, and found:
> http://permalink.gmane.org/gmane.linux.raid/38963
>
> Which was the result of my request last time:
> NeilBrown <http://search.gmane.org/?author=NeilBrown&sort=date> | 25
> Jun 2012 04:52
> I just checked this will loop devices and it works as expected (assuming you
> have 1.1 or 1.2 metadata).
> So:
>   mdadm -S /dev/md2
>   mdadm -A --update=devicesize /dev/md0 /dev/md1
> (order doesn't matter with assemble).
> So, as soon as I can unmount the partition, I'll give that a try
> again, and hopefully I'm all sorted.
>
> Since I spent so much time typing all the below, I'll leave it there
> anyway.
>
> Thanks again for everyone's help, and just another reminder to check
> google first, someone else (or yourself) might have had the same
> question before :)

OK, so this is ... almost working....
I've worked out that I can't use fdisk on a drive larger than 2TB, so
I've now moved onto parted. I remove one drive from the raid array (fail
and remove), then used parted to create a GPT partition, and
partitioned, then added the new drive back to the RAID1, waited for it
to sync, and then repeated the process with the second drive. However,
it doesn't seem to be working properly on the second drive as I don't
get the extra space:

This one is working/the right size
parted  /dev/sdc print
Model: ATA WDC WD30EFRX-68A (scsi)
Disk /dev/sdc: 3001GB
Sector size (logical/physical): 512B/4096B
Partition Table: gpt

Number  Start   End     Size    File system  Name     Flags
 1      1049kB  3001GB  3001GB               primary  raid

mdadm --misc --examine /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 84e0923e:a10ebc3a:fc28c832:2341bfd8
           Name : myhost:1  (local to host myhost)
  Creation Time : Wed Feb  1 19:26:45 2012
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
     Array Size : 4294963199 (2048.00 GiB 2199.02 GB)
  Used Dev Size : 4294963199 (2048.00 GiB 2199.02 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 56c29503:527ce1ec:2af3394a:1739e6f4

    Update Time : Thu Jan 10 23:02:47 2013
       Checksum : 1003d87f - correct
         Events : 50468


   Device Role : Active device 0
   Array State : A. ('A' == active, '.' == missing)

Note the "Avail Dev Size" is 3TB, larger than the Array Size and Used
Dev Size.

This drive is not working properly, but parted looks correct (identical
to the working one above):

parted  /dev/sde print
Model: ATA WDC WD30EFRX-68A (scsi)
Disk /dev/sde: 3001GB
Sector size (logical/physical): 512B/4096B
Partition Table: gpt

Number  Start   End     Size    File system  Name     Flags
 1      1049kB  3001GB  3001GB               primary  raid

mdadm --misc --examine /dev/sde1
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 84e0923e:a10ebc3a:fc28c832:2341bfd8
           Name : keep.websitemanagers.com.au:1  (local to host
keep.websitemanagers.com.au)
  Creation Time : Wed Feb  1 19:26:45 2012
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 4294963199 (2048.00 GiB 2199.02 GB)
     Array Size : 4294963199 (2048.00 GiB 2199.02 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 5b37728e:f4e4ee3c:03284a2a:375bc4e7

    Update Time : Thu Jan 10 22:56:46 2013
       Checksum : 608e6b8c - correct
         Events : 50428


   Device Role : Active device 1
   Array State : AA ('A' == active, '.' == missing)

This time the "Avail Dev Size" is the same as previously when I used
fdisk to create a normal partition, so it looks like the GPT partition
is not visible.

If I remove sde1 from the array (fail and remove) and then try to run
kpartx -av /dev/sde I get this:
kpartx -av /dev/sde
add map sde1 (253:0): 0 5860530176 linear /dev/sde 2048

but mdadm --misc --examine /dev/sde1 does not change at all

Two questions:
1) How or what do I need to do to get sde1 to show the correct size?
Once that happens, I can grow the RAID1 array, and then I can extend the
linear array
2) Are these partitions aligned properly? When I re-add the partition to
the array, I see this in dmesg:
md1: Warning: Device sde1 is misaligned

I know fdisk is not going to work properly, but it also shows a
mis-alignment:
fdisk -l /dev/sde

WARNING: GPT (GUID Partition Table) detected on '/dev/sde'! The util
fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sde: 3000.6 GB, 3000592982016 bytes
255 heads, 63 sectors/track, 364801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sde1               1      267350  2147483647+  ee  GPT
Partition 1 does not start on physical sector boundary.

However, parted says it is optimal:
(parted) align-check
alignment type(min/opt)  [optimal]/minimal?                              
Partition number? 1                                                      
1 aligned

I thought I read that the partition should start at 1M, but parted seems
to have put it a little further.

So I don't know what to believe....

Any comments/suggestions would be appreciated.

Thanks,
Adam

-- 
Adam Goryachev
Website Managers
Ph: +61 2 8304 0000                            adam@websitemanagers.com.au
Fax: +61 2 8304 0001                            www.websitemanagers.com.au

