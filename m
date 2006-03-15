From: Nix <nix@esperi.org.uk>
Subject: Re: A random initramfs script
Date: Wed, 15 Mar 2006 08:29:25 +0000
Message-ID: <87lkvcrtzu.fsf@hades.wkstn.nix>
References: <87u0a0so6w.fsf@hades.wkstn.nix>
	<20060315002527.GO27173@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060315002527.GO27173@skl-net.de> (Andre Noll's message of
 "Wed, 15 Mar 2006 01:25:27 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 15 Mar 2006, Andre Noll gibbered uncontrollably:
> On 21:37, Nix wrote:
> 
>> In the interests of pushing people away from in-kernel autodetection,
>> I thought I'd provide the initramfs script I just knocked up to boot
>> my RAID+LVM system.  It's had a whole four days of testing so it must
>> work. :)
> 
> I'm using a similar setup since December or so with no problems so
> far. However, all my systems have initramfs as their rootfs.

(well, technically, *every* 2.6 system has an initramfs unpacked into
its rootfs: it's just that for most people it's empty.)

>>  - it doesn't waste memory. initramfs isn't like initrd:
>>    if you just chroot into the new root filesystem, the
>>    data in the initramfs *stays around*, in *nonswappable*
>>    kernel memory. And it's not gzipped by that point, either!
> 
> If you really care, you can remove almost everything from the initramfs
> just before mounting root. But that's not really necessary unless you
> are very short on memory.

The kernel hackers are going through conniptions right now trimming
hundreds of *bytes* off the kernel image. Given that the people who know
how the Linux memory manager works are treating adding to nonswappable
memory that seriously, adding hundreds of Kb to nonswappable memory load
for lack of a 100-line C program to do a single-file-system rm -rf /-
and-chroot() seems unwise.

>                           BTW: I'm also using a complete rescue system
> (45 MB unpacked) which has everything on initramfs. lilo boots this
> 25 MB kernel just fine, and so does etherboot.

There *is* a limit (depending on the size of the statically-populated
page tables); right now I think it's 32Mb on i386/x86_64. Look out.

>>  - if you link against uClibc (recommended), you need a CVS
>>    uClibc too (i.e., one newer than 0.9.27).
> 
> glibc works also fine. For the records: You'll need these:

glibc works fine if you don't care about initramfs bloat. My initramfs
is ~600Kb unpacked, 270Kb when gzipped onto the end of the kernel,
and nearly half of that is the busybox fsck.

I tend to treat initramfs like an embedded system: every byte counts,
because if switch_root were to fail to delete everything (which *can*
happen under certain obscure circumstances), I'd be paying for every
byte for as long as the system runs.

>>  - it doesn't try to e.g. set up the network, so it can't do really
>>    whizzy things like mount a root filesystem situated on a network
>>    block device on some other host: if you want to do something like
>>    that you've probably already written a script to do it long ago
> 
> Yep. Here's what I do for my discless clients (no more nfsroot needed):
> 
> ifconfig eth0
> route del default
> route add default gw $NET.$gw_ip eth0

ifconfig? route? ick. ip(8) is the wave of the future :) far more flexible
and actually has a comprehensible command line as well.

I try to avoid running daemons out of initramfs, because all those daemons
share *no* inodes with anything else you'll ever run: more permanent memory
load for as long as those daemons are running, although at least it's
swappable load.

>> DEVICE partitions
>> ARRAY /dev/md0 UUID=some:long:uuid:here
>> ARRAY /dev/md1 UUID=another:long:uuid:here
>> ARRAY /dev/md2 UUID=yetanother:long:uuid:here
> 
> The following works pretty well for me:
> 
> 	echo "DEVICE /dev/hd*[0-9] /dev/sd*[0-9] /dev/md[0-9]" > /etc/mdadm.conf
> 	mdadm --examine --scan --config=/etc/mdadm.conf  >> /etc/mdadm.conf
> 	mdadm --assemble --scan

Yeah, that would work. Neil's very *emphatic* about hardwiring the UUIDs of
your arrays, though I'll admit that given the existence of --examine --scan,
I don't really see why. :)

>> /sbin/mdev -s
> 
> What's mdev? udevstart works too, but it seems to be depreciated now.

mdev is `micro-udev', a 255-line tiny replacement for udev. It's part of
busybox.

It's not really a full-blown udev replacement: it doesn't do all the
cool configurability stuff that udev can do; it just scans /sys and
populates /dev with all the appropriate kernel names. (`-s' means `do
this for the first time, don't become a daemon because I don't care
about hotplugging').

`switch_root', at the end of the script, is also a recent busybox
addition, which does the delete-everything-and-chroot dance you need to
do to efficiently switch away from the rootfs when there's an initramfs
in it.

>> # Assemble the RAID arrays.
>> /sbin/mdadm --assemble --scan --auto=md --run
> 
> Minor suggestion:
> 
> 	if test -e /proc/mdstat; then /sbin/mdadm ...

Pointless, really: if /proc fails to mount we're dead anyway (because /sys
will almost certainly also misbehave and now we don't have any block
devices because /dev didn't get populated); and the nice thing about
initramfs is that I can be *sure* that RAID was built into this kernel
because the initramfs is linked into the kernel image :)

I suppose for general consumption, that might be a good move: I can't
guarantee that other people will have RAID and LVM built in.

>> # Scan for volume groups.
>> /sbin/lvm vgscan --ignorelockingfailure --mknodes && /sbin/lvm vgchange -ay --ignorelockingfailure
> 
> Similarly,
> 
> 	if test -c /dev/mapper/control; then ...

Agreed.

>> And usr/initramfs (will need adjustment for your system):
> 
>> file /sbin/lvm /usr/i686-pc-linux-uclibc/sbin/lvm 0755 0 0
> 
> Isn't libdevmapper also needed?

No, I linked everything statically because there are only three
independent binaries on that disk, so the space saving from not
including stuff in the libc that is unused exceeds that from not
duplicating stuff. I didn't provide shared library support in
that uClibc at all.

Binary sizes:

-rwxr-xr-x 1 root root 248580 Mar 12 17:15 bin/busybox
-r-xr-xr-x 1 root root 512693 Mar  5 17:53 sbin/lvm
-rwxr-xr-x 1 root root 173349 Mar  5 16:50 sbin/mdadm

lvm's a bit big, but I have no real choice there. I chose to build
in mdadm and not mdassemble for the sake of disaster recovery; it
seems you can fix just about anything you can imagine going wrong
if you have a copy of mdadm to hand. :)

-- 
`Come now, you should know that whenever you plan the duration of your
 unplanned downtime, you should add in padding for random management
 freakouts.'
