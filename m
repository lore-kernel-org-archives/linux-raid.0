From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: Still can't get md arrays that were started from an initrd to shutdown
Date: Tue, 18 Jul 2006 11:16:06 +0200
Message-ID: <bb145bd20607180216i1af66c67pbd78f9eb9426f41f@mail.gmail.com>
References: <bb145bd20607171355x8143b0eofb0017637d749263@mail.gmail.com>
	 <87ac77dcuz.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ac77dcuz.fsf@hades.wkstn.nix>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Are you sure that there's nothing left running from your initrd that
> could be holding open, say, some block device that comprises part of
> your RAID array?

No, I'm not sure. Both suitable ramdisk-creators in Debian (initramfs
and yaird) supposedly delete everything in the ram disk before
switching root, but that may not be enough.

The yaird image I'm using is 1.5MB in size, if anyone wants to take a
look at it. Its init script follows below.

Thanks,

C.

#!/bin/dash
#
# Generator version: yaird 0.0.12-md_d
# Kernel version: 2.6.17.4-99-em64t-p4-smp.
#
INIT_DEBUG=
if [ "$INIT_DEBUG" != "" ]
then
        set -x
fi

#
#  Utility functions
#
mksymdev () {
        devfile="$1"
        sysfile="$2"
        cb="$3"
        devpair=$(/bin/cat "$sysfile")
        for delay in 1 2 4 8 16
        do
                if [ "$devpair" = "" ]
                then
                        echo "Waiting $delay seconds for $sysfile to show up"
                        sleep $delay
                fi
                devpair=$(/bin/cat "$sysfile")
        done

        if [ "$devpair" = "" ]
        then
                echo "Device $sysfile seems to be down."
                echo "Debugging opportunity, type ^D to continue."
                /bin/dash
        fi

        maj=${devpair%:*}
        min=${devpair#*:}
        /bin/mknod "$devfile" $cb $maj $min
}
mkcdev () {
        mksymdev "$1" "/sys/class/$2/dev" c
}
mkbdev () {
        mksymdev "$1" "/sys/block/$2/dev" b
}

switchroot () {
        if [ "$INIT_DEBUG" != "" ]
        then
                echo "Debugging opportunity, ^D to continue."
                /bin/dash
        fi

        echo "Switching root ..."
        /bin/umount -n /sys
        /bin/umount -n /proc
        exec /usr/lib/yaird/exec/run_init \
                /mnt $init "$@"
}

#
# Setting up mounts
#
/bin/mount -nt sysfs sysfs /sys
/bin/mount -nt proc proc /proc
#
# We don't set up a separate /dev file system,
# since rootfs is writable without problem.
#

# /dev/tty is needed for eg cryptsetup.
mkcdev /dev/tty tty/tty

#
# Command line processing
# init - first proc to start on next root
# root - to be done: how should it relate
#       to file system selection?
# ro,rw - mount root read-only or read-write.
#       This is like a mount -r; it overrules
#       a -o rw.
# noresume, resume= - should we resume from a
#       suspend-to-disk?  The resume parameter
#       is optional, but overrides automatic
#       detection of the resume partition if present.
#       noresume prevents us from attempting to resume.
# ide - options for module ide_core.
#       need a way to append these to proper
#       module.  do a check on module name
#       in insmod template?
# ip=, nfsaddrs=, nfsroot= - support NFS boot
#
ro=-r
ip=
nfsroot=
noresume=
resume=
resume2=
init=/sbin/init
for i in $(cat /proc/cmdline)
do
        case "$i" in
        init=*)
                init=${i#init=}
                ;;
        ro)
                ro=-r
                ;;
        rw)
                ro=
                ;;
        ip=*|nfsaddrs=*)
                ip="$ip $i"
                ;;
        nfsroot=*)
                nfsroot="$i"
                ;;
        noresume)
                noresume=1
                ;;
        resume=*)
                resume=${i#resume=}
                ;;
        resume2=*)
                resume2=${i#resume2=}
                ;;
        ydebug)
                INIT_DEBUG=yes
        esac
done
if [ "$INIT_DEBUG" != "" ]
then
        set -x
fi
/sbin/insmod '/lib/modules/2.6.17.4-99-em64t-p4-smp/kernel/drivers/input/evdev.ko'
/sbin/insmod '/lib/modules/2.6.17.4-99-em64t-p4-smp/kernel/drivers/scsi/scsi_mod.ko'
/sbin/insmod '/lib/modules/2.6.17.4-99-em64t-p4-smp/kernel/drivers/scsi/libata.ko'
/sbin/insmod '/lib/modules/2.6.17.4-99-em64t-p4-smp/kernel/drivers/scsi/ahci.ko'
/sbin/insmod '/lib/modules/2.6.17.4-99-em64t-p4-smp/kernel/drivers/scsi/sd_mod.ko'
mkbdev '/dev/sda' 'sda'
mkbdev '/dev/sdb' 'sdb'
/sbin/insmod '/lib/modules/2.6.17.4-99-em64t-p4-smp/kernel/drivers/md/md-mod.ko'
/sbin/insmod '/lib/modules/2.6.17.4-99-em64t-p4-smp/kernel/drivers/md/raid1.ko'
mknod /dev/md_d0 b 254 0
mdadm --assemble --config=partitions /dev/md_d0 --uuid
3f166256:cd9ff27e:a2c3596d:cc0b2092
dd if=/dev/md_d0 of=/dev/zero count=1
mkbdev '/dev/md_d0p1' 'md_d0/md_d0p1'
/sbin/insmod '/lib/modules/2.6.17.4-99-em64t-p4-smp/kernel/fs/mbcache.ko'
/sbin/insmod '/lib/modules/2.6.17.4-99-em64t-p4-smp/kernel/fs/jbd/jbd.ko'
/sbin/insmod '/lib/modules/2.6.17.4-99-em64t-p4-smp/kernel/fs/ext3/ext3.ko'
/bin/mount -n \
        $ro \
        -t ext3 \
        -o 'errors=remount-ro' \
        '/dev/md_d0p1' \
        '/mnt'
switchroot "$@"
