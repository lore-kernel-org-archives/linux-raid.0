From: "Mike Garey" <random51k@gmail.com>
Subject: Re: Can't mount /dev/md0 after stopping a synchronization
Date: Tue, 4 Apr 2006 23:45:33 -0400
Message-ID: <c79e949d0604042045w2fb901c2rfb4c00984f6b8761@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Just wanted to add a few more details/questions to my previous post..

In case I provided too much information in my previous email, here's a
condensed version:

1) got to "step 6.2 Add the first-disk to our existing RAID device" of
the rootraiddoc walkthrough
2) issued command "mdadm --add /dev/md0 /dev/hda1"
3) after getting terrible throughput, decided to stop the
synchronization process and reboot
4) failed to reboot from /dev/md0 (hdc1)
5) hda1 is now hosed, hdc1 contains a complete working copy of the
previous contents of /dev/hda1, but I'm unable to boot from it
("ALERT! /dev/md0 does not exist" message)
6) re-installed debian onto hda1 and rebooted from it.

Now, it seems as though I'm sort of back at "step 3.3 Create RAID
device".  I've tried to do the following while booted from my clean
debian install on /dev/hda1:

mkdir /mnt/md0
mount /dev/md0 /mnt/md0

but I get the message "mount: you must specify the filesystem type",
because I guess the system has no idea what /dev/md0 is.  So then I
tried the following (possibly risky?) command:

mdadm --create /dev/md0 --level=1 --raid-disks=2 --spare-devices 0
missing /dev/hdc1

but I get the message:

mdadm: /dev/hdc1 appears to contain an ext2fs file system
    size=158577472K  mtime=Tue Apr  4 18:21:09 2006
mdadm: /dev/hdc1 appears to be part of a raid array:
    level=1 devices=2 ctime=Mon Apr  3 13:41:33 2006
Continue creating array? n
mdadm: create aborted

It seems from the above message that mdadm --create would destroy all
the data on /dev/hdc1 (someone correct me if I'm wrong), rather than
simply creating /dev/md0.  If this is the case, should I be using
mdadm --assemble instead? (but if so, I need to assemble to a
pre-existing md device, in which case I don't have one)  What I'd like
to do is be able to mount /dev/hdc1 as /dev/md0 (as in "step 4.2 Mount
your RAID device."), and then hopefully be able to boot off of it, but
right now I'm confused about how to create /dev/md0 without destroying
any of my information on either /dev/hda1 or /dev/hdc1 (of course,
after the reboot, I don't mind destroying /dev/hda1).

the other alternative is of course to zero the superblocks on
/dev/hdc1, reboot from it as a normal drive, and then follow the
walkthrough from the beginning, but this time starting with /dev/hdc1
as the master drive.  I'd like to avoid this if possible, since I'd
really like to find out why I can't boot from /dev/md0 (hdc1), since
if this was not a test, and /dev/hda1 really did fail, I'd be in a
mess.  So I'd prefer to know how to recover from this, since it seems
that the position I'm in right now is essentiallly the same scenario
as if /dev/hda1 had failed, in which case I'd like to be prepared.

If anyone can make heads or tails of what I'm talking about, I would
greatly appreciate any information or suggestions.  Thanks in advance,

Mike

P.S. output of mdadm --examine is given below (output is the same for
/dev/hda1 and /dev/hdc1)

          Magic : a92b4efc
        Version : 00.90.03
           UUID : f1ab0f6d:6c5c4bf6:228dec79:3aa3582f
  Creation Time : Mon Apr  3 13:41:33 2006
     Raid Level : raid1
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Tue Apr  4 09:37:10 2006
          State : clean
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1
       Checksum : f63c0eb5 - correct
         Events : 0.19314


      Number   Major   Minor   RaidDevice State
this     1      22        1        1      active sync   /dev/hdc1

   0     0       0        0        0      removed
   1     1      22        1        1      active sync   /dev/hdc1
   2     2       3        1        2      spare   /dev/hda1


> I'm in the process of setting up a software RAID level 1 on debian
> testing with two 160 gig drives on an Asus P4P800 motherboard with
> Intel Pentium 4 CPU 3.00GHz and 512 megs of RAM.  I've been following
> the instructions in /usr/share/doc/mdadm/rootraiddoc97.html, but after
> rebooting to /dev/hdc1 (/dev/md0) and issuing the command "mdadm --add
> /dev/md0 /dev/hda1", I was only getting 1636K/sec for the
> synchronization, which was _way_ too slow (I forgot I had left a CDROM
> drive on the secondary IDE channel, so /dev/hdc1 was running at UDMA2,
> plus, I was using a 40 conductor cable instead of 80).  So I decided
> to reboot the system and cancel the synchronization, thus destroying
> everything on /dev/hda1 (but this didn't seem like an issue, since I
> was able to boot from /dev/md0 aka /dev/hdc1).
>
> So after stopping the sync process and rebooting, I was unable to boot
> from hdc1 because I had forgotten to copy over my initrd with md/raid1
> modules from /dev/hda1 to /dev/hdc1, and of course now /dev/hda1 is
> destroyed, so I can't use the initrd-RAID that was previously on there
> (and the initrd-RAID never existed on /dev/hdc1, since I created it on
> /dev/hda1 _after_ I had issued the "mount /dev/md0 /mnt/md0; cp -axu /
> /mnt/md0" commands - don't ask why).  So when I rebooted, I didn't
> have md/raid1 support, and so /dev/md0 couldn't mount.. I ended up
> building a new initrd with md/raid1 on another debian box, then
> copying them to /dev/hdc1.  I've now tried installing grub on
> /dev/hdc, disconnected /dev/hda, and attempted to boot.  I now get the
> following message:
>
> md: md driver 0.90.3 MAX_MD_DEVS=3D256, MD_SB_DISKS=3D27
> md: bitmap version 4.39
> md: raid1 personality registered as nr3
> .
> .
> Begin: Mounting root file system...
> Begin: Running /scripts/local-top
> Done.
> ALERT! /dev/md0 does not exist.  Dropping to a shell!
>
> At which point I get dropped into busybox..  One thing I notice is
> that although it shows the md module being loaded, it doesn't really
> say anything about configuring/adding any RAID disks (which is used to
> say, back when I had first booted into /dev/md0 (hdc1) before killing
> /dev/hda1).  So now apparently /dev/md0 no longer exists, and I have
> no idea how to create it.
>
> In fstab on /dev/hcd1, I have:
>
> /dev/md0 / ext3 defaults 0 0
>
> and in /boot/grub/menu.lst I have:
>
> title           Debian GNU/Linux, kernel 2.6.15-486 RAID
> root            (hd0,0)
> kernel          /boot/vmlinuz-2.6.15-486 root=3D/dev/md0 ro
> initrd          /boot/initrd.img-2.6.15-486-RAID
> savedefault
> boot
>
> Now, /dev/md0 was originally created by using:
>
> mdadm --create /dev/md0 --level=3D1 --raid-disks=3D2 missing /dev/hdc1
>
> can anybody tell me why /dev/md0 is no longer available on /dev/hdc1,
> and if possible how to recreate it?
>
> I should mention that after I cancelled the synchronization process,
> and was unable to reboot into /dev/hdc1, I then mounted /dev/hdc1
> through busybox, changed the Type of the disk from FD (linux raid) to
> 83 (linux), modified /etc/fstab and /boot/grub/menu.lst so it pointed
> to /dev/hdc1 instead of /dev/md0.  I tried rebooting after changing
> these options, and it gave me a message saying "Failed to mount root
> file system" or something to that effect. Could changing the Type of
> the disk or mounting /dev/hdc1 have caused /dev/md0 to become
> corrupted/deleted?
>
> If anybody has the time to read through my message
> and give me some advice, I would very much appreciate it.  Thanks,
>
> Mike
