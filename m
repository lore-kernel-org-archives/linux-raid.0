From: Louis-David Mitterrand <vindex@apartia.org>
Subject: Re: Raid, resync and hotspare
Date: Wed, 13 Jul 2005 16:54:26 +0200
Message-ID: <20050713145426.GA30370@apartia.fr>
References: <42D3E2B4.1070605@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <42D3E2B4.1070605@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: Laurent Caron <lcaron@apartia.fr>
List-Id: linux-raid.ids

On Tue, Jul 12, 2005 at 05:33:08PM +0200, Laurent Caron wrote:
> Hi,
> 
> I recently moved a server from old disks to now ones and added a 
> hotspare (mdadm /dev/md1 -a /dev/sdf2)
> 
> the hotspare appears in  /proc/mdstat
> 
> Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [raid6]
> md1 : active raid5 sdf2[5] sde2[4] sdd2[3] sdc2[2] sdb2[1] sda2[0]
>      285699584 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]
> 
> 
> when I fail a disk, mdadm does *not* send me any warning.

From the mdamd man page:

	Only  Fail , FailSpare , DegradedArray , and TestMessage cause Email to be
	sent.

Your event is "SpareActive" which does not trigger an alert mail,
however all events can be reported through the "--program" switch:

	All events cause the program to be run.  The program  is  run with
	two or  three  arguments,  they  being the event name, the array
	device and possibly a second device.

> Only at the second failure when the array is in degraded state I receive 
> a warning.

> How may I receive a warning when the hotspare disk has been used to cope 
> with a disk failure?

--program "my_mail_script.sh"

	#!/bin/sh
	nail -s "$1 event detected on device $2 $3" root < EOF

	Dear admin,

	You array seems to have suffered to breakage:

	A $1 event was received on for device $2 $3.

	Fix it ASAP!

	Regards,

	EOF

-- 
This space for rent.
