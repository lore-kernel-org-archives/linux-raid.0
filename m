From: "Neil ." <neil.perrie@gmail.com>
Subject: Re: Lost raid 5 volume
Date: Sun, 14 Dec 2014 04:30:51 +0000
Message-ID: <CADhQzuo57BoMT_fLVHd=ufGR6ztSFaRqsRLZtFSwvii+YzAcLQ@mail.gmail.com>
References: <CADhQzuraHNZ1MaMw4OP0-3+vxRcB_TAN-_R2_eaTOQcEfUv8+w@mail.gmail.com>
	<CAB_L8sZUdZkLRPQXS+ANam=k4Tvjynkh8UzgL5WXE3qBwYUK6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB_L8sZUdZkLRPQXS+ANam=k4Tvjynkh8UzgL5WXE3qBwYUK6Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Emery Guevremont <emery.guevremont@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

smartctl says Overall health...: passed for all drives.

This is interesting(?)

 mdadm --examine for sda2 and b2 list:
 Array State as : AAAA

But sdc2 and d2 list it as ..AA

root@sysresccd /mnt % mdadm --examine /dev/sda2
/dev/sda2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : cf0bf1b9:f57b96be:8c749fcb:cea10311
           Name : 'localhost.localdomain':1
  Creation Time : Sat Oct 25 16:11:56 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 11712653168 (5585.03 GiB 5996.88 GB)
     Array Size : 17568979392 (16755.08 GiB 17990.63 GB)
  Used Dev Size : 11712652928 (5585.03 GiB 5996.88 GB)
   Super Offset : 11712653296 sectors
   Unused Space : before=0 sectors, after=368 sectors
          State : clean
    Device UUID : 0953e84c:a25760b0:28a20bab:bd1dc41b

Internal Bitmap : 2 sectors from superblock
    Update Time : Sat Dec  6 14:00:02 2014
       Checksum : dfe27505 - correct
         Events : 3

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 0
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
root@sysresccd /mnt % mdadm --examine /dev/sdb2
/dev/sdb2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : cf0bf1b9:f57b96be:8c749fcb:cea10311
           Name : 'localhost.localdomain':1
  Creation Time : Sat Oct 25 16:11:56 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 11712653168 (5585.03 GiB 5996.88 GB)
     Array Size : 17568979392 (16755.08 GiB 17990.63 GB)
  Used Dev Size : 11712652928 (5585.03 GiB 5996.88 GB)
   Super Offset : 11712653296 sectors
   Unused Space : before=0 sectors, after=368 sectors
          State : clean
    Device UUID : d96a56d4:c5ac346a:24765692:501f6f22

Internal Bitmap : 2 sectors from superblock
    Update Time : Sat Dec  6 14:00:02 2014
       Checksum : f1ab789 - correct
         Events : 3

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 1
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)


root@sysresccd /mnt % mdadm --examine /dev/sdc2
/dev/sdc2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : cf0bf1b9:f57b96be:8c749fcb:cea10311
           Name : 'localhost.localdomain':1
  Creation Time : Sat Oct 25 16:11:56 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 11712653168 (5585.03 GiB 5996.88 GB)
     Array Size : 17568979392 (16755.08 GiB 17990.63 GB)
  Used Dev Size : 11712652928 (5585.03 GiB 5996.88 GB)
   Super Offset : 11712653296 sectors
   Unused Space : before=0 sectors, after=368 sectors
          State : clean
    Device UUID : 17d61cf2:2c0c4765:cb4c478c:4828aefc

Internal Bitmap : 2 sectors from superblock
    Update Time : Sun Dec  7 11:18:06 2014
       Checksum : fc228d5e - correct
         Events : 8

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 2
   Array State : ..AA ('A' == active, '.' == missing, 'R' == replacing)


root@sysresccd /mnt % mdadm --examine /dev/sdd2
/dev/sdd2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : cf0bf1b9:f57b96be:8c749fcb:cea10311
           Name : 'localhost.localdomain':1
  Creation Time : Sat Oct 25 16:11:56 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 11712653168 (5585.03 GiB 5996.88 GB)
     Array Size : 17568979392 (16755.08 GiB 17990.63 GB)
  Used Dev Size : 11712652928 (5585.03 GiB 5996.88 GB)
   Super Offset : 11712653296 sectors
   Unused Space : before=0 sectors, after=368 sectors
          State : clean
    Device UUID : 306bde8a:3beebe54:52e6acd2:f7681367

Internal Bitmap : 2 sectors from superblock
    Update Time : Sun Dec  7 11:18:06 2014
       Checksum : 3526df7d - correct
         Events : 8

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 3
   Array State : ..AA ('A' == active, '.' == missing, 'R' == replacing)






On 14 December 2014 at 00:06, Emery Guevremont
<emery.guevremont@gmail.com> wrote:
> Stop your raid with mdadm -S /dev/md0 or whatever your raid device name is.
>
> Probably the safest thing to do is clone your drives with ddrescue.
> You might also want to view your S.M.A.R.T. log with smarctl -a
> /dev/sda or which ever is your device name.
>
> After, what you'd need to start doing is taking a backup of mdadm
> --examine /dev/sda1 or which ever partition is your partition used for
> raid. This will give us info on you md superblock. Post this info and
> from there we'll be able to see how everything is setup and have a
> better idea of your current situation.
>
> On Fri, Dec 12, 2014 at 7:48 PM, Neil . <neil.perrie@gmail.com> wrote:
>> I am looking for some help in trying to recover a raid 5 volume. Is
>> this the right place? What data should I provide to get the ball
>> rolling?
>>
-snip-
