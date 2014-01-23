From: Nate Dailey <nate.dailey@stratus.com>
Subject: LVM raid1 mirror: interrupted resync isn't handled well
Date: Wed, 22 Jan 2014 19:40:08 -0500
Message-ID: <52E064E8.2000209@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, looking for some guidance as to whether or not this is expected to 
work, and if I'm doing anything wrong or can make any changes to fix 
this. (I tried posting on linux-lvm, but didn't get anywhere)

I've found that if LVM raid1 resync is interrupted, the volume 
immediately comes up in sync when next activated, without actually 
copying the remainder of the data. This doesn't happen on the initial 
resync when the mirror is created; it happens on a resync after a disk 
pull/insert.

I've reproduced this several times on a system with the root FS on an 
LVM raid1 (note, this is not LVM on top of a separate MD raid1 device, 
it's an LVM raid1 mirror created with 'lvconvert -m1 --type raid1 ...'):

- remove a disk containing one leg of an LVM raid1 mirror
- do enough IO that a lengthy resync will be required
- shutdown
- insert the removed disk
- reboot
- on reboot, the volume is resyncing properly
- before resync completes, reboot again
- this time during boot, the volume is activated and no resync is performed

But here's an example showing the same thing happening with just a 
volume deactivate/activate:

# lvs
   LV                                                   VG      Attr 
    LSize  Pool Origin Data%  Move Log Cpy%Sync Convert
...
   testlv 
testvg rwi-a-r---  5.00g                                 4.84

# lvchange -an /dev/testvg/testlv

# lvchange -ay /dev/testvg/testlv

# lvs
   LV                                                              VG 
    Attr       LSize  Pool Origin Data%  Move Log Cpy%Sync Convert
...
   testlv 
testvg rwi-a-r---  5.00g                               100.00

Here's dmesg showing the start of resync:

md/raid1:mdX: active with 1 out of 2 mirrors
created bitmap (5 pages) for device mdX
mdX: bitmap initialized from disk: read 1 pages, set 4524 of 10240 bits
RAID1 conf printout:
  --- wd:1 rd:2
  disk 0, wo:0, o:1, dev:dm-18
  disk 1, wo:1, o:1, dev:dm-20
RAID1 conf printout:
  --- wd:1 rd:2
  disk 0, wo:0, o:1, dev:dm-18
  disk 1, wo:1, o:1, dev:dm-20
md: recovery of RAID array mdX
md: minimum _guaranteed_  speed: 4000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 15000 
KB/sec) for recovery.
md: using 128k window, over a total of 5242880k.

And the interrupted sync:

md: md_do_sync() got signal ... exiting

And the reactivation without resuming resync:

md/raid1:mdX: active with 2 out of 2 mirrors
created bitmap (5 pages) for device mdX
mdX: bitmap initialized from disk: read 1 pages, set 3938 of 10240 bits


This is the lvm version (though I also grabbed the latest lvm2 from 
git.fedorahosted.org and had the same problem):

   LVM version:     2.02.100(2)-RHEL6 (2013-09-12)
   Library version: 1.02.79-RHEL6 (2013-09-12)
   Driver version:  4.23.6

This was on CentOS 6.4. I also reproduced it on Ubuntu 13.10, haven't 
tried anything newer.

Can anyone offer any advice? Thanks!

Nate Dailey
Stratus Technologies
