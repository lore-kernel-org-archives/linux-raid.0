From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Re: 3-way mirror to RAID-6
Date: Mon, 8 Jan 2018 12:34:42 +0100
Message-ID: <CAJH6TXj-6hyq2BM4GF0YdYQ27DAembZY0cLUt+BZKo+YySfGOw@mail.gmail.com>
References: <CAJH6TXg=uCQMmzSQPHC885naZj3cFOZx2oyx462mCBof9NeU+w@mail.gmail.com>
 <87incu79uw.fsf@notabene.neil.brown.name> <CAJH6TXh_u08K+w-na_YQDh0WZWOQ8o14=SEzQmwPVrGPbkWasA@mail.gmail.com>
 <063586b9-6b63-9afe-9edc-dd3a73adf1b4@turmel.org> <CAJH6TXiqsd=Zs4t5qAEe19shJFgSAZ1W-95yT041H6OyLbKvfA@mail.gmail.com>
 <1f497643-0ad1-5037-207a-9c999dc79ccd@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1f497643-0ad1-5037-207a-9c999dc79ccd@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: NeilBrown <neilb@suse.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2017-12-28 13:34 GMT+01:00 Phil Turmel <philip@turmel.org>:
> I've never put a mail archive on raid6.  I'd be concerned.  It's
> basically a random access workload with small reads and writes.  That is
> a recipe that'll maximize the write-amplification slowdown of raid6.

Ok, just to stay on the safety side, this is the current 3-way raid1:

# mdadm --detail /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Mon Jul 25 12:55:48 2016
     Raid Level : raid1
     Array Size : 488382841 (465.76 GiB 500.10 GB)
  Used Dev Size : 488382841 (465.76 GiB 500.10 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Mon Jan  8 12:26:43 2018
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

           Name : mail:0  (local to host mail)
           UUID : b2a5ed53:42890b73:dc6de22a:1ac12524
         Events : 30658

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1



# pvs
  PV         VG   Fmt  Attr PSize   PFree
  /dev/md0   vg1  lvm2 a-   465,76g    0

# vgs
  VG   #PV #LV #SN Attr   VSize   VFree
  vg1    1   6   0 wz--n- 465,76g    0


# lvs
  LV         VG   Attr   LSize   Origin Snap%  Move Log Copy%  Convert
  lv_dovecot vg1  -wi-ao  10,00g
  lv_log     vg1  -wi-ao  15,00g
  lv_mail    vg1  -wi-ao 410,76g
  lv_root    vg1  -wi-ao  20,00g
  lv_swap    vg1  -wi-ao   8,00g
  lv_tmp     vg1  -wi-ao   2,00g


I want to replace all disks with 2TB SAS disks.

So, which is the best procedure to follow to increse the total usable
space, without loosing redundancy while the system is running ?

I would like to have some confirms from skilled users in this ML.
On my own, i would replace one disk per time (fail+remove+add) and
wait for resync to complete, then, resize the array:

mdadm --grow /dev/md0 --bitmap none
mdadm --grow /dev/md0 --size=max

wait for it to finish

then: pvresize /dev/md0, lvresize (each LVs), resize2fs (each FS)

Is this ok ?
