From: Mark Munoz <mark.munoz@rightthisminute.com>
Subject: MD RAID Bug 7/15/12
Date: Sat, 29 Sep 2012 17:12:40 -0700
Message-ID: <022FFCA9-5D0E-41DB-9617-202C6FAADD06@rightthisminute.com>
Mime-Version: 1.0 (Mac OS X Mail 6.1 \(1498\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi I appear to have been affected by the bug you found on 7/15/12.  The data I have on this array is really important and I want to make sure I get this correct before I actually make changes.

Configuration:
md0 is a RAID 6 volume with 24 devices and 1 spare.  It is working fine and was unaffected.
md1 is a RAID 6 volume with 19 devices and 1 spare.  It was affected.  All the drives show as unknown raid level and 0 devices.  With the exception of device 5.  It has all the information.

Here is the output from that drive:

serveradmin@hulk:/etc/mdadm$ sudo mdadm --examine /dev/sdaf
/dev/sdaf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 6afb3306:144cec30:1b2d1a19:3a56f0d3
           Name : hulk:1  (local to host hulk)
  Creation Time : Wed Aug 15 16:25:30 2012
     Raid Level : raid6
   Raid Devices : 19

 Avail Dev Size : 5860531120 (2794.52 GiB 3000.59 GB)
     Array Size : 99629024416 (47506.82 GiB 51010.06 GB)
  Used Dev Size : 5860530848 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 205dfd9f:9be2b9ca:1f775974:fb1b742c

    Update Time : Sat Sep 29 12:22:51 2012
       Checksum : 9f164d8e - correct
         Events : 38

         Layout : left-symmetric
     Chunk Size : 4K

   Device Role : Active device 5
   Array State : AAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing)

Now I also have md2 which is a striped RAID of both md0 and md1.

When I type:

sudo mdadm --create --assume-clean /dev/md1 --level=6 --chunk=4 --metadata=1.2 --raid-devices=19 /dev/sdaa /dev/sdab /dev/sdac /dev/sdad /dev/sdae /dev/sdaf /dev/sdag /dev/sdah /dev/sdai /dev/sdaj /dev/sdak /dev/sdal /dev/sdam /dev/sdan /dev/sdao /dev/sdap /dev/sdaq /dev/sdar /dev/sdas

the following error for each device.

mdadm: /dev/sdaa appears to be part of a raid array:
    level=-unknown- devices=0 ctime=Wed Aug 15 16:25:30 2012
mdadm: partition table exists on /dev/sdaa but will be lost or
       meaningless after creating array

I want to make sure by running this above command that I won't affect any of the data of md2 when I assemble that array after creating md1.  Any help on this issue would be greatly appreciated.  I would normally just DD copies but as you can see I would have to buy 19 more 3TB hard drives as well as the time to DD each drive.  It is a production server and that kind of down time would really rather be avoided.  

Thank you so much for your time.

Mark Munoz
623.523.3201