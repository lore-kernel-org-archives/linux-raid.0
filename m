From: Ben DJ <bendj095124367913213465@gmail.com>
Subject: A few remaining questions about installing to RAID-10
Date: Thu, 1 Oct 2009 19:31:47 -0700
Message-ID: <babafd2f0910011931y66bd4577sb7dfe1510eb74d76@mail.gmail.com>
References: <babafd2f0910011827l2bc62facpc5fe15ab3994b512@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <babafd2f0910011827l2bc62facpc5fe15ab3994b512@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm setting up new linux boxes, hoping to install whatever OS I choose
to a software RAID array.

I've got 4 identical SATA drives, and would ideally like to use RAID-10=
=2E

I've read a bunch of slightly stale How-To docs, and have a few questio=
ns.

(1) Can Linux boot from /boot on RAID-10? =A0Oldest info I found said n=
o
boot from RAID at all, then more recent docs said boot from RAID-1
works. =A0I found nothing on RAID-10. =A0What's the latest sccop on thi=
s?

(2) As far as I can tell, none of the installers in Centos, Ubuntu or
Opensuse are RAID-10 aware. =A0Seems like the sanest way to get setup
would be to boot from SystemRescueCD, do the partitioning and RAID
creation, then re-boot from an installer disk using the pre-setup
disks.

Am I missing some other, simpler approach?

(3) Assuming that I'll have to boot from RAID-1 (Just suspect that
RAID-10 is not yet an option for /boot, but willing to be shown
wrong!), I'm considering 3 partitioning/raid_config options,

=A0(a)
=A0 =A0DISK1 =A0 =A0 =A0DISK2 =A0 =A0 =A0DISK3 =A0 =A0 =A0DISK4
=A0 [ RAID-1 =A0/boot =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0]
=A0 [ RAID-1 =A0swap =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ]
=A0 [ RAID-10 LVM, /root & 'other' parts =A0 ]

=A0(b)
=A0 =A0DISK1 =A0 =A0 =A0DISK2 =A0 =A0 =A0DISK3 =A0 =A0 =A0DISK4
=A0 [ RAID-1 =A0/boot =A0] =A0 =A0[ RAID-1 =A0swap =A0 ]
=A0 [ RAID-10 LVM, /root & 'other' parts =A0 ]

=A0(c)
=A0 =A0DISK1 =A0 =A0 =A0DISK2 =A0 =A0 =A0DISK3 =A0 =A0 =A0DISK4
=A0 [ RAID-1 =A0/boot =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0]
=A0 [ RAID-10 LVM, /root, swap & 'other' =A0 ]

Are there any clear benefits/concerns of one config over the other?

(4) In setting up the RAID arrays, I've got a choice of metadata
versions. =A0It seems that the distros' installers default to "1.0", bu=
t
that "1.1" & "1.2" are both available, too.

Should I just use the newest, 1.2? =A0Any problems if I do?

(5) In whatever config is "best" in (3), above, is it still good
advice to install the bootlader into multiple MBRs? For example, if I
extend the RAID-1 over all 4-disks, then, I install the loader into
all four MBRs?

I think these are the last details I need to iron out before getting st=
arted.

Thanks for any help!

Ben
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
