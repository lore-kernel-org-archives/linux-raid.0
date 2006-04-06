From: "Mike Garey" <random51k@gmail.com>
Subject: Re: Can't mount /dev/md0 after stopping a synchronization
Date: Thu, 6 Apr 2006 00:32:43 -0400
Message-ID: <c79e949d0604052132k311d808am1ed38b413d4ae100@mail.gmail.com>
References: <c79e949d0604042045w2fb901c2rfb4c00984f6b8761@mail.gmail.com>
	 <4433E073.8040502@fnuck.dk>
	 <c79e949d0604050839k2287fefdm53f6abb08dfcae89@mail.gmail.com>
	 <4433FD5C.1050109@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4433FD5C.1050109@steeleye.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/5/06, Paul Clements <paul.clements@steeleye.com> wrote:
> Mike Garey wrote:
>
> > I seem to be getting closer.. If I try booting from a kernel without
> > raid1 and md support, but using an initrd with raid1/md modules, then
> > I get the "ALERT! /dev/md0 does not exist.  Dropping to a shell!"
> > message.  I can't understand why there would be any difference between
> > using a kernel with raid1/md support, or using an initrd image with
> > raid1/md support, but apparently there is.  If anyone else has any
>
> Autodetection doesn't occur unless md is built into the kernel -- one of
> the reasons why using autodetection is becoming less and less popular.
> You're probably better off assembling the array from your initrd with
> some invocation of mdadm.

I've since tried building my own initrd using the mkinitramfs script
that comes with debian testing for kernel 2.6.15, as well as the
mkinitramfs from mdadm-2.4.  Before, I had only used mkinitramfs that
came with debian testing, and it didn't seem to include the mdadm
binary into the image, which would explain why it wasn't able to mount
the root filesystem (it also tries to execute the command "/sbin/mdrun
dev", which I guess should start the RAID array, but /sbin/mdrun
doesn't exist either - seems the built in mkinitramfs script doesn't
really work exactly as it should - either that, or I'm making a
mistake somewhere).  Anyways, after booting using my initramfs image
(and failling to mount /dev/md0), I was dropped into busybox and tried
the following:

/ # mdadm -Acpartitions --super-minor=0 --auto=part /dev/mda
md: md_d0 stopped.
md: bind<hdc1>
raid: raid set md_d0 active with 1 out of 2 mirrors
mdadm: /dev/mda has been started with 1 drive (out of 2).
/ # mount /dev/mda /root
EXT2-fs warning (device md_d0): ext2_fill_super: mounting ext3
filesystem as ext2

/# mount
none on /sys type sysfs (rw)
non on /proc type proc (rw,nodiratime)
udev on /dev type tmpfs (rw)
/dev/mda on /root type ext2 (rw,nogrpid)

so it seems with a little bit of tweaking, I'll be able to modify the
scripts to get /dev/md0 to mount as the root file system.  The only
thing that bothers me is the "EXT2-fs warning" about having the ext3
filesystem mounted as ext2.. Does anybody know why this is happening,
or how to fix this?  Also, having mounted the filesystem as ext2, will
I have caused any damage to it?  And should I be mounting my RAID
device as /dev/mda or /dev/md0?

On 4/5/06, Jim Klimov <klimov@2ka.mipt.ru> wrote:
> Hello Mike,
>
> I'm afraid I haven't seen your first messages in detail. Sorry, if I
> repeat the lines you already know by heart ;)
>
> Nevertheless, do you by chance have the ability to rebuild your
> kernel, or are you keen on making MD work from initrd and some stock
> kernel?

right now I'm using a custom built kernel with md and raid1 built into
it and it works fine (although I get the same EXT2-fs warning as with
the initramfs image early on in the boot process, but it seems to end
up being mounted as ext3 when the system finally boots).  As I
mentioned above, I'm now trying to get the initramfs version working,
since it'd be nice to have a solution that works with the standard
prepackaged kernel.


> If a custom kernel is ok, link the raid1 driver statically. In this
> case, if the root submirrors are primary partitions flagged with 0xfd
> filesystem type, the kernel will assemble these partitions to a mirror
> before mounting.
>
> You can also try the raid1 driver's parameters on kernel command line
> to force md-device naming and components, i.e.
> ... root=/dev/md0 md=0,/dev/hda1,/dev/hdc1
>
> And in case of mirroring i think you should always be able to mount
> the filesystems as they are, i.e.
> ... root=/dev/hda1 ro
>
> A pitfall is there, that /etc/fstab may require mounting other FSes
> from metadevices, not partitions. And if you mount read-write, then
> your submirrors will be out of sync and that's undetected by raid
> driver.
