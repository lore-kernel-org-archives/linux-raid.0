From: Duncan Laurie <duncan@sunbalt.net>
Subject: Re: Problems with RAID1 on cobalt raq3
Date: 17 Aug 2002 15:55:38 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1029624922.14769.119.camel@atherton>
References: <200208172056.g7HKuHm05754@raq.iceblink.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200208172056.g7HKuHm05754@raq.iceblink.org>
To: valen@tuatha.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 16 Aug 2002 08:02:38 -0700, John P. Looney wrote:

>  I've been battling with getting RAID1 working on the root filesystem of a
> Cobalt raq3 (running RedHat 7.3) for about a week.
> 
>  The current problem is that the Raq3 PROM will not mount a root
> filesystem different to the one that it loads the kernel from initially.
> 
>  The PROM seems to use a variable "set_boot_dev" to get a partition name.
> It mounts this partition, gets a file /boot/vmlinux.gz from it, unzips it,
> and runs.
> 
>  I have hda2 (my original root partition) and hdg1 parts of a mirror setup
> as /dev/md1, which is to be mounted as /. I used the "failed-disk"
> directive to create md1 as / - however, after booting, md1 is mounted on /
> fine, but I cannot add hda2 to this with raidhotadd:
> 
> [root@midir root]# raidhotadd /dev/md1 /dev/hda2                   
> md: can not import hda2, has active inodes!
> md: error, md_import_device() returned -16
> /dev/md1: can not hot-add disk: invalid argument.
> 
>  Does anyone have any idea what could be happening, or how I could resolve
> this ?
> 
>  I think I'm using lilo to some degree, as when the cobalt boots, it loads
> a 2.2.16 kernel from it's PROM, and spits out:
> 

Nope, no LILO used in the cobalt bootloader.  You have it mostly figured
out though.  The variable written to with "set_boot_dev" is stored in
CMOS, and it is passed to the linux zero-page on boot as ORIG_ROOT_DEV.
(see linux-2.4/Documentation/i386/zero-page.txt)  However, this does not
have the same effect as passing "root=/dev/md1" to the kernel.

 

On your box, what is this variable set to?

> VFS: Mounted root (ext2 filesystem) readonly.
> Freeing unused kernel memory: 76k freed
> Warning: unable to open an initial console.
> BOOTLOADER: Mapping in physical locations
> BOOTLOADER: load_addr=0xc1804000 ret_data=0xc1a050ac
> BOOTLOADER: opening "/boot/vmlinux.gz"
> BOOTLOADER: reading "/boot/vmlinux.gz"
> BOOTLOADER: read 1254176bytes
> BOOTLOADER: unmounting /
> BOOTLOADER: calling reboot notifiers
> stopping all md devices.
> flushing ide devices: hdg 
> disabling network interfaces.
> resetting sym53c8xx scsi bus(es)
> sym53c875-0: detaching ...
> sym53c875-0: resetting chip
> BOOTLOADER: mapping 16M-32M for ride home
> BOOTLOADER: disabling interupts
> BOOTLOADER: flushing cache
> BOOTLOADER: Leap of faith!
> Back in ramcode: done
> Second stage kernel: Decompressing - done
>   extract_header_info:
>     ehead: 0x01500000
>     shead: 0x01747eb0
>     Machine: 0x00000003
>     Kernel Entry: 0xc0105000
>     Program header size: 0x00000020
>     Number of Program headers: 1
>     Section Header size: 0x00000028
>     Number of section headers: 23
>   relocate_and_zero:
>     Offset: 0x00001000
>     VAddr: 0xc0100000
>     PAddr: 0xc0100000
>     Filesize: 0x0023f6a0
>     Memsize: 0x0027aa58
>     Flags: 0x00000007
>     relocate: src = 0x01501000, dest = 0x00100000, size = 0x0023f6a0
>   Kernel cmd line: console=ttyS0,115200 ip=off 
>   Booting kernel...
> Linux version 2.4.18-4jp (root@jlooney) (gcc version 2.96 20000731 (Red Hat Linux 7.3 2.2BIOS-provided physical RAM map:
> 
>  But in case it is a problem with the lilo.conf:
> 
>      disk=/dev/md1
>         bios=0x80
>         sectors=63
>         heads=16
>         cylinders=39560
> 
>      boot=/dev/hda
>      map=/boot/map
>      install=/boot/boot.b
>      image=/boot/boot/vmlinuz-2.4.18-3
>          root=/dev/md1
>          read-only
>          label=LinuxRaid
> 
>  Should that work ?
> 
> John
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
 

