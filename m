From: "Ionut Nistor" <ionut@modulo.ro>
Subject: Re: Multipath problem in a SAN enviromnent
Date: Wed, 11 Jun 2003 19:45:46 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <038101c33038$e8a6e760$3351960a@EEL>
References: <02d201c33023$13fd45a0$3351960a@EEL> <3EE7585E.45D851CE@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yes, you would get around it. But the main point of the superblock (i.e.
disk membership/status/array uuid) is to be able to identify the disks in an
array if devices allocation changes.

There must be a *safe* way of identifying the devices.

-
Ionut


----- Original Message ----- 
From: "Paul Clements" <Paul.Clements@SteelEye.com>
To: "Ionut Nistor" <ionut@modulo.ro>
Cc: <linux-raid@vger.kernel.org>
Sent: Wednesday, June 11, 2003 7:27 PM
Subject: Re: Multipath problem in a SAN enviromnent


> Ionut Nistor wrote:
>
> > So scsi1, bus0, target0, lun2 is now 8,16 instead of 8,32
> >
> > However, the raid superblock still has 8,32 in it - this confuses
> > multipath
>
> One way to get around this problem is to use non-persistent superblocks
> for your arrays and just re-create them at bootup time by calling mkraid
> (or mdadm) after you've correctly identified (using WWID or similar)
> which devices belong to each particular raid set.
>
> --
> Paul
>

