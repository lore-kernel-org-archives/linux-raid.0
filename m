From: "Lewis Shobbrook" <lshobbrook@fasttrack.net.au>
Subject: RE: md raid oops on 2.4.25/alpha
Date: Fri, 2 Apr 2004 17:28:10 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <0C8098CA7F09CE419F0C2B68EB8358761EB865@exchange.fasttrack.net.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

[Excerpt from linux-raid mailing list]
> We have some problems with the md code on alpha. We get
> regular oops when using the md raid1. Here we got another 
> oops when fsck (at boot 
> time) the raid:
> This was after a fresh reboot. As long as only the raid is 
> *not* mounted of fsck the machine works without any oops.

I've found similar results with the unstable Debian 2.4.25.-1-686
kernel.
 
> I also can mount the hard disks *without* raid directly as
> hda1 and hdc1, and do NOT get any errors here, so I suspect 
> that only the md code is the culprit.

Same again here.

I have /dev/hda2 listed in raidtab as a failed disc, lilo points to hda
as boot.  I get kernel panic when attemtpting to boot to it.

I thought this strange as I have another system running the very same
kernel (even used the same copied kernel deb) with a UU (no failed)raid
1 running off a hpt372 onboard controller (as soft md, not hardware raid
1).  The raid device was present prior to the kernel in this instance.
I was impressed that the std initrd wokred with both md and hpt372
without modification, where the process had been more involved in the
past requiring a custom initrd or "compiled in" kernel.

I thought that the devfs (compiled in with the std debain kernel) may
have been an issue, but it has never been in the past and the same
filesystem on the raidtab listed "failed" drive /dev/hda2 is happy.

I can boot the the raid 1 as root filesystem when passing root=/dev/md0
loading through a system rescue disc (http://www.sysresccd.org/) with a
2.4.25 kernel. 

Attempting to boot to /dev/md0  with the Debian 2.4.25-1-686 kernel
panics after attempting to mount the device /dev2/root2 as ext2, minix &
fat (possibly others that disappear before they can be read) and
complains the std way when you attempt to mount with the wrong fs. 
...
pivot_root: no such file or directory
/sbin/init: 347: cannot open dev/console : no such file
Kernel panic: Attempted to kill init !

I've attempted to pre-load the initrd modules, but didn't expect this to
be a solution and it wasn't.

I'm scratching the head and losing hair...

Never had any trouble of this sort before.

Any suggestions appreciated.

Cheers,

Lewis
