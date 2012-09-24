From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Hello,Re: GPT Table broken on a Raid1
Date: Mon, 24 Sep 2012 11:21:35 -0600
Message-ID: <2F14DB42-E5C0-43F1-9EE6-CA4859F39756@colorremedies.com>
References: <4961154.0TR9MeFlIq@techz> <1822898.lj0EyHG9Nm@techz> <8CD3CA16-FC0C-462E-BAA5-70F993300867@colorremedies.com> <4838005.Z2kBBljtsi@techz>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4838005.Z2kBBljtsi@techz>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 24, 2012, at 1:28 AM, G=FCnther J. Niederwimmer wrote:
>                                                      =20
> Model: ATA ST3320620AS (scsi)
> Disk /dev/sda: 320GB
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt_sync_mbr

Interesting. Parted thinks this disk has a hybrid MBR. G=FCnther, what =
is the result from:

fdisk -l /dev/sda

?

And one more, I'd like to see the result from:
mount

I want to make sure nothing is directly mounting sda or sdb.

> But the good thing from this, Grub2 found my Windows 7 Installation o=
n the=20
> Raid1 and Make a Start Entry, with mdadm this is not working, Grub2 d=
on't=20
> found the windows?

Let's do one thing at a time. We don't even really have the basics cove=
red yet. I am not able to reproduce your problem where the kernel and p=
arted complain about the alternate GPT header not being at the end of t=
he disk. I'm using kernel 3.5.3-1.fc17 and mdadm 3.2.5.


Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
