From: John Adams <john.adams@avid.com>
Subject: ENODEV from SET_ARRAY_INFO
Date: Wed, 5 Dec 2012 12:17:50 +0000
Message-ID: <CCE4A597.3D19%jadams@avid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <E6715DBB72228C4095127C41A512262A@avid.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dear linux-raid,

I'm debugging a problem with some Centos based 2.6.32-220
kernel wherein I can't assemble my array.  Mdadm gets ENODEV  from the
SET_ARRAY_INFO ioctl. (mdadm is 3.1.4 initially, also tried 3.2.3)

ioctl(3, 0x800c0910, 0x7fff41ef1630)    = 0
ioctl(3, 0x40480923, 0x7fff41ef1650)    = -1 ENODEV (No such device)
write(2, "mdadm: failed to set array info "..., 61) = 61

The expected disks are there and can all be examined.  Mdadm seems to
think everything is fine:

mdadm: /dev/sdcd is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdcb is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdca is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sdbz is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdbs is identified as a member of /dev/md0, slot 8.
mdadm: /dev/sdbr is identified as a member of /dev/md0, slot 5.
mdadm: /dev/sdbq is identified as a member of /dev/md0, slot 9.
mdadm: /dev/sdbp is identified as a member of /dev/md0, slot 6.
mdadm: /dev/sdbd is identified as a member of /dev/md0, slot 4.
mdadm: /dev/sdau is identified as a member of /dev/md0, slot 7.
mdadm: failed to set array info for /dev/md0: No such device

I feel this must be a silly userland problem, such as needing updated
udev magic with the new kernel (old one was a 2.6.23-131), but so far
my knowledge of the binding and assembly process is not adequate to
understand.

I can see mdadm logging binds in the startup of the good kernel, but
not in the bad one.  I assumed that would be driven by udev but I am
booting the kernels over the same root filesystem, same udev scripts
etc.

Could anyone offer a suggestion?

Thank you very much.

John M. Adams


