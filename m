From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Building my first software raid
Date: Sat, 10 Apr 2004 00:26:40 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0404092356160.12357@lion.drogon.net>
References: <00e201c41e7c$b40ee6f0$6405a8c0@a30>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <00e201c41e7c$b40ee6f0$6405a8c0@a30>
To: me@heyjay.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 9 Apr 2004 me@heyjay.com wrote:

> Hi,
>
> I've read all the linux raid how-tos, and thought I was ready to take the
> plunge on implementing software raid.  I've got a fresh install of Debian
> Sarge, 2 disks.  3 partitions (/boot, /, swap).  So I installed Sarge,
> partitioned hda during the installer with regular partitions:
>
> abba:/usr/src# sfdisk -l /dev/hda
>
> Disk /dev/hda: 2491 cylinders, 255 heads, 63 sectors/track
> Units = cylinders of 8225280 bytes, blocks of 1024 bytes, counting from 0
>
>    Device Boot Start     End   #cyls    #blocks   Id  System
> /dev/hda1   *      0+     11      12-     96358+  83  Linux
> /dev/hda2         12     133     122     979965   82  Linux swap
> /dev/hda3        134    1957    1824   14651280   83  Linux
> /dev/hda4          0       -       0          0    0  Empty
>
> I wanted to do a raid 1.  So, then I went and partitioned hdc like:
>
> abba:/usr/src# sfdisk -l /dev/hdc
>
> Disk /dev/hdc: 1870 cylinders, 255 heads, 63 sectors/track
> Units = cylinders of 8225280 bytes, blocks of 1024 bytes, counting from 0
>
>    Device Boot Start     End   #cyls    #blocks   Id  System
> /dev/hdc1   *      0+     12      13-    104391   fd  Linux raid autodetect
> /dev/hdc2         13     137     125    1004062+  fd  Linux raid autodetect
> /dev/hdc3        138    1756    1619   13004617+  fd  Linux raid autodetect
> /dev/hdc4          0       -       0          0    0  Empty
>
> So now I'd build my raid set:
>
> abba:/usr/src# mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/hda1
> /dev/hdc1
> mdadm: /dev/hda1 appears to contain an ext2fs file system
>     size=96358K  mtime=Thu Apr  8 12:50:04 2004
> mdadm: /dev/hdc1 appears to contain an ext2fs file system
>     size=96358K  mtime=Wed Dec 31 18:00:00 1969
> mdadm: largest drive (/dev/hdc1) exceed size (96256K) by more than 1%
> Continue creating array? n
> mdadm: create aborted.
>
> I've google for that "mdadm: largest drive...than 1%" error with no results
>
> Any help?

Firtly I don't use madm, so no direct help there, but I suspect you built
the system onto hda then tried to incorporate hdc ... This won't work as
it'll potentially overwrite the partitions as it builds the raid1 set. (as
far as I'm aware - I think theres some runnery you can do to do with
marking the new drive as failed, but I've never tried it)

(I suspect your 1% error is madm complaining because you are going to lose
more than 1% of your disk space - for raid1, the opposing partitions
really need to be the same size, but AIUI the raid partition will be
created the size of the smallest partition)


It's a royal PITA with Debian, but this is how I do it:

Starting with 2 identical disks:

Install a bare minimal system onto hda parition as follows:

  /	256M
  swap	2 x RAM
  /usr	2GB
  /var	Rest of disk.

(You don't need a /boot - thats only for older BIOSes which can't boot
from cylinders > 1024)

Once you have installed a bare minimal Debian onto /dev/hda, then
partition /dev/hdc as close to hda as possible.

Then the fun starts: unswap /dev/hda2 (and edit it out of /etc/fstab), and
use whatever to create a raid1 as /dev/md1 using /dev/hda2 and /dev/hdc2.
I use /etc/raidtab and mkraid, but you might want to use madm. Manually
mkfs this, then mount it under /mnt and copy / into it, as per the HowTo.
(cd / ; find . -xdev | cpio -pm /mnt) Then you need to edit /mnt/etc/fstab
to make it show that / is under /dev/md1, edit /mnt/etc/lilo.conf to have
the right runes in it (raid-extra-boot, etc.)  then run lilo -r /mnt.

Run cfdisk (or whatever) to change the partition types to 0xfd and reboot.

With a bit of luck you'll now have root mounted under /dev/md1 with no
swap, and /usr and /var under /dev/hda3 and /dev/hda4 respectively.

Use the same procedure now to create md0 from /dev/hda1 and /dev/hdc1
and mkfs it, mount it under /mnt and copy root back to it. Remember to
edit /mnt/etc/fstab (/ is now under /dev/md0) and the new lilo.conf and
re-run lilo, set the partition types on /dev/hda1, hdc1 to 0xfd and
reboot.

Now you have /dev/md0 which is root, /dev/md1 which is unused (it will
become swap later on) and /dev/hda3 -> /usr and /dev/hda4 -> /var.

Next step is to copy /usr into /dev/md1, so re-mkfs /dev/md1, mount it
under /mnt, and do the same cd /usr ; find . -xdev | cpio -pm /mnt trick
as before, adjust /etc/fstab to mount /usr from /dev/md1 and reboot.

Now use madm or whatever to create a raid1 (as /dev/md2) from /dev/hda3
and /dev/hdc3 and mkfs it. (don't forget to change the partition type to
0xfd) Guess what comes next ;-) Copy /usr currently under /dev/md1 into
/dev/md2. Edit /etc/fstab and reboot.

Do the same trick finally for /var - copy it into md1, adjust /etc/fstab,
reboot, create /dev/md4, copy it back again, adjust/etc/fstab, reboot,
and finally, mkswap /dev/md1 and swapon /dev/md1 and put that back into
/etc/fstab.

Then go back into dselect (or tasksel) and finish off installing the
packages, etc. you need.

You end up wih something like:

Filesystem            Size  Used Avail Use% Mounted on
/dev/md0              235M   31M  193M  14% /
/dev/md2              1.9G  1.5G  335M  82% /usr
/dev/md3               30G  6.9G   21G  24% /var
/dev/md4               42G   24G   16G  58% /archive

and

lion:/# cat /proc/swaps
Filename                        Type            Size    Used    Priority
/dev/md1                        partition       995896  59092   -1

This is pair of 80GB disks and I have an extra partition here (which
started life empty, so didn't need a copy/shunt about thing)

Hopefully the next release of Debian will include raid from the install
CD... It's otherwise a real PITA to install, but worth it at the end of
the day!

Good luck...

Gordon
