From: maarten <maarten@ultratux.net>
Subject: combining two raid systems
Date: Thu, 13 Jan 2005 20:17:16 +0100
Message-ID: <200501132017.16910.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

I'm currently combing two servers into one, and I'm trying to figure out the 
safest way to do that.

System one had two md arrays: one raid-1 with the OS and a second one with 
data (raid-5)  It is bootable through lilo

System two had 9 arrays, one with the OS (raid-1) two raid-1's for swap, and 6 
md devices that belong in an LVM volume. This system has grub.

All md arrays are self-booting 0xFD partitions.

I want to boot off system one.  I verified that that boots fine if I 
disconnect all the [system-2] drives, so that's working okay. 

Now when I boot I get a lilo prompt, so I know the right disk is booted by the 
BIOS.  When logged in, I see only the md devices from system two, and thus 
the current md0 "/" drive is from system two.  Now what options do I have ?

If I zero the superblock(s) (or even the whole partitions) from md0 of system 
2, it will not boot off of that obviously, but what will now get to be md0 ? 
It could be the second array from system 2 equally well as the first array 
from system one, right ?

I could experiment with finding the right array by using different kernel 
root= commandlines, but only grub gives me that possibility, lilo has no 
boot-time shell (well, it has a commandline...)

Another thing that strikes me is that running 'mdadm --detail --scan' also 
only finds the arrays from system 2. Is that expected since it just reads 
its /etc/mdadm.conf file, or should it disregard that and show all arrays ?

Upon first glance 'fdisk -l' does show all devices fine (there are 10 of them)

I think (er, hope, actually) that with mdadm.conf one could probably force the 
machine to recognize the right drives as md0 as opposed to them being 
numbered mdX, but is that a right assumption ?  At the time the kernel md 
code reads / assembles the various 0xFD partitions, the root-partition is not 
mounted (obviously) so reading /etc/mdadm.conf will not be possible.

I'll start to try out some things but I _really_ want to avoid having an 
unbootable system: for one, this system has no CDrom nor floppy, and even 
more importantly I don't think my rescue media have all neccessary drivers 
for the ATA & SATA cards.

Anyone have some good advice for me ?

Maarten

-- 

