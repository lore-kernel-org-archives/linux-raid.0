From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: Using mdadm instead of dmraid for BIOS-RAID root volume
Date: Tue, 08 Oct 2013 16:37:36 +0200
Message-ID: <wrfjd2nfde1b.fsf@redhat.com>
References: <5253F7C2.2030401@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5253F7C2.2030401@pobox.com> (Brian Candler's message of "Tue, 08
	Oct 2013 13:17:06 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Brian Candler <b.candler@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brian Candler <b.candler@pobox.com> writes:
> I have a number of systems with Ubuntu 12.04 and Intel BIOS-RAID
> mirrored pairs for the boot disk. These come up as dmraid, with the
> root filesystem on /dev/mapper/isw_XXXXXXXXXX_Volume0p1.
>
> I would like to convert them to use mdadm instead (so for example I
> can monitor them with /proc/mdstat)
>
> The mdadm version is 3.2.5, and the manpage says that dff and imsm
> metadata is supported. mdadm --examine confirms this:
>
> |# mdadm --examine /dev/sda
> /dev/sda:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.1.00
>     Orig Family : 8bc6b015
>          Family : 8bc6b015
>      Generation : 00000010
>      Attributes : All supported
>            UUID : 2ff8e106:XXXXXXXX:XXXXXXXX:XXXXXXXX
>        Checksum : b92d117e correct
>     MPB Sectors : 1
>           Disks : 2
>    RAID Devices : 1
>
>   Disk00 Serial : S14CNEAXXXXXXXX
>           State : active
>              Id : 00000000
>     Usable Size : 234435342 (111.79 GiB 120.03 GB)
>
> [Volume0]:
>            UUID : a7fb0d20:XXXXXXXX:XXXXXXXX:XXXXXXXX
>      RAID Level : 1
>         Members : 2
>           Slots : [UU]
>     Failed disk : none
>       This Slot : 0
>      Array Size : 222715904 (106.20 GiB 114.03 GB)
>    Per Dev Size : 222716168 (106.20 GiB 114.03 GB)
>   Sector Offset : 0
>     Num Stripes : 869984
>      Chunk Size : 64 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : uninitialized
>     Dirty State : clean
>
>   Disk01 Serial : S14CNEAXXXXXXXX
>           State : active
>              Id : 00000001
>     Usable Size : 234435342 (111.79 GiB 120.03 GB)
>
> |(ditto for /dev/sdb)
>
> Since this machine is going to need a reinstall for an unrelated
> reason anyway, I thought as an experiment I'd first try to convert it
> to use mdadm at boot.
>
> What I did was:
>
> 1. apt-get remove dmraid; apt-get autoremove
>
> This gets rid of:
>
> /lib/udev/rules.d/97-dmraid.rules
> /usr/share/initramfs-tools/scripts/local-top/dmraid
> /usr/share/initramfs-tools/hooks/dmraid
>
> but we still have:
>
> /lib/udev/rules.d/64-md-raid.rules
> /usr/share/initramfs-tools/hooks/mdadm
> /usr/share/initramfs-tools/scripts/mdadm-functions
> /usr/share/initramfs-tools/scripts/local-premount/mdadm
> /usr/share/initramfs-tools/scripts/init-premount/mdadm
>
> 2. /usr/share/mdadm/mkconf >/etc/mdadm/mdadm.conf
>
> ARRAY metadata=imsm UUID=2ff8...
> ARRAY /dev/md/Volume0 container=2ff8... member=0 UUID=...

You may need

AUTO +imsm +1.x -all

or similar in your /etc/mdadm.conf

Afterwards you may also need to recreate your initramfs or whatever it
is that Ubuntu uses. Boot devices are assembled in the initramfs (at
least in Fedora), so if you still have the old initramfs sitting around,
it will not see your changes.

Cheers,
Jes
