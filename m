From: Gordon Henderson <gordon@drogon.net>
Subject: RE: RE: Unable to mount root & Problems with Woody
Date: Fri, 21 Feb 2003 11:30:30 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.43.0302211108410.16246-100000@unicorn.drogon.net>
References: <84BB6E1F4E011742AFB186D469FDEA9A015BDE@fastterminal.fasttrack.net.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84BB6E1F4E011742AFB186D469FDEA9A015BDE@fastterminal.fasttrack.net.au>
To: Lewis Shobbrook <lshobbrook@fasttrack.net.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 21 Feb 2003, Lewis Shobbrook wrote:

> Hi Gordon,
>
> I tries every trick under the sun,  cpio, cp -ax, tar, rsync...
> As soon as I updated to testing all files copied on the same drive same
> partition, same raidtab etc. etc.
> All the files copied without failure, including symlinks, which noteably
> failed with the previous 15 frustrating attempts.
>
> Hmmm.... Not sure where the problems came from,  did you format your
> /mdx using mke2fs?

Yes. When I get time I want to look at XFS, but last time I looked (about
6 weeks ago) they didn't have patches for 2.4.20, and I needed a
particular PCI-IDE card that only 2.4.19 and upwards seemed to
support )-:

> > drogon @ agate: df -h
> > Filesystem            Size  Used Avail Use% Mounted on
> > /dev/md0              235M   18M  205M   8% /
> > /dev/md1              1.9G  905M  920M  50% /usr
> > /dev/md2               35G   12G   21G  34% /var

This particular box has 2 disks all on raid1 mirrors. I started by
partitioning and installing onto 4 primary partitions, hda1, hda3 and hda4
(hda2 is swap, but only later on). Once I had the basic system installed
on the primary disk, and built a custom kernel and tested it, I used fdisk
to create an identical partition table on hdc, then made hda2 and hdc2 an
md device, mkfs'd it, mounted it under /mnt and used cpio to copy / into
it. Then changed the /mnt/etc/lilo.conf, ran lilo -r /mnt, changed
/mnt/etc/fstab (/ is now under /dev/md0!) and rebooted. Once that was OK,
I made an md device out of /dev/hda1 and /dev/hdc1 and basically reversed
the procedure to move root back onto the first partition on the disks.
then I used the now spare partition to temporarily copy /usr and /var
while turning them into md devices. It takes a long time and I wish I
could do it at install time like Red Hat does, but maybe Debian 4 might
have that in it!

I've built several like this, some with raid1 for / and raid5 for the
other partitions, depending on the number of disks installed and the
customer requirements.

I don't use a separate /boot filesystem - never quite understood that, but
my unix dealings before Linux was SunOs & Solaris...

I use the raidtools as suplied with woody - I am not using madm at all
(old habits die hard and I can hand-edit an /etc/raditab without thinking
about it)

Gordon

