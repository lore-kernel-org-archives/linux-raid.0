From: Compte centre de calcul UCP <cdc@cdc.u-cergy.fr>
Subject: RAID5 software general crash
Date: Wed, 04 Jun 2003 07:58:11 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EDDA693.1D6D2AF2@cdc.u-cergy.fr>
Reply-To: cdc@cdc.u-cergy.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I'm newbie in RAID5 Software.
I need some help (direct answer on the list or links) to understand and
repair my NFS server turning with RAID5 software.

It turn under 
- an old Distro : Linux Mandrake release 7.1 (helium)
- an old kernel : Kernel 2.2.19-6.3mdk on an i686
- a raid version : mkraid version 0.90.0

We have 5 SCSI disk :
- 4 for the RAID5
- 1 for the spare

Sunday morning there was a crash. I don't now what happened exactly
until now, but the raid stopped.

On the screen there was log saying :
RAID5 : md0: Unrecoverable I/O erreor for Block...

I logged in and type 
# cat /proc/mdstat 
md0 : active raid5 sde1[5] sdd1[4](F) sdc1[3](F) sdb1[2](F) sda1[1](F)
(or something like that... the only thing I'm sure it's that there was
Flag (F) on the fourth SCSI disk !!!)

I shutdown the server (and all the client).

When I restart the server. The dmesg said :

---- begin of dmesg------

<snip>

autorun ...
considering sde1 ...
  adding sde1 ...
  adding sdd1 ...
  adding sdc1 ...
  adding sdb1 ...
  adding sda1 ...
created md0
bind<sda1,1>
bind<sdb1,2>
bind<sdc1,3>
bind<sdd1,4>
bind<sde1,5>
running: <sde1><sdd1><sdc1><sdb1><sda1>
now!
sde1's event counter: 0000003f
sdd1's event counter: 0000003c
sdc1's event counter: 0000003c
sdb1's event counter: 0000003c
sda1's event counter: 0000003c
md: superblock update time inconsistency -- using the most recent one
freshest: sde1
md: kicking non-fresh sdd1 from array!
unbind<sdd1,4>
export_rdev(sdd1)
md: kicking non-fresh sdc1 from array!
unbind<sdc1,3>
export_rdev(sdc1)
md: kicking non-fresh sdb1 from array!
unbind<sdb1,2>
export_rdev(sdb1)
md: kicking non-fresh sda1 from array!
unbind<sda1,1>
export_rdev(sda1)
md0: removing former faulty sda1!
md0: removing former faulty sdb1!
md0: removing former faulty sdc1!
md0: removing former faulty sdd1!
md0: kicking faulty sde1!
unbind<sde1,0>
export_rdev(sde1)
md: md0: raid array is not clean -- starting background reconstruction
raid5 personality registered
md0: max total readahead window set to 1536k
md0: 3 data-disks, max readahead per data-disk: 512k
raid5: not enough operational devices for md0 (4/4 failed)
RAID5 conf printout:
 --- rd:4 wd:0 fd:4
 disk 0, s:0, o:0, n:0 rd:0 us:1 dev:[dev 00:00]
 disk 1, s:0, o:0, n:1 rd:1 us:1 dev:[dev 00:00]
 disk 2, s:0, o:0, n:2 rd:2 us:1 dev:[dev 00:00]
 disk 3, s:0, o:0, n:3 rd:3 us:1 dev:[dev 00:00]
 disk 4, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 5, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 6, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 7, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 8, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 9, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 10, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 11, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]

raid5: failed to run raid set md0
pers->run() failed ...
do_md_run() returned -22
... autorun DONE.

-----end of dmesg--------

My /etc/raidtab is :
# more /etc/raidtab
raiddev /dev/md0
        raid-level              5
        nr-raid-disks   4
        nr-spare-disks  1
        persistent-superblock   1
        parity-algorithm                left-symmetric
        chunk-size              128
        device                  /dev/sda1
        raid-disk               0
        device                  /dev/sdb1
        raid-disk               1
        device                  /dev/sdc1
        raid-disk               2
        device                  /dev/sdd1
        raid-disk               3
        device                  /dev/sde1
        spare-disk              0

I checked all my physical devices with the scsi diagnostic tool from
Adaptec => no error !

I'm in trouble because All my device was in F flag (failure ???) in the
same time.
My adapter look good.

I already check on the web some HOW-TO and other cookbook. They talk
about a 
mkraid command option --only-superblock or --force-resync but I haven't
this option.

I installed mdadm  
# mdadm -V
mdadm - v1.2.0 - 13 Mar 2003

But I can't (or I don't understand how to) use safely for data.

Can someone help me?

Thank in advance

Nico

-- 
L'equipe du Service Informatique Recherche
Universite de Cergy-Pontoise
http://www.cdc.u-cergy.fr
