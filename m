From: "Tim Harvey" <tharvey@alumni.calpoly.edu>
Subject: Autodetection howto
Date: Tue, 15 Jun 2004 13:42:54 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000001c45319$55f03570$7001a8c0@darwin>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings,

I've got a 4-disk RAID5 array that I'm able to manually assemble and
mount, however I can't figure out how to get the autodetection to work.
In reading the Linux Software RAID howto it seems like it should 'just
work', but I'm running into a snag which doesn't seem to be described in
the HOWTO/FAQ.

The commands that I use to manually assemble and run my XFS filesystem
via LVM over RAID5 are:

# mdadm --assemble --run /dev/md0 /dev/hdb1 /dev/hdc1 /dev/hdd1
mdadm: /dev/md0 has been started with 3 drives (out of 4).
# mdadm --assemble --run /dev/md1 /dev/hdb3 /dev/hdc3 /dev/hdd3
mdadm: /dev/md1 has been started with 3 drives (out of 4).

Then for LVM:

# vgscan
# vgchange -a y
# mount -t xfs -o logdev=/dev/logdev/storage1 /dev/vgroup00/storage1
/mnt/data

Here are my log messages from bootup:

Jun 15 11:31:24 localhost kernel: md: autorun ...
Jun 15 11:31:24 localhost kernel: md: considering hdh1 ...
Jun 15 11:31:24 localhost kernel: md:  adding hdh1 ...
Jun 15 11:31:24 localhost kernel: md:  adding hdg1 ...
Jun 15 11:31:24 localhost kernel: md:  adding hdf1 ...
Jun 15 11:31:24 localhost kernel: md:  adding hde1 ...
Jun 15 11:31:24 localhost kernel: md: created md0
Jun 15 11:31:24 localhost kernel: md: bind<hde1,1>
Jun 15 11:31:24 localhost kernel: md: bind<hdf1,2>
Jun 15 11:31:24 localhost kernel: md: bind<hdg1,3>
Jun 15 11:31:24 localhost kernel: md: bind<hdh1,4>
Jun 15 11:31:25 localhost kernel: md: running: <hdh1><hdg1><hdf1><hde1>
Jun 15 11:31:25 localhost kernel: md: hdh1's event counter: 00000028
Jun 15 11:31:25 localhost kernel: md: hdg1's event counter: 00000028
Jun 15 11:31:25 localhost kernel: md: hdf1's event counter: 00000028
Jun 15 11:31:25 localhost kernel: md: hde1's event counter: 00000028
Jun 15 11:31:25 localhost kernel: kmod: failed to exec /sbin/modprobe -s
-k md-personality-4, errno = 2
Jun 15 11:31:25 localhost kernel: md: personality 4 is not loaded!
Jun 15 11:31:25 localhost kernel: md :do_md_run() returned -22
Jun 15 11:31:25 localhost kernel: md: md0 stopped.
Jun 15 11:31:25 localhost kernel: md: unbind<hdh1,3>
Jun 15 11:31:25 localhost kernel: md: export_rdev(hdh1)
Jun 15 11:31:25 localhost kernel: md: unbind<hdg1,2>
Jun 15 11:31:25 localhost kernel: md: export_rdev(hdg1)
Jun 15 11:31:25 localhost kernel: md: unbind<hdf1,1>
Jun 15 11:31:25 localhost kernel: md: export_rdev(hdf1)
Jun 15 11:31:25 localhost kernel: md: unbind<hde1,0>
Jun 15 11:31:25 localhost kernel: md: export_rdev(hde1)
Jun 15 11:31:25 localhost kernel: md: ... autorun DONE.

I'm not sure why I'm getting 'md: personality 4 is not loaded!', would
it be because RAID5 is loaded as a module instead of compiled into the
kernel?  I googled this and have added the following to
/etc/modules.conf and rebooted, but it did not change things:

# RAID autoload modules
alias md-personality-3 raid1
alias md-personality-4 raid5


Questions:

- How do I get around the 'personality 4 is not loaded'?  Did I need to
run something after I modified /etc/modules.conf for it to take effect?
- It would appear that the mounting of filesystems via /etc/fstab occurs
before md autoscans.  How can I delay the mounting of the filesystem
that exists on the RAID5 array?

Thanks for any help!

Tim

