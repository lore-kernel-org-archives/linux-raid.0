From: "Lewis Shobbrook" <lshobbrook@fasttrack.net.au>
Subject: Re: Unable to mount root & Problems with Woody
Date: Fri, 21 Feb 2003 21:15:23 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <84BB6E1F4E011742AFB186D469FDEA9A015BDD@fastterminal.fasttrack.net.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
Cc: pa@debian.org
List-Id: linux-raid.ids

I've have noted something that some of you may find interest in.  I have
tried fruitlessly to get raid1 working in with Debian woody on a 2.4.18
kernel using raidtools2.  I tried countless different means to copy the
root filesystem onto the raid filesystem.  The best I managed to achieve
was about half a file system. All attempts to mount lilo using lilo -r
/mnt/md0 device resulted in failure because nodes in the dev directory
would never copy onto the mdX filesystem. Out of frustration I updated
to the debian testing distro recreated both /dev/md0 and it's
filesystem,  and all works like a charm.  The raidtools versions are
both 0.90.200109 for woody and Testing, so the source of the woody woes
must lay a little deeper, perhaps the raidtools dependencies weren't as
compatible with woody or mke2fs is somehow different. Anyway hope this
info helps someone.

RE; Unable to mount -- Appologies ! I think the mounting trouble with
...

EXT2-fs: md(9.0): couldn't mount because of unsupported optional
features (fff80000).
cramfs: wrong magic
Md: swapper(pid 1) used obsolete MD ioctl, upgrade your software to use
new ictls. 
Kernel Panic. 

... was likely fstab pointing to /dev/hda1 with lilo.ocnf root=/dev/md0.

Cheers,

Lewis
