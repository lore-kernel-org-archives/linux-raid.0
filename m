From: MasterPrenium <masterprenium.lkml@gmail.com>
Subject: Superblocks lost on 5/6 disks
Date: Sun, 23 Jul 2017 01:54:00 +0200
Message-ID: <1b693f6a-28e9-2a3a-7b62-2d9bdb52cf31@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: "MasterPrenium@gmail.com" <MasterPrenium@gmail.com>
List-Id: linux-raid.ids

Hi guys,

I was running a raid 6 array, made of 6x 3TB drives. Everything was
working fine on this server.
I decided to shut it down in order to made a usual dust cleaning, no
problem here. I'm 99% sure I check the raid stack status before shutting
it down (/proc/mdstat) and everything was fine.
When I started back the server (please note I started it on a LiveCD,
because I originally wanted to setup a new / (root) system which has
nothing to deal with the raid 6 array). I changed my mind and decided to
boot the original OS, the array wasn't up at startup. No problem I tried
to assemble it, but mdadm claimed that it can't assemble the array since
there was only one disk out of 6.
All disk were present, but superblock was zero-ed.
No SMART error or anything that could make me think of hard drive failure.

Please note the server was runing an old kernel, on which the array was
made, it's a kernel 3.5.7, and the livecd had a newer version 4.9.24.

The array which was originally built was a raid 5 with 5 drives, I grew
it up to 6 drives in raid 6 when I had some hard drives failure.
Everything was synchronised since a long time. At least a few months.

The array was : /dev/md/3TB, with partitions /dev/sd[c-h]1.

mdadm --examine /dev/sdc1 give me the correct superblock infos :

/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 9372578e:331a752a:d132dbef:3a67286d
           Name : Server:3TB
  Creation Time : Sun Aug 21 00:27:32 2016
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
     Array Size : 8589928448 (8191.99 GiB 8796.09 GB)
  Used Dev Size : 4294964224 (2048.00 GiB 2199.02 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=1565563904 sectors
          State : clean
    Device UUID : d8051645:40eff7c2:7eb00722:711efe7a

    Update Time : Sat Jul 22 11:58:51 2017
       Checksum : 1b841a0e - correct
         Events : 463

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)



but

mdadm --examine on all other drives said "No md superblock detected on
xxxx".


- blkid also report nothing on UUID_SUB= parameter, neither label etc
... Only work on /dev/sdc1 (I also got another raid 5 stack on this
server which is still running flawlessly).

- gparted (on the livecd), cannot guess what type of partition hard
drives are running (except sdc).

I also tried some force assemble etc ... and got some message that mdadm
was expecting a superblock value, but got "0000000" instead.

I dump 8K of first sector of the partition and they were completely
blank (except for sdc).


So I definitely lost my superblock informations on 5 out of 6 drives.


Maybe I panic a bit and made now some mistakes. But here what I've tried :
Only on one drive (/dev/sdd) (as a test) I tried re-creating the
partition (was thinking the problem could be here, because I already had
such kind of issue (another setup, but maybe same kernel), and after
re-creating the partition (I always use the same scheme), the device was
back again).

I've tried re-creating the array, with --assume-clean, but I think there
could be some order for the drive ? I don't know what is the original
order. Nevermind it doesn't work.

I restore a backup of the 50 first Megabytes of sdc to get back it's
original information and superblock.


But now I'm stucked and I'm asking for your help.

==> Can I copy the "working" (ie : original sdc) superblock to other
drives to make it work ?
I've looked a bit with some hex dump. I can copy data from sdc to sdd
(for ex), but I don't know how to make the checksum correct (or how to
change the device UUID).

If someone can give me more informations, or some guidance ...


Any help would be greatly appreciated.

Btw, I still don't know how the superblocks could have been zeroed.

Regards,

MasterPrenium

