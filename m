From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: Re: s/w raid and bios renumbering HDs
Date: Mon, 31 Oct 2005 11:47:29 -0800 (PST)
Message-ID: <Pine.LNX.4.63.0510311126200.25465@twinlark.arctic.org>
References: <8d03025a0510310756q7410ef13v6ffb4764229b2eb6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8d03025a0510310756q7410ef13v6ffb4764229b2eb6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hari Bhaskaran <hbhaskaran@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 31 Oct 2005, Hari Bhaskaran wrote:

> Hi,
> 
> I am trying to setup a RAID-1 setup for the boot/root partition. I got
> the setup working, except what I see with some of my tests leave me
> less convinced that it is actually working. My system is debian 3.1
> and I am not using the raid-setup options in the debian-installer,
> I am trying to add raid-1 to an existing system (followed
> http://www.tldp.org/HOWTO/Software-RAID-HOWTO.html  -- 7.4 method 2)

fyi there's a debian-specific doc at 
/usr/share/doc/mdadm/rootraiddoc.97.html which i've always found useful.


> I have /dev/hda (master on primary) and /dev/hdc (master on secondary)
> setup as mirrors. I also have a cdrom on /dev/hdd. Now if I disconnect
> hda and reboot, everything seems work - except what used to be
> /dev/hdc comes up as /dev/hda. I know this since I the bios does
> complain that "primary disk 0" is missing and I would have expected a
> missing hda, not a missing hdc.

huh i wonder if the bios has tweaked the ide controller to swap the 
primary/secondary somehow -- probably cuts down on support calls for 
people who plug things in wrong.  there could be a bios option to stop 
this swapping.


> Anyways, the software seems to
> recognize the "failed-disk" fine if I connect the real hda back. Is
> this the way it is supposed to work? Can I rely on this? Also what
> happens when I move on to fancier setups like raid5?.

the md superblock (at the end of the partition) contains reconstruction
information and UUIDs... the device names they end up on are mostly
irrelevant if you've got things configured properly.  i've moved disks
between /dev/hd* and /dev/sd* going from pata controllers to 3ware
controllers with no problem.

for raids other than the root raid you pretty much want to edit
/etc/mdadm/mdadm.conf and make sure it has "DEVICE partitions" and has
ARRAY entries for each of your arrays listing the UUID.  you can generate
these entries with "mdadm --detail --scan" (see examples on man page).
you can plug the non-root disks in any way you want and things will still
work if you've configured this.

the root is the only one which you need to be careful with -- when debian 
installs your kernel it constructs an initrd which lists the minimum 
places it will search for the root raid components... for example on one 
of my boxes:

# mkdir /mnt/cramfs
# mount -o ro,loop /boot/initrd.img-2.6.13-1-686-smp /mnt/cramfs
# cat /mnt/cramfs/script
ROOT=/dev/md3
mdadm -A /dev/md3 -R -u 2b3a5b77:c7b4ab81:a2b8322a:db5c4e88 /dev/sdb4 /dev/sda4
# umount /mnt/cramfs

it's only expecting to look for the root raid components in those two
partitions... seems kind of unfortunate really 'cause the script could
be configured to look in any partition.

in theory you can hand-edit the initrd if you plan to move root disks to
another position... you can't mount a cramfs rw, so you need to mount,
copy, edit, and run mkcramfs ... and i suggest not deleting your original
initrd, and i suggest copy&pasting the /boot/grub/menu.lst entries to give
you the option of booting the old initrd or your new made-by-hand one.


> title           Debian GNU/Linux, kernel 2.6.13.3-vs2.1.0-rc4-RAID-hda
> root            (hd0,0)
> kernel          /boot/vmlinuz-2.6.13.3-vs2.1.0-rc4 root=/dev/md0 ro
> initrd          /boot/initrd.img-2.6.13.3-vs2.1.0-rc4.md0
> savedefault
> boot
> 
> title           Debian GNU/Linux, kernel 2.6.13.3-vs2.1.0-rc4-RAID-hdc
> root            (hd1,0)
> kernel          /boot/vmlinuz-2.6.13.3-vs2.1.0-rc4 root=/dev/md0 ro
> initrd          /boot/initrd.img-2.6.13.3-vs2.1.0-rc4.md0
> savedefault
> boot

i don't think you need both.  when your first disk is dead the bios
shifts the second disk forward... and hd0 / hd1 refer to bios ordering.
i don't have both in my configs, but then i haven't bothered testing
booting off the second disk in a long time.  (i always have live-cds
such as knoppix handy for fixing boot problems.)

-dean
