From: David Mitchell <mr.david.mitchell@gmail.com>
Subject: Re: Superblock Missing
Date: Sun, 3 Sep 2017 23:35:25 -0400
Message-ID: <CAANkkp+DVzhPHEtMhmagSSO+J9cF3YwENADqCqBdXphsFE+Pmg@mail.gmail.com>
References: <CAANkkp+3WwZvKu60LkU_0VpxZvZuNrrE=qDt=4DPc80AO+sgEg@mail.gmail.com>
 <20170902014333.GA26507@metamorpher.de> <CAANkkpK6jeFKr-Tz2Fzq-CTey0GJRmERy0W+DBHMVJct2JYfUQ@mail.gmail.com>
 <20170902164906.GA6823@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170902164906.GA6823@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Let me provide a more detailed history:

Original array 4 drive 2TB Raid 5 array created back in 2012. Over the
years as drives failed, I replaced the 2 of the 2 TB drives with 4TB
drives, so I had two 4TB  and two 2TB drives providing a 6TB usable
array.  (2x4 - P)

About a month ago I put a third 4TB drive in, and a "grow"  from four
drives to three 4TB drives still in a Raid 5.

Once down to three drives, I then grew to the max size.  Everything
worked perfectly, I had 8TB of usable raid 5 with 3 drives.  The file
system passed a e2fsck no problem.   Ran for about 2 weeks, with
absolutely no problems.

With a spare 2TB drive sitting on my desk, I decided to remove my 1tb
OS drive and put in the 2TB drive as the OS drive.  Not to mess up the
array I made sure to zap the UUID, repartition, reformat, etc.  Copied
the files from my 1TB OS drive to the "new" 2TB OS drive via a live
USB key.

Rebooted, ran into grub issues.  Tried to reinstall grub from a live
USB, but was unable to make it work.  I rebooted then did a new Mint
install on the 2TB drive using LVM for the first time.   I was
extremely careful NOT to touch any of 4TB drives in the array during
the install.  The system rebooted and the new OS worked fine.   I did
not start up the array.  I commented out the array in fstab and
mdadm.conf

I then copied my old files from the 1TB drive over to the new 2TB
drive with the exception of the kernel and initrd.  Rebooted and
everything seemed to work ok with my old files.   I went to assemble
and mount the array, specifying the drives.  I would not assemble.
I wasn't sure if using LVM for the first time on my boot drive, but
not my array was the problem.    What I forgot is I booted to the new
kernel and the old image, and the raid456 module wasn't loading.   I
updated the kernel and modules, and rebooted.    The raid456 was now
loading fine, but the array would not load and mount.  Complained
about superblock.  To rule out the LVM issue and kernel I reverted
back to the old 1TB OS drive, so there would be no changes.

The array still would not assemble.  Raid456 did load correctly.  I
looked at all the array logs and everything seemed clean.   The
timestamps on each of the three 4TB raid drives all matched.   There
were no apparent errors, but the array would not assemble.  I really
do NOT remember running the  --create command.  What did work was the
force command:

mdadm --stop /dev/md0
mdadm --assemble --force /dev/md0 /dev/sdc1 /dev/sdd1 /dev/sde1

The array instantly loaded and went into a sync.  I let the sync
complete overnight.    The file system on the raid array seems to be
gone.

I'm looking for any hints on how I might get it back.

The array loads fine, but when I attempted to mount the array, it
complains about not finding the file system

 #mount: wrong fs type, bad option, bad superblock on /dev/md0,
       missing codepage or helper program, or other error

As a troubleshooting step I ran testdisk to see if that might recover
anything.  It doesn't find a partition on /dev/md0, but it did find a
few old floppy image files I had on the array leading me to believe
the data is there.

As a troubleshooting step I ran recoverjpeg  which did find picture
files.  The first time I ran it it showed a bunch of smaller pictures
and they seemed to be fine.   I stopped it an searched only for
pictures above 512k.    The pictures over 512k don't display
correctly.  It only shows part of the pictures.  I'm still searching
the array for other pictures.

At this point I'm hoping for help on next steps in
recovery/troubleshooting.    I'm on the raid mailing list rather than
the file system mailing list because I'm assuming that something got
changed when I forced assembly.   That perhaps the array is not
presenting the filesystem correctly.   Not sure if LDM had anything to
do with this?   At some point from the array metadata version changed.
  I think this was necessary as I moved from 2TB to 4TB disks.

Below is some history out of the mdadm.conf.  It may be missing lines
and steps because of the OS drive swaps, etc.

I've commented these out over time.  The /dev/md/1 occurred after the
OS reinstall.   I also see the UUID changed.  I don't know whether or
not when I changed out the hard drives this caused the UUID's to
change?   Or if the OS installation changed the UUID's. Or if
somewhere along the way I ran a create.  I really don't remember doing
a --create.  Is the change in UUID's the smoking gun that a --create
was done and my data is gone?

mdadm.conf:
# This file was auto-generated on Sun, 06 May 2012 22:55:33 -0400
# by mkconf $Id$
#ARRAY /dev/md0 metadata=0.90 UUID=f5a6ec06:b292289b:1fd984af:668516de
  (original)
#ARRAY /dev/md/1 UUID=3b6899af:93e8cd0b:18b63448:ef8ab23c
           (after OS reinstall?)
#ARRAY /dev/md0 UUID=3b6899af:93e8cd0b:18b63448:ef8ab23c
#ARRAY /dev/md0 metadata=1.2 name=virtual:1
UUID=3b6899af:93e8cd0b:18b63448:ef8ab23c



# blkid
/dev/sda1: UUID="119f7409-bb57-4c82-a526-286a639779d6" TYPE="ext4"
PARTUUID="3b337c94-01"
/dev/sda5: UUID="f2217412-d4d6-4a6e-b699-7f2978db9423" TYPE="swap"
PARTUUID="3b337c94-05"
/dev/sdb1: UUID="f155bd77-8924-400c-bab4-04b641338282" TYPE="ext4"
PARTUUID="40303808-01"
/dev/sdc1: UUID="964fd303-748b-8f0e-58f3-84ce3fde97cc"
UUID_SUB="77580f12-adf8-8476-d9c1-448bb041443f" LABEL="virtual:0"
TYPE="linux_raid_member" PARTLABEL="Linux RAID"
PARTUUID="6744510f-2263-4956-8d1f-539edcf598fb"
/dev/sdd1: UUID="964fd303-748b-8f0e-58f3-84ce3fde97cc"
UUID_SUB="1cb11ccc-2aeb-095d-6be1-838b7d7b33b7" LABEL="virtual:0"
TYPE="linux_raid_member" PARTLABEL="Linux RAID"
PARTUUID="6744510f-2263-4956-8d1f-539edcf598fb"
/dev/sde1: UUID="964fd303-748b-8f0e-58f3-84ce3fde97cc"
UUID_SUB="c322a4fb-ec99-f835-0ce9-cb45ce6b376d" LABEL="virtual:0"
TYPE="linux_raid_member" PARTLABEL="Linux RAID"
PARTUUID="6744510f-2263-4956-8d1f-539edcf598fb"

As a further troubleshooting step I recently updated to mdadm 4.0

Sincerely,

David Mitchell


On Sat, Sep 2, 2017 at 12:49 PM, Andreas Klauer
<Andreas.Klauer@metamorpher.de> wrote:
> On Sat, Sep 02, 2017 at 11:43:49AM -0400, David Mitchell wrote:
>> Sorry I'm still confused.
>> While the array seems alive, the filesystem seems to be missing?
>
> Hello David,
>
> I'm the one who is confused here.
>
> You posted to the raid mailing list about a superblock, and you even
> posted the mdadm command and error message to go along with it.
> How did it turn into a filesystem problem now? In your last mail,
> I did not see that at all.
>
> This was what you posted and I thought you were referring to:
>
>> # mdadm --examine /dev/md0
>> mdadm: No md superblock detected on /dev/md0.
>
> And thus that was the part I referred to in my answer.
>
> ----
>
>> # mdadm --detail /dev/md*
>> /dev/md0:
>>         Version : 1.2
>>   Creation Time : Sat Aug 26 16:21:20 2017
>>      Raid Level : raid5
>
> So according to this, your RAID was created about a week ago.
>
> You did write that you just migrated to 4TB drives. There are various ways
> to go about that, making a new RAID and copying stuff over from the
> old one is not unusual. So this creation time might be perfectly normal.
>
> Of course if this migration happened more than one week ago then I can
> only assume you used mdadm --create to fix some RAID issue or other?
>
> mdadm --create is like mkfs: you don't expect data to exist afterwards.
> For mdadm --create to retain data you have to get all settings perfectly
> right and those settings change depending on when you originally created
> it and what you did with it since (e.g. mdadm --grow might change offsets).
>
> I'm not sure how to help you because nothing in your mails explains
> how this issue came about.
>
> There are previous discussions on this list about botched mdadm --create,
> wrong data offsets, and searching for correct filesystem offsets.
>
> Whatever you do, don't write on these drives while looking for lost data.
>
> Regards
> Andreas Klauer
