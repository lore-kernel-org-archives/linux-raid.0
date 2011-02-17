From: Gavin Flower <gavinflower@yahoo.com>
Subject: Re: physical size of the device inconsistent with superblock, after RAID problems
Date: Thu, 17 Feb 2011 15:53:11 -0800 (PST)
Message-ID: <122234.22513.qm@web65103.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: ext3-users@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

My attempted post to ext3-users@redhat.com, had not been published ther=
e (even though I had emailed it 4 days ago!), as at a minute ago.

I finally bit the bullet and went ahead.

I accepted the fixes put forward by fsck associated with bitmap differe=
nces, and rebooted.

Still problems.

Still had the discrepancy in the file size.=A0 So I ran the command:

resize2fs -p /dev/md1 76799616

I used the smaller of the 2 block counts, as:
(a) I needed to reduce the file system size, because I had already redu=
ced the RAID size (I _SHOULD_ have done this first, before resizing the=
 RAID), and
(b) it is reported as the 'physical' size of the device, so it is likel=
y to be the correct value IMHO

The system the came up successfully after a reboot, and I was able to l=
og in as normal.

There appeared to be no apparent loss of data, not that I did an exhaus=
tive systematic check. However, several users have logged on successful=
ly, and it is playing its part as gateway to the Internet, and squid ap=
pears to be providing its normal functionality.

Neil, your help and encouragement was/is greatly appreciated!


Thanks,
Gavin
--

All Adults share the Responsibility
to help Raise Today's Children,
for they are Tomorrow's Society!

--- On Tue, 15/2/11, Gavin Flower <gavinflower@yahoo.com> wrote:

=46rom: Gavin Flower <gavinflower@yahoo.com>
Subject: physical size of the device inconsistent with superblock, afte=
r RAID problems
To: ext3-users@redhat.com
Cc: neilb@suse.de, linux-raid@vger.kernel.org
Date: Tuesday, 15 February, 2011, 16:14

Hi,

I would appreciate advice recovering from the following situation, afte=
r an aborted mdadm resizing operation and subsequent recovery actions:

/dev/md1: The filing system size (according to the superblock) is 76799=
952 blocks
The physical size of the device is 76799616
Either the superblock or the partition table is likely to be corrupt!

/dev/md1: UNEXPECTED INCONSISTENCY: RUN fsck manually
(i.e. without -a or -p options)


fsck.ext4 -f -n /dev/md1 output:

e2fsck 1.41.12 (17-May-2010)
The filesystem size (according to the superblock) is 76799952 blocks
The physical size of the device is 76799616 blocks
Either the superblock or the partition table is likely to be corrupt!
Abort? no

Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:=A0 -9626 -(9728--9752) +(405344--405369)
=46ix? no

/dev/md1: ********** WARNING: Filesystem still has errors **********

/dev/md1: 1693644/19202048 files (0.3% non-contiguous), 54273929/767999=
52 blocks


Note that original size, according mdadm, was not a multiple of 512KB, =
so I reshaped it to be the largest multiple or 512KB less than the orig=
inal size using the -size option of mdadm.=A0 So my second attempt to r=
eshape, using the 512 chunk size, started okay.=A0 The previous chunk s=
ize was 64KB.

Note I am using Fedora 14, up-to-date as of Friday February 11th, and t=
hat there are 5X500KB drives, with 3 RAID-6 arrays:
/dev/md0 swap
/dev/md1 mostly user data (the problematic one)
/dev/md2 distribution & O/S files
plus /boot on a non-RAID ext4 partition

Sequence of events:
Reshaped /dev/md1 using mdadm, without first reducing size of the ext4 =
filesystem.

The process of reshaping /dev/md1 was about 20% through when I killed i=
t.

System appeared okay.

I rebooted a few minute later, but shortly after I selected the kernel,=
 it stopped, and I dropped into a shell.

With the help of Neil Brown, I made some progress and /dev/md1 reshapin=
g appeared to have completed without error.

However, on the next reboot I got the INCONSISTENCY message.

Will it be safe to simply accept fsck's offer to fix, or are there othe=
r things I should do?


Thanks,
Gavin=20

--
All Adults share the Responsibility
to help Raise Today's Children,
for they are Tomorrow's Society!






     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
