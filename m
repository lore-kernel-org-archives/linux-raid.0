From: =?iso-8859-1?Q?M=E5rten_Berggren?= <berg@enea.se>
Subject: Device naming problem(?)
Date: Sun, 15 Aug 2004 20:19:41 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000401c482f4$70de1450$820113ac@enea.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have troubles running RAID on my PC under Linux. The short version of
it
is that I some time ago bought an Asus A7V333 (VIA-KT333-based)
motherboard which
featured a Promise PDC20276 RAID controller. (It seems to be software
RAID
only, but anyway.) I have happily been running the machine with RAID
disabled
as a dual-boot between Suse 8.2 and Win XP Pro. Recently I bought a pai=
r
of
Seagate 160 Mb drives with the purpose of having a shared drive between
Windows and Linux, but Linux will not boot with the RAID controller
enabled;
it panics during booting, unable to mount the system drive.

Two questions:

* How do I make Linux boot with the RAID controller enabled?

* Is it possible to share it between Linux and Windows?
  (ataraid seems to have some pdc subsystem, but I got no idea what tha=
t
means.)

Things that might be relevant:

* The BIOS seems to play tricks (with int13?) to make it possible to
boot from
  the array, but I got no desire to do so (unless neccessary).

* Suse is configured to boot using lilo and an initrd containing the
reiserfs
  module needed for the root partition.

* Without reconfiguring lilo, the booting stops with the message

  "Kernel panic: VFS: Unable to mount root fs on 03:02"

* Booting the Suse CD in rescue mode, I can find the system drive under
/dev/hda2.

* Trying to boot from a floppy with grub installed, I get the same erro=
r
as for lilo with

  root (hd0,1)                          # i e boot from first drive,
second partition
  kernel /boot/vmlinuz root=3D/boot/hda2  # i e boot using vmlinuz,
telling it root is /dev/hda2
  initrd /boot/initrd                   # i e use this initrd
  boot

* Changing the kernel line above to

  kernel /boot/vmlinuz root=3D/boot/hde2  # i e boot using vmlinuz,
telling it root is /dev/hde2

  gets me much further, in fact it seems like even modules are loaded,
but it ends with
  a suggestion that I should run fsck on /dev/hda2. This happens even i=
f
I change /etc/fstab
  to point root to /dev/hde2 instead of /dev/hda2. (Where does the
/dev/hda2 come from then?)
  "mount" tells me /dev/hda2 is mounted in rw mode. (How can it mount
/dev/hda2 when I have to
  boot it as /dev/hde2?)

* Kernel version is 2.4.20 from Suse (2.4.20-4GB)

It seems to me that there is some inconsistencies in naming (/dev/hda2
vs /dev/hde2)?
Suggestions, anyone? Should I send this to linux-ide?

Regards

M=E5rten Berggren

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
