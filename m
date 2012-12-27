From: Mark Knecht <markknecht@gmail.com>
Subject: md: kicking non-fresh sdf3 from array!
Date: Thu, 27 Dec 2012 10:48:30 -0800
Message-ID: <CAK2H+effDWFWP32wO4vXPSQ16tgZKdBwvQRRiq+Qpy03VCE6xA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
   I've got a home compute server with a transitional setup:

1) A completely working Gentoo build where root is a 3-disk RAID1
(md126) using metadata-0.9 and no initramfs. It boots, works and is
where I'm writing tthis email.

2) A new Gentoo build done in a chroot which has two 'config's'
  2a) RAID6 using gentoo-sources-3.2.1 with a separate initramfs. This
works, or did an hour ago.
  2b) RAID6 using gentoo-sources-3.6.11 with the initramfs built into
the kernel. This failed its first boot.

I attempted to boot config 2b above but it hung somewhere in the mdadm
stuff. I didn't think of trying the magic keys stuff and hit reset.
Following the failure I booted back into config 1 and saw the
following messages in dmesg:


[    7.313458] md: kicking non-fresh sdf3 from array!
[    7.313461] md: unbind<sdf3>
[    7.329149] md: export_rdev(sdf3)
[    7.329688] md/raid:md3: device sdc3 operational as raid disk 1
[    7.329690] md/raid:md3: device sdd3 operational as raid disk 2
[    7.329691] md/raid:md3: device sdb3 operational as raid disk 0
[    7.329693] md/raid:md3: device sde3 operational as raid disk 3
[    7.329914] md/raid:md3: allocated 5352kB
[    7.329929] md/raid:md3: raid level 6 active with 4 out of 5
devices, algorithm 2

and mdstat tells me that md3, which is root for 2a & 2b above is dirty:

mark@c2stable ~ $ cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md6 : active raid5 sdc6[1] sdd6[2] sdb6[0]
      494833664 blocks super 1.1 level 5, 64k chunk, algorithm 2 [3/3] [UUU]

md3 : active raid6 sdc3[1] sdd3[2] sdb3[0] sde3[3]
      157305168 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/4] [UUUU_]

md7 : active raid6 sdc7[1] sdd7[2] sdb7[0] sde2[3] sdf2[4]
      395387904 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5] [UUUUU]

md126 : active raid1 sdd5[2] sdc5[1] sdb5[0]
      52436032 blocks [3/3] [UUU]

unused devices: <none>
mark@c2stable ~ $


I'd like to check that the following commands would be the recommended
way to get the RAID6 back into a good state.

/sbin/mdadm /dev/md3 --fail /dev/sdf3 --remove /dev/sdf3
/sbin/mdadm /dev/md3 --add /dev/sdf3


My overall goal here is to move the machine to config 2b  with / on
RAID6 and then eventually delete config 1 to reclaim disk space. This
machine has been my RAID learning vehicle where I started with RAID1
and then added as I went along.

I'll have to study why the config 2b failed to boot but first I want
to get everything back in good shape.

Thanks in advance,
Mark
