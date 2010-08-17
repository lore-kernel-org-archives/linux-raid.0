From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: intel fakeraid (imsm) linux kernel support
Date: Tue, 17 Aug 2010 10:26:34 -0700
Message-ID: <AANLkTi=vVgStMEof_x2wYph79HQNXjFL9bsPO0F=57ji@mail.gmail.com>
References: <4C6AB6AC.40904@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C6AB6AC.40904@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "K. Posern" <quickhelp@gmail.com>
Cc: linux-raid@vger.kernel.org, dave.jiang@intel.com
List-Id: linux-raid.ids

On Tue, Aug 17, 2010 at 9:19 AM, K. Posern <quickhelp@gmail.com> wrote:
> Hi all,
>
> I am trying to find out if it is possible to:
>
> =A0 =A0 =A0 =A0a) Have the linux kernel autodetect / auto-assemble th=
e fakeraid (to
> avoid having an initrd (for speed and KISS))
>
> =A0 =A0 =A0 =A0b) Boot linux kernel from a fakeraid this: grub2? lilo=
? ... anything?

Hi, I think I answered these in my other response:

http://marc.info/?l=3Dlinux-raid&m=3D128206374710903&w=3D2

=2E..but you specifically ask about partition-type-0xfd below:

[..]
> Side-Question:
> To be able to have the kernel auto-assemble / autodetect any [e.g. md=
adm]
> linux software RAID-0 you need *partions*, right?

You need partitions and the v0.90 metadata format.

> --> You can't assemble a software raid-0 using two complete drives:

You can, but not if you want to autodetect it.  But just use an initrd
and be happy :-)

> =A0 =A0 =A0 =A0/dev/sda
> =A0 =A0 =A0 =A0/dev/sdb
> But you need to create e.g.:
> =A0 =A0 =A0 =A0/dev/sda1 <<< type set to FD
> =A0 =A0 =A0 =A0/dev/sdb1 <<< type set to FD
>
>
> It would be great and very kind if someone could clarify these things=
 for me
> (just a link to read the answers somewhere would work too ;).
> Thanks a lot!

One of the biggest differences between the native-md (0.90 and 1.x)
formats and external (imsm and ddf) formats, is that the latter only
use complete drives.  For example if you wanted two raid0 arrays on
the same set of disks using a native-md format you would need to
partition the disks first and then:

mdadm -C /dev/md0 /dev/sd[a-d]1 -n 4 - l 0
mdadm -C /dev/md1 /dev/sd[a-d]2 -n 4 -l 0

=2E..with the external formats you create a container of disks and then
carve multiple volumes out of that set:
mdadm -C /dev/md/imsm /dev/sd[a-d] -n 4 -e imsm # create an imsm contai=
ner
mdadm -C /dev/md0 /dev/md/imsm -n 4 -l 0 -z $size # create a raid0
array in the container
mdadm -C /dev/md1 /dev/md/imsm -n 4 -l 0 # use the remaining space for
a second raid0 volume

The bios (on an enabled platform) will see /dev/md0 and /dev/md1 as
bootable devices, not the individual component disks (/dev/sd[a-d]).

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
