From: Paul Downs <paul@positive-internet.com>
Subject: Booting with raided root, debian system
Date: Thu, 10 Apr 2003 13:37:46 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030410123746.GA11470@u4ia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,
  I have been trying for a good few days now to try and boot a fully raided
debian system with Lilo and a custom compiled kernel.  The file system does
not have a separate /boot partion.  Lilo's configuration file has boot= and
root= specified as /dev/md0.

  The custom compiled kernel has md and raid1 modules statically built,
along with ext3, cramfs and associated modules.  There is also an initrd.

  I have experienced various issues but now I have a system where , if I
boot off /dev/hdb1 (hda and hdc are in the raid) I can succesfully install
lilo with:

mount -text3 /dev/md0 /mnt
lilo -r /mnt

  No errors appear and the system appears to boot normally until it
attempts to mount the root.  At which point it errors and stops with an
"attempt to kill init" message.

  Can anyone give me any pointers?  I have tried not to include too much
detail here so if you want pastes of any configuration files etc. just
shout.

  Using grub I can get a system to boot fine however when issuing this style
of command sequence:

root(hd0,0)
kernel /boot/vmlinuz-2.4.20 root=/dev/md0
initrd /boot/initrd.img-2.4.20
boot

  I get an identical error message to lilo.  Have I missed something in
initrd, I have done nothing fancy with it.

Your's banging head against wall and giving up on raided root.

Paul
