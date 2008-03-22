From: Arthur Britto <ahbritto@iat.com>
Subject: Help: Re-assemble raid-5 with inconsistent events.
Date: Fri, 21 Mar 2008 19:40:39 -0700
Message-ID: <1206153639.16304.30.camel@loss.redstem.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a RAID 5 with 6 components.  The 4-port SATA controller died and
left the RAID in an inconsistent state.  2 of the 6 components have a
more recent event stamp than the others. 

What command should I issue to re-assemble the RAID?

In particular, I don't want to force the RAID to be assembled with the
components in the wrong order.  Especially as the order given
by /dev/sd?? does not match the component order.

Thanks in advance,

-Arthur

# mdadm -A /dev/md5
mdadm: /dev/md5 assembled from 2 drives - not enough to start the array.

# cat /proc/mdstat
...
md5 : inactive sdg2[0](S) sdj2[5](S) sdk2[4](S) sdl2[3](S) sdh2[2](S) sdi2[1](S)
      2343866880 blocks
...

# mdadm -E /dev/sd[gjklhi]2 | egrep Events 
         Events : 0.9088480
         Events : 0.9088480
         Events : 0.9088476
         Events : 0.9088476
         Events : 0.9088476
         Events : 0.9088476

# mdadm -E /dev/sd[gjklhi]2 | egrep this
this     0       8       98        0      active sync   /dev/sdg2
this     2       8      114        2      active sync   /dev/sdh2
this     1       8      130        1      active sync   /dev/sdi2
this     5       8      146        5      active sync   /dev/sdj2
this     4       8      162        4      active sync   /dev/sdk2
this     3       8      178        3      active sync   /dev/sdl2

# egrep '^DEVICE|md5' /etc/mdadm.conf
DEVICE /dev/sd??
ARRAY /dev/md5 level=raid5 num-devices=6 UUID=e49080f3:c60755cc:bef07a34:d5ceac64

# mdadm -E /dev/sd[gjklhi]2

/dev/sdg2:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : e49080f3:c60755cc:bef07a34:d5ceac64
  Creation Time : Wed Feb 15 02:18:54 2006
     Raid Level : raid5
  Used Dev Size : 390644480 (372.55 GiB 400.02 GB)
     Array Size : 1953222400 (1862.74 GiB 2000.10 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 5

    Update Time : Wed Mar 19 07:43:46 2008
          State : clean
Internal Bitmap : present
 Active Devices : 2
Working Devices : 2
 Failed Devices : 4
  Spare Devices : 0
       Checksum : 8cb597af - correct
         Events : 0.9088480

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       98        0      active sync   /dev/sdg2

   0     0       8       98        0      active sync   /dev/sdg2
   1     1       0        0        1      faulty removed
   2     2       8      114        2      active sync   /dev/sdh2
   3     3       0        0        3      faulty removed
   4     4       0        0        4      faulty removed
   5     5       0        0        5      faulty removed
/dev/sdh2:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : e49080f3:c60755cc:bef07a34:d5ceac64
  Creation Time : Wed Feb 15 02:18:54 2006
     Raid Level : raid5
  Used Dev Size : 390644480 (372.55 GiB 400.02 GB)
     Array Size : 1953222400 (1862.74 GiB 2000.10 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 5

    Update Time : Wed Mar 19 07:43:46 2008
          State : clean
Internal Bitmap : present
 Active Devices : 2
Working Devices : 2
 Failed Devices : 4
  Spare Devices : 0
       Checksum : 8cb597c3 - correct
         Events : 0.9088480

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8      114        2      active sync   /dev/sdh2

   0     0       8       98        0      active sync   /dev/sdg2
   1     1       0        0        1      faulty removed
   2     2       8      114        2      active sync   /dev/sdh2
   3     3       0        0        3      faulty removed
   4     4       0        0        4      faulty removed
   5     5       0        0        5      faulty removed
/dev/sdi2:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : e49080f3:c60755cc:bef07a34:d5ceac64
  Creation Time : Wed Feb 15 02:18:54 2006
     Raid Level : raid5
  Used Dev Size : 390644480 (372.55 GiB 400.02 GB)
     Array Size : 1953222400 (1862.74 GiB 2000.10 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 5

    Update Time : Wed Mar 19 00:56:18 2008
          State : clean
Internal Bitmap : present
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 8cb53801 - correct
         Events : 0.9088476

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8      130        1      active sync   /dev/sdi2

   0     0       8       98        0      active sync   /dev/sdg2
   1     1       8      130        1      active sync   /dev/sdi2
   2     2       8      114        2      active sync   /dev/sdh2
   3     3       8      178        3      active sync   /dev/sdl2
   4     4       8      162        4      active sync   /dev/sdk2
   5     5       8      146        5      active sync   /dev/sdj2
/dev/sdj2:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : e49080f3:c60755cc:bef07a34:d5ceac64
  Creation Time : Wed Feb 15 02:18:54 2006
     Raid Level : raid5
  Used Dev Size : 390644480 (372.55 GiB 400.02 GB)
     Array Size : 1953222400 (1862.74 GiB 2000.10 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 5

    Update Time : Wed Mar 19 00:56:18 2008
          State : clean
Internal Bitmap : present
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 8cb53819 - correct
         Events : 0.9088476

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8      146        5      active sync   /dev/sdj2

   0     0       8       98        0      active sync   /dev/sdg2
   1     1       8      130        1      active sync   /dev/sdi2
   2     2       8      114        2      active sync   /dev/sdh2
   3     3       8      178        3      active sync   /dev/sdl2
   4     4       8      162        4      active sync   /dev/sdk2
   5     5       8      146        5      active sync   /dev/sdj2
/dev/sdk2:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : e49080f3:c60755cc:bef07a34:d5ceac64
  Creation Time : Wed Feb 15 02:18:54 2006
     Raid Level : raid5
  Used Dev Size : 390644480 (372.55 GiB 400.02 GB)
     Array Size : 1953222400 (1862.74 GiB 2000.10 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 5

    Update Time : Wed Mar 19 00:56:18 2008
          State : clean
Internal Bitmap : present
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 8cb53827 - correct
         Events : 0.9088476

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8      162        4      active sync   /dev/sdk2

   0     0       8       98        0      active sync   /dev/sdg2
   1     1       8      130        1      active sync   /dev/sdi2
   2     2       8      114        2      active sync   /dev/sdh2
   3     3       8      178        3      active sync   /dev/sdl2
   4     4       8      162        4      active sync   /dev/sdk2
   5     5       8      146        5      active sync   /dev/sdj2
/dev/sdl2:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : e49080f3:c60755cc:bef07a34:d5ceac64
  Creation Time : Wed Feb 15 02:18:54 2006
     Raid Level : raid5
  Used Dev Size : 390644480 (372.55 GiB 400.02 GB)
     Array Size : 1953222400 (1862.74 GiB 2000.10 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 5

    Update Time : Wed Mar 19 00:56:18 2008
          State : clean
Internal Bitmap : present
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 8cb53835 - correct
         Events : 0.9088476

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8      178        3      active sync   /dev/sdl2

   0     0       8       98        0      active sync   /dev/sdg2
   1     1       8      130        1      active sync   /dev/sdi2
   2     2       8      114        2      active sync   /dev/sdh2
   3     3       8      178        3      active sync   /dev/sdl2
   4     4       8      162        4      active sync   /dev/sdk2
   5     5       8      146        5      active sync   /dev/sdj2

