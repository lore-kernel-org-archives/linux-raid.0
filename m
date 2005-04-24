From: Andre Noll <noll@mathematik.tu-darmstadt.de>
Subject: Re: raid 10 or 1+0 ?
Date: Sun, 24 Apr 2005 13:54:08 -0000
Message-ID: <slrnd6n980.r1v.noll@p133.mathematik.tu-darmstadt.de>
References: <876ef97a05042304262d0b5c3a@mail.gmail.com> <200504231621.j3NGLMm17613@www.watkins-home.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 23 Apr 2005 12:21:17 -0400 you wrote in local.lists.linux-raid:

> Maybe we need some success stories for RAID10 and RAID1+0 mounted on "/".

I have such a setup up and running for quite some time now: 

cat /proc/mdstat 
Personalities : [raid0] [raid1] 
md3 : active raid0 md1[0] md2[1]
      156247808 blocks 64k chunks
      
md2 : active raid1 hda2[0] hdk2[1]
      78123968 blocks [2/2] [UU]
      
md1 : active raid1 hdc2[0] hdg2[1]
      78123968 blocks [2/2] [UU]
      
md0 : active raid1 hdc1[2] hda1[3] hdk1[1] hdg1[0]
      49280 blocks [4/4] [UUUU]

My roottfs is on a lv. The corresponding vg is made from md3. 

This works if you do not rely on the kernel to assemble your array
but use an initrd to achieve this.

Just use something like this in your linuxrc, right after creating the
device nodes (if you use udev):

	if test -e /proc/mdstat; then
		log "scanning for multi disk devices"
		echo "DEVICE /dev/hd[a-z] /dev/sd[a-z] /dev/md[0-9]" > /etc/mdadm.conf
		mdadm --examine --scan --config=/etc/mdadm.conf \
			>> /etc/mdadm.conf
		mdadm --assemble --scan
	fi

	if test -c /dev/mapper/control; then
		log "setting up lvm"
		vgscan --mknodes
		vgchange -a y
	fi


BTW, you should definitively use striped mirrors rather than mirrored
stripes.

However, note that you can not boot from a striped mirror. That is,
you need a tiny partition, preferably at the beginning of your discs,
to store the kernel image and the initrd, but not the rootfs. You
can make it a raid1 over all disks, like my md0 above, and use lilo
to write a mbr to _all_ discs. That way you can shuffle around your
discs and your system will still boot.

More details on request ;)
Andre
-- 
Andre Noll, http://www.mathematik.tu-darmstadt.de/~noll

