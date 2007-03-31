From: Nix <nix@esperi.org.uk>
Subject: Re: raid6 array ,  part id 'fd' not assembling at boot .
Date: Sat, 31 Mar 2007 12:58:00 +0100
Message-ID: <873b3l1v7b.fsf@hades.wkstn.nix>
References: <Pine.LNX.4.64.0703161838110.11877@filesrv1.baby-dragons.com>
	<17915.32343.270875.583164@notabene.brown> <45FC3158.3020104@tmr.com>
	<17917.45509.654906.432675@notabene.brown> <45FDC355.5000106@tmr.com>
	<Pine.LNX.4.64.0703182011080.24036@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0703182011080.24036@filesrv1.baby-dragons.com> (James W. Laferriere's message of "19 Mar 2007 03:33:34 -0000")
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 19 Mar 2007, James W. Laferriere outgrabe:
> 	What I don't see is the reasoning behind the use of initrd .  It's a
> 	kernel ran to put the dev tree in order ,  start up devices ,... Just to
> 	start the kernel again ?

That's not what initrds do. No second kernel is started, and
constructing /dev is not one of the jobs of initrds in any case. (There
*is* something that runs a second kernel if the first one dies ---
google for `kexec crash dump' --- but it's entirely different in design
and intent from initrds, and isn't an early-boot thing but a kernel-
crash-reporting thing.)

There are three different ways to enter userspace for the first time.

 - You can boot with an initramfs. This is the recommended way and may
   eventually deprecate all the others. initramfses consist of gzipped
   cpio archives, either constructed by hand or built automatically
   by the kernel build system during the build process; and either
   linked into the kernel image or pointed at by the bootloader as if
   they were initrds (or both: the two images are automatically merged).
   These are extracted into the `rootfs', which is the (nonswappable)
   ramfs filesystem which is the root of the mount tree. A minimal rootfs
   (with nothing on it) is linked into the kernel if nothing else is.

   The executable /init in the initramfs is run to switch to userspace
   if such exists, You switch from the rootfs to the real root
   filesystem once you mount it by erasing everything on the rootfs and
   `exec chroot'ing and/or `mount --move'ing it into place. (busybox
   contains a `switch_root' built-in command to do this.)

   (I prefer directly linking an initramfs into the kernel, because the
   kernel image is still stand-alone then and you don't have to engage
   in messes involving tracking which initramfs archive is used by which
   kernel if you run multiple kernels.)

 - You can boot with an initrd, which is a compressed *filesystem image*
   loaded from an external file (which the kernel is pointed at by the
   bootloader). The kernel runs /linuxrc to switch to userspace, and
   userspace should use the `pivot_root' command to flip over to the real
   root filesystem. (There is an older way of switching roots involving
   echoing device numbers into a file under /proc. Ignore it, it's
   disgusting.)

   In both these cases it is the initramfs / initrd's responsibility to
   parse things like the root= and init= kernel command-line parameters
   (and any new ones that you choose to define).

   (This is a far older method than initramfs, which explains the
   apparent duplication of effort. initramfs arose largely out of
   dissatisfaction with the limitations of initrds.)

 - You can boot with neither. In this case the kernel mounts / for you,
   either from a local block device, from auto-assembled md arrays with
   v0.90 superblocks, or remotely off NFS. Because it doesn't fsck the
   root filesystem before mounting it, this is slightly risky compared
   to the other options (where your initramfs/initrd image can fsck
   before mounting as usual). (initramfs archives are safest of all here
   because the filesystem is newly constructed by the kernel at boot
   time, so it is *impossible* for it to be damaged.)

   This option is the one where the RAID auto-assembly kicks in, and the
   only one so inflexible that such is needed. H. Peter Anvin has an
   ongoing project to move everything this option does into a default
   initramfs, and remove this crud from the kernel entirely.

   When that happens, there'll be little excuse for assembling RAID
   arrays using the auto-assembler :)

> 	In otherwords I beleive that initrd's are essentially pointless .  But
> 	that's just my opinion .

It's wrong, sorry. Try mounting / on a RAID array atop LVM partially
scattered across the network via the network block device, for instance
(I was running like this for some time after some unfortunate disk
failures left me with too little storage on one critical machine to
store all the stuff it needed to run).

Hell, try mounting / on LVM at all. You need userspace to get LVM up
and running, so you *need* an initrd or initramfs to do that.

-- 
`In the future, company names will be a 32-character hex string.'
  --- Bruce Schneier on the shortage of company names
