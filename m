From: gelma <dislessico@gmail.com>
Subject: to be or not to be...
Date: Sun, 23 Apr 2006 14:58:36 +0200
Message-ID: <20060423125836.GB6081@gelma.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,
	to make a long story very very shorty:
	a) I create /dev/md1, kernel latest rc-2-git4 and mdadm-2.4.1.tgz,
	   with this command:
	   /root/mdadm -Cv /dev/.static/dev/.static/dev/.static/dev/md1 --bitmap-chunk=1024 --chunk=256 --assume-clean --bitmap=internal -l5 -n5 /dev/hda2 /dev/hdb2 /dev/hde2 /dev/hdf2 missing
	
	b) dm-encrypt /dev/md1
	
	c) create fs with:
	   mkfs.ext3 -O dir_index -L 'tritone' -i 256000 /dev/mapper/raidone
	
	d) export it via nfs (mounting /dev/mapper/raidone as ext2)

	e) start to cp-ing files

	f) after 1 TB of written data, with no problem/warning, one of the
	not-in-raid-array HD freeze

	g) reboot, check with:
	   fsck -C -D -y /dev/mapper/raidone
	   
	   a) first run: lot of strange errors report about impossible
	   i_size values, duplicated blocks, and so on, but it ends without
	   complain, saying everything is fixed.
	   b) mount it (as ext3), everything, at first glance, seems good
	   (I will check checksum tomorrow) as
	   number/size/filename/directory place of files. In /lost+found
	   some files, but nothing "real". I mean, special files/devices,
	   that never were on that fs, with giga/tera size (holes, of
	   course), with chattr bits randomly setted.
	   when I try to remove them I've got a kernel complain about
	   offset in dir /lost+found.
	   c) fsck again, after everything is fine

	Now the cloning from old storage is going on, and now I'm wondering
	if "--assume-clean" could be the reason of what happens.
	btw, hardware passed usual test (memtest, cpuburn, ecc).

thanks a lot for your time and sorry for my terrible english,
gelma
