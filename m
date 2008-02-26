From: Bernd Schubert <bs@q-leap.de>
Subject: md3: unsupported reshape (reduce disks) required - aborting
Date: Tue, 26 Feb 2008 20:20:12 +0100
Message-ID: <200802262020.12458.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

while doing a md-check, there was a problem with Lustre and I had to 
hard-reboot. Please note, the raid was perfectly fine, I only did a 
manual "echo check >/sys/block/md3/md/sync_action" to increase the load.

After the unclean reset/reboot the md devices don't come up, dmesg shows:

[ 1169.127975] md: pers->run() failed ...
[ 1193.398304] md: md3 stopped.
[ 1193.401312] md: unbind<sdk1>
[ 1193.404287] md: export_rdev(sdk1)
[ 1193.407759] md: unbind<sdm1>
[ 1193.410751] md: export_rdev(sdm1)
[ 1193.414162] md: unbind<sdg1>
[ 1193.417162] md: export_rdev(sdg1)
[ 1193.420585] md: unbind<sdc1>
[ 1193.423564] md: export_rdev(sdc1)
[ 1275.761216] md: md3 stopped.
[ 1275.768875] md: bind<sdc1>
[ 1275.771869] md: bind<sdg1>
[ 1275.775006] md: bind<sdm1>
[ 1275.778210] md: bind<sdk1>
[ 1275.781219] md: md3: raid array is not clean -- starting background 
reconstruction
[ 1275.792922] raid5: md3: unsupported reshape (reduce disks) required - 
aborting.

mdadm --force --run doesn't help. It also doesn't help to just specifiy 4 of 
the 6 md devices. The super-block is on all device identical as shown below.

As last action I think I can only recreate the array, but I think this is the 
worst and most dangerous action and IMHO this is a bug.

Any idea how to continue without re-creating the array?

This is with linux-2.6.22.18 and mdadm v2.5.6 .


pfs1n9:~# mdadm --examine /dev/inf/box-6a/1
/dev/inf/box-6a/1:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : c318c4c3:7c976bfe:da28f9bd:db4d93a0
  Creation Time : Wed Jan  2 18:09:05 2008
     Raid Level : raid6
    Device Size : 1708717056 (1629.56 GiB 1749.73 GB)
     Array Size : 6834868224 (6518.24 GiB 6998.91 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 3

  Reshape pos'n : 225878016 (215.41 GiB 231.30 GB)

    Update Time : Tue Feb 26 19:40:04 2008
          State : active
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : ae7a4ac1 - correct
         Events : 0.123769

     Chunk Size : 1024K

      Number   Major   Minor   RaidDevice State
this     4       8       65        4      active sync   /dev/sde1

   0     0       8      161        0      active sync   /dev/sdk1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8      193        3      active sync   /dev/sdm1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8      129        5      active sync   /dev/sdi1
pfs1n9:~#


Thanks in advance,
Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH
