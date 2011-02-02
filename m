From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Bootable Raid-1
Date: Wed, 2 Feb 2011 11:44:38 -0600
Message-ID: <60.01.07087.808994D4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTikBM=BQ7Q3W7zX5o59i9DzDgqHMQvnxQoeXip6M@mail.gmail.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikBM=BQ7Q3W7zX5o59i9DzDgqHMQvnxQoeXip6M@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Roberto Spadim' <roberto@spadim.com.br>, hansbkk@gmail.com
Cc: naira@faccat.br, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Roberto Spadim
> Sent: Wednesday, February 02, 2011 10:24 AM
> To: hansbkk@gmail.com
> Cc: lrhorer@satx.rr.com; naira@faccat.br; linux-raid@vger.kernel.org
> Subject: Re: Bootable Raid-1
> 
> grub2 work with raid1 boot partition and rootfs over mdadm raid1
> i tested today (03:00 AM) on my ubuntu desktop

	There wasn't really any question about that.  I've been running
RAID1 boots under GRUB2 for months.  Prior to that, it was RAID1 under GRUB
legacy.  RAID1 under GRUB legacy takes some finagling.  Under GRUB2 it
should be straightforward as long as the partitioning is correct and one
employs a 0.90 superblock for the /boot array.

