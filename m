From: Hein Roehrig <hpr@eml.cc>
Subject: Re: BSD disklabel and autodetection
Date: 23 Jul 2002 15:27:08 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <87y9c2r2vn.fsf@qaip3.ins.cwi.nl>
References: <Pine.LNX.4.32.0207231350400.978-100000@dope.pingdynasty.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

<martin@hack.org> writes:

> i'm trying to get autodetection to work on a RAID 5 raiddevice made up
> from three devices. two of them reside on disks with DOS-style partition
> tables, the third is on a disk with a BSD disklabel. all of them have the
> partition type set to 0xfd, but only the first two devices are configured
> at boot time.

See message <1019846049.1670.76.camel@peecee> on this mailing list. I
am in the process of patching my personal 2.4.19-rc3 to do
autodetection -- in the long run initrd is the way to go.

HTH,
Hein


