From: Wil Reichert <wil.reichert@gmail.com>
Subject: Re: Mixing 512-byte sector, and 4096-byte sector drives
Date: Mon, 22 Mar 2010 17:11:44 -0700
Message-ID: <7a329d911003221711r153693f6jdaec0b4f4b3d634@mail.gmail.com>
References: <4BA7FFA9.7040303@kieser.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BA7FFA9.7040303@kieser.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Kieser <peter@kieser.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 22, 2010 at 4:39 PM, Peter Kieser <peter@kieser.ca> wrote:
> Hello,
>
> I have a 6-drive RAID6 of WD15EADS (512-byte sector) drives. One of the
> drives is failing, and I have been forced to buy a WD15EARS (4096-byte
> sector) drive to replace the failing drive, and it has the new "advanced
> format" technology.
>
> Do I need to set the "XP" jumper on pins 7-8 to play nicely with the other
> 512-byte sector drives in my array, or will mdraid be okay with the
> 4096-byte sector drive? Will there be a performance penalty adding the drive
> to my array?

Did you create your RAID on the device or on a partition?  If its on
the entire device then you should be fine, tho this might depend on
which metadata format you are using & where its located on the disc
(not sure how the metadata effects data alignment).  If you used a
standard partitioning tool its likely your partitions start on sector
63.  This can be confirmed via an fdisk -l on your other drives.  If
that's the case then you'll probably want to use the offest jumper.
How the drive will behave with the others I have no idea.  If after
you add the drive and your write speeds drop dramatically then
something is misaligned.

Wil
