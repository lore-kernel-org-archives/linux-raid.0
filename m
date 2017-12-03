From: rene.feistle@posteo.de
Subject: mdadm reshaping stuck problem
Date: Sun, 03 Dec 2017 13:47:09 +0100
Message-ID: <73f07f38fb71986fe71be67f00c77698@posteo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

after hours and hours of googling and trying out things, I gave up on=20
this. This email is my last hope of getting my data back.

I have 4*4TB drives installed and want to create a raid 5 with them.

So what I did is create an array of 3 disks (raid 5), copy the data from=20
the 4th drive (I don't have more space available) to the raid and then I=20
wanted to add the last drive to the raid.
I made a mistake here. I accidentally grew the raid to 4 disks with

sudo mdadm --grow --raid-devices=3D4 /dev/md0 --backup-file=3D/tmp/md0.bak

BEFORE adding the last drive as a hot spare. Mdadm immediately started a=20
reshape and says that it failed - because it consists of 4 drives but=20
only 3 drives are available.

I thought okay, let him complete the reshape and everything will be=20
okay. But no - the reshape is stuck at 34.3%.

What I have tried:

- Reboot ( about a 100 times)
- increase stripe cache size up to 32768

mdadm --assemble --invalid-backup --backup-file=3D/root/mdadm0.bak=20
/dev/md0 /dev/sdc1 /dev/sde1 /dev/sdf1

And some other things.

The raid is not mountable. When I try to mount it, the mount command=20
just hungs and nothing happens. That means that I had to edit my fstab=20
with a rescue cd because it would never boot again.
That also means that I have no access to my data.

When I shutdown or reboot the computer, it also hungs at shutdown, I can=20
only hard reset it.

cat /proc/mdstat:

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]=20
[raid4] [r$
md0 : active raid5 sdc1[0] sdf1[3] sde1[1]
       7813771264 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3]=
=20
[UU__]
       [=3D=3D=3D=3D=3D=3D>..............]  reshape =3D 34.3% (1340465664/3=
906885632)=20
finish=3D3$
       bitmap: 3/30 pages [12KB], 65536KB chunk

unused devices: <none>


mdadm --detail /dev/md0


/dev/md0:
         Version : 1.2
   Creation Time : Fri Dec  1 02:10:06 2017
      Raid Level : raid5
      Array Size : 7813771264 (7451.79 GiB 8001.30 GB)
   Used Dev Size : 3906885632 (3725.90 GiB 4000.65 GB)
    Raid Devices : 4
   Total Devices : 3
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Sun Dec  3 13:34:43 2017
           State : active, FAILED, reshaping
  Active Devices : 2
Working Devices : 3
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 512K

  Reshape Status : 34% complete
   Delta Devices : 1, (3->4)

            Name : nas-server:0  (local to host nas-server)
            UUID : e410e68d:76460b65:69c056c0:d2645d55
          Events : 28155

     Number   Major   Minor   RaidDevice State
        0       8       33        0      active sync   /dev/sdc1
        1       8       65        1      active sync   /dev/sde1
        3       8       81        2      spare rebuilding   /dev/sdf1
        6       0        0        6      removed



Any help is appreciated, I'm lost.

Kind Regards

Ren=C3=A9
