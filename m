From: <martin@hack.org>
Subject: Re: BSD disklabel and autodetection
Date: Wed, 24 Jul 2002 09:09:32 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <12115.5969136909$1027501772@news.gmane.org>
References: <87y9c2r2vn.fsf@qaip3.ins.cwi.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87y9c2r2vn.fsf@qaip3.ins.cwi.nl>
To: Hein Roehrig <hpr@eml.cc>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 23 Jul 2002, Hein Roehrig wrote:
>
> <martin at hack.org> writes:
>
> > i'm trying to get autodetection to work on a RAID 5 raiddevice made up
> > from three devices. two of them reside on disks with DOS-style partition
> > tables, the third is on a disk with a BSD disklabel. all of them have the
> > partition type set to 0xfd, but only the first two devices are configured
> > at boot time.
>
> See message <1019846049.1670.76.camel@peecee> on this mailing list. I
> am in the process of patching my personal 2.4.19-rc3 to do
> autodetection -- in the long run initrd is the way to go.

Hein, i don't quite understand how initrd will solve my problem? i'm
quite happy with my handrolled kernel, it's just that some of the
partitions of the raid device are not detected.

following some hints i've seen elsewhere on the list i tried to pass md
parameters to the kernel ->

Booting on Nautilus using machine vector Nautilus from SRM
Command line: ro root=/dev/md1 md=1,/dev/sdb5,/dev/sdc2,/dev/sdd2 raid=noautodetect
md: Will configure md1 (super-block) from /dev/sdb5,/dev/sdc2,/dev/sdd2, below.

with the raid=noautodetect option it works.

what other raid/md options can be passed this way? and how do i configure
more than one device? geez, hope there's not a 256 char limit to the
command line...
are these options documented somewhere??


with regards,

/m

