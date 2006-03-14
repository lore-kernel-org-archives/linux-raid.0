From: Nix <nix@esperi.org.uk>
Subject: A random initramfs script
Date: Tue, 14 Mar 2006 21:37:11 +0000
Message-ID: <87u0a0so6w.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In the interests of pushing people away from in-kernel autodetection, I
thought I'd provide the initramfs script I just knocked up to boot my
RAID+LVM system. It's had a whole four days of testing so it must
work. :)

It's being used to boot a system that boots from RAID-1 and has almost
everything else on a pair of RAID-5 arrays (not quite everything, as the
disks are wildly different sizes, so I was left with a 20Gb slice at the
end of the largest disk that I'm swapping onto and using for data that I
don't care about).

It has a number of improvements over the initramfs embedded in the
script that comes with mdadm:

 - It handles LVM2 as well as md (obviously if you boot off RAID
   you still have to boot off RAID1, but /boot can be a RAID1
   filesystem of its own now, with / in LVM, on RAID, or both
   at once)
 - It fscks / before mounting it
 - If anything goes wrong, it drops you into an emergency shell
   in the rootfs, from where you have all the power of ash
   without hardly any builtin commands, lvm and mdadm to
   diagnose your problem :) you can't do *that* with in-
   kernel array autodetection!
 - it supports arguments `rescue', to drop into /bin/ash
   instead of init after mounting the real root filesystem,
   and `emergency', to drop into a shell on the initramfs
   before doing *anything*.
 - It supports root= and init= arguments, although for
   arcane reasons to do with LILO suckage you need to pass
   the root argument as `root=LABEL=/dev/some/device',
   or LILO will helpfully transform it into a device number,
   which is rarely useful if the device name is, say,
   /dev/emergency-volume-group/root ;) right now, if you
   don't pass root=, it tries to mount /dev/raid/root after
   initializing all the RAID arrays and LVM VGs it can.
 - it doesn't waste memory. initramfs isn't like initrd:
   if you just chroot into the new root filesystem, the
   data in the initramfs *stays around*, in *nonswappable*
   kernel memory. And it's not gzipped by that point, either!

The downsides:

 - it needs a very new busybox, from Subversion after the start of
   this year: I'm using svn://busybox.net/trunk/busybox revision 14406,
   and a 2.6.12+ kernel with sysfs and hotplug support; this is
   because it populates /dev with the `mdev' mini-udev tool inside
   busybox, and switches root filesystems with the `switch_root'
   tool, which chroots only after erasing the entire contents
   of the initramfs (taking *great* care not to recurse off that
   filesystem!)
 - if you link against uClibc (recommended), you need a CVS
   uClibc too (i.e., one newer than 0.9.27).
 - it doesn't try to e.g. set up the network, so it can't do really
   whizzy things like mount a root filesystem situated on a network
   block device on some other host: if you want to do something like
   that you've probably already written a script to do it long ago
 - the init script's got a few too many things hardwired still,
   like the type of the root filesystem. I expect it's short
   enough to easily hack up if you need to :)
 - you need an /etc/mdadm.conf and an /etc/lvm/lvm.conf, both taken
   by default from the system you built the kernel on: personally
   I'd recommend a really simple one with no device= lines, like

DEVICE partitions
ARRAY /dev/md0 UUID=some:long:uuid:here
ARRAY /dev/md1 UUID=another:long:uuid:here
ARRAY /dev/md2 UUID=yetanother:long:uuid:here
...

One oddity, also: after booting with this, I see some strange results
from --examine --scan with mdadm-2.3.1:

loki:/root# mdadm --examine --scan
ARRAY /dev/md0 level=raid1 num-devices=4 UUID=3a51b74f:8a759fe7:8520304c:3adbceb1
ARRAY /dev/?? level=raid5 metadata=1 num-devices=3 UUID=a5a6cad42c:7fdc0788:a409b919:2ed3bf name=large
ARRAY /dev/?? level=raid5 metadata=1 num-devices=3 UUID=fe44916da1:09857680:07fb812e:e33b5a
loki:/root# ls -l /dev/md*
brw-rw---- 1 root disk 9, 0 Mar 14 20:10 /dev/md0
brw-rw---- 1 root disk 9, 1 Mar 14 20:10 /dev/md1
brw-rw---- 1 root disk 9, 2 Mar 14 20:10 /dev/md2

This is decidedly peculiar because the kernel said it was using md1 and
md2 on the initramfs, and the device numbers are surely right:

raid5: device sda6 operational as raid disk 0
raid5: device hdc5 operational as raid disk 2
raid5: device sdb6 operational as raid disk 1
raid5: allocated 3155kB for md1
raid5: raid level 5 set md1 active with 3 out of 3 devices, algorithm 2
[...]
raid5: device sdb7 operational as raid disk 0
raid5: device hda5 operational as raid disk 2
raid5: device sda7 operational as raid disk 1
raid5: allocated 3155kB for md2
raid5: raid level 5 set md2 active with 3 out of 3 devices, algorithm 2


Anyway, without further ado, here's usr/init:

#!/bin/sh
#
# init --- locate and mount root filesystem
#          By Nix <nix@esperi.org.uk>.
#
#          Placed in the public domain.
#

export PATH=/sbin:/bin

/bin/mount -t proc proc /proc
/bin/mount -t sysfs sysfs /sys
CMDLINE=`cat /proc/cmdline`

# Populate /dev from /sys
/bin/mount -t tmpfs tmpfs /dev
/sbin/mdev -s

INIT_ARGS="$@"

# If there is a forced root filesystem or init, accept the forcing
for param in $CMDLINE; do
    case "$param" in
        init=*) eval "$param";;
        rescue) echo "Rescue boot mode: invoking ash.";
                init=/bin/ash;
                INIT_ARGS="-";;
        emergency) echo "Emergency boot mode. Dropping to a minimal shell.";
                   echo "Reboot with Ctrl-Alt-Delete.";
                   exec /bin/sh;;
        root=LABEL=*) root="`echo $param | cut -d= -f3-`";;
    esac
done

# Assemble the RAID arrays.
/sbin/mdadm --assemble --scan --auto=md --run

FAILED=

# Scan for volume groups.
/sbin/lvm vgscan --ignorelockingfailure --mknodes && /sbin/lvm vgchange -ay --ignorelockingfailure

[[ -z $root ]] && root=/dev/raid/root

fsck -a $root

if [[ $? -eq 4 ]]; then
    echo "Filesystem errors left uncorrected."
    echo
    echo "Dropping to a minimal shell.  Reboot with Ctrl-Alt-Delete."

    exec /bin/sh
fi

if [[ -n $root ]]; then 
    /bin/mount -o rw -t ext3 $root /new-root
fi

if /bin/mountpoint /new-root >/dev/null; then :; else
    echo "No root filesystem given to the kernel or found on the root RAID array."
    echo "Append the correct 'root=' boot option."
    echo
    echo "Dropping to a minimal shell.  Reboot with Ctrl-Alt-Delete."

    exec /bin/sh
fi

if [[ -z "$init" ]]; then
    init=/sbin/init
fi

# Unmount everything and switch root filesystems for good:
# exec the real init and begin the real boot process.
/bin/umount -l /proc
/bin/umount -l /sys
/bin/umount -l /dev

echo "Switching to /new-root and running '$init'"
exec switch_root /new-root $init $INIT_ARGS


And usr/initramfs (will need adjustment for your system):

#
# Files needed for early userspace.
# Placed in the public domain.
#

dir /bin 0755 0 0
file /bin/busybox /usr/i686-pc-linux-uclibc/bin/busybox 0755 0 0
slink /bin/sh /bin/busybox 0755 0 0
slink /bin/msh /bin/busybox 0755 0 0
slink /bin/[ /bin/busybox 0755 0 0
slink /bin/[[ /bin/busybox 0755 0 0
slink /bin/test /bin/busybox 0755 0 0
slink /bin/mount /bin/busybox 0755 0 0
slink /bin/umount /bin/busybox 0755 0 0
slink /bin/cat /bin/busybox 0755 0 0
slink /bin/ls /bin/busybox 0755 0 0
slink /bin/mountpoint /bin/busybox 0755 0 0
slink /bin/echo /bin/busybox 0755 0 0
slink /bin/false /bin/busybox 0755 0 0
slink /bin/true /bin/busybox 0755 0 0
slink /bin/mkdir /bin/busybox 0755 0 0
dir /sbin 0755 0 0
slink /sbin/mdev /bin/busybox 0755 0 0
slink /sbin/fsck /bin/busybox 0755 0 0
slink /sbin/e2fsck /bin/busybox 0755 0 0
slink /sbin/fsck.ext2 /bin/busybox 0755 0 0
slink /sbin/fsck.ext3 /bin/busybox 0755 0 0
slink /sbin/switch_root /bin/busybox 0755 0 0
file /sbin/mdadm /usr/i686-pc-linux-uclibc/sbin/mdadm 0755 0 0
file /sbin/lvm /usr/i686-pc-linux-uclibc/sbin/lvm 0755 0 0
file /init usr/init 0755 0 0

# supporting directories
dir /proc 0755 0 0
dir /sys 0755 0 0
dir /new-root 0755 0 0
dir /etc 0755 0 0
dir /etc/lvm 0755 0 0
file /etc/lvm/lvm.conf /etc/lvm/lvm.conf 0644 0 0
file /etc/mdadm.conf /etc/mdadm.conf 0644 0 0

# initial device files required (mdev creates the rest)
dir /dev 0755 0 0
nod /dev/console 0600 0 0 c 5 1
nod /dev/null 0666 0 0 c 1 3


And the busybox config file I used for all this --- you *will* need to
change the CROSS_COMPILER_PREFIX and the EXTRA_CFLAGS_OPTIONS, and you
might want to build in more tools as well for use when things go wrong,
in emergency mode:

HAVE_DOT_CONFIG=y
CONFIG_FEATURE_BUFFERS_USE_MALLOC=y
CONFIG_FEATURE_DEVPTS=y
CONFIG_STATIC=y
CONFIG_LFS=y
USING_CROSS_COMPILER=y
CROSS_COMPILER_PREFIX="/usr/bin/i686-pc-linux-uclibc-"
EXTRA_CFLAGS_OPTIONS="-march=pentium3 -fomit-frame-pointer"
CONFIG_INSTALL_NO_USR=y
CONFIG_INSTALL_APPLET_SYMLINKS=y
PREFIX="./_install"
CONFIG_CAT=y
CONFIG_CUT=y
CONFIG_ECHO=y
CONFIG_FALSE=y
CONFIG_LS=y
CONFIG_MKDIR=y
CONFIG_TEST=y
CONFIG_TRUE=y
CONFIG_FEATURE_AUTOWIDTH=y
CONFIG_E2FSCK=y
CONFIG_FSCK=y
FDISK_SUPPORT_LARGE_DISKS=y
CONFIG_MDEV=y
CONFIG_MOUNT=y
CONFIG_SWITCH_ROOT=y
CONFIG_UMOUNT=y
CONFIG_MOUNTPOINT=y
CONFIG_FEATURE_SH_IS_MSH=y
CONFIG_MSH=y
CONFIG_FEATURE_SH_EXTRA_QUIET=y
CONFIG_FEATURE_SH_STANDALONE_SHELL=y
CONFIG_FEATURE_COMMAND_EDITING=y
CONFIG_FEATURE_COMMAND_EDITING_VI=y
CONFIG_FEATURE_COMMAND_HISTORY=15
CONFIG_FEATURE_COMMAND_TAB_COMPLETION=y
CONFIG_FEATURE_IPC_SYSLOG_BUFFER_SIZE=0
CONFIG_MD5_SIZE_VS_SPEED=2

-- 
`Come now, you should know that whenever you plan the duration of your
 unplanned downtime, you should add in padding for random management
 freakouts.'
