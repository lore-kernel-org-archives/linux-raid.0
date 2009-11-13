From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: [ANNOUNCE] mdadm-3.1 has been withdrawn
Date: Thu, 12 Nov 2009 17:53:14 -0800
Message-ID: <4877c76c0911121753o677f8bffy84bbf8e0f8d437f1@mail.gmail.com>
References: <200911121751.nACHpMrQ011365@wind.enjellic.com>
	 <4AFC93EC.2070403@grumpydevil.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AFC93EC.2070403@grumpydevil.homelinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Cc: greg@enjellic.com, Neil F Brown <nfbrown@novell.com>, Doug Ledford <dledford@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You still have to have some part of your boot process served by normal
startup support (like a hardware raid / motherboard supported
fakeraid; unless you're doing some kind of netboot) no matter what you
do you still need a kernel exposed, and you may as well have an initrd
of some kind after it.

What I'd likely do is use GPT and place your bootloader inside of a
Guid Partition Table area (preferably near the front of the disk so
you're assured to be within realmode bios LBA range (just in case LBA
48 bit isn't supported by your bootloader/bios) which might end at
128GB of data http://ubuntuforums.org/archive/index.php/t-301826.html)
and set it up so that the boot-loader code in the first 440 (446)
bytes of the MBR compatibility/protective label loads the blocks for
the real bootloader from that area.

Then you can use DD to duplicate the first 446 bytes on to each other
'mirror' device and either have those boot devices as a mirror set, or
intentionally only manually update the backups when you've tested a
new kernel.


<  Free Open Source Plug  >
If for some reason your current distribution's initrd/initramfs
doesn't do what you want, I know of an easily customized alternative:
"Another Early Userspace Init Option"
http://sourceforge.net/projects/aeuio/ which is based on basic /bin/sh
, awk, sed ; it builds best when you have a local copy of busybox, but
should also build (a somewhat larger) initrd using the other binaries
on your system.
