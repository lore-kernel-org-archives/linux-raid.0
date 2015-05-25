From: Another Sillyname <anothersname@googlemail.com>
Subject: Re: Fwd: Installing Linux directly onto RAID6 Array...........
Date: Mon, 25 May 2015 22:03:39 +0100
Message-ID: <CAOS+5GHz-4J_n7UAU1xVLWp3h7CRTuuSHdmP9rbL6=8=qx30CQ@mail.gmail.com>
References: <CAOS+5GFwGJouUfZ_RWhtRVXw7wnoP1Ry4doHTJmkruFoccmqRg@mail.gmail.com>
	<555294A0.6040703@websitemanagers.com.au>
	<CAOS+5GEP6+7OAHkqQjeyGHAB5u-_-Vq2JWGpcOemYHdCjmR5Lg@mail.gmail.com>
	<CAOS+5GHKwQRPfNAw0EpSjjDUt=9PmjjrkUg+dhGxFS+uOWWVug@mail.gmail.com>
	<alpine.DEB.2.02.1505241032210.9487@uplift.swm.pp.se>
	<5561B237.4040709@youngman.org.uk>
	<5561BCA4.4060904@fnarfbargle.com>
	<5561C6E9.3060706@youngman.org.uk>
	<alpine.DEB.2.02.1505241604370.9487@uplift.swm.pp.se>
	<5561E5CE.7000304@youngman.org.uk>
	<alpine.DEB.2.02.1505241654580.9487@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1505241654580.9487@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well the swap thing was an easy fix/decision.....

I agree that putting swap into an array seems a bit of overkill,
however one of the things that can be a problem is mounting swap files
into /etc/fstab and then the drive with the swap fails......

My workaround, found on the web and re hashed, is to instead create a
4GB swap partition on each drive then using the following script
automount the swaps at boot time using a systemd script.

#!/bin/bash

#  Script for service that autodetects and starts swap partitions

for f in $(fdisk -l | grep "Linux swap" | sort | cut -d' ' -f1 | tr
'\n' ' '); do swapon $f; done

as it only 'finds' swaps on active partitions it prevents boot
problems in the case of a dead drive.

Due to time constraints I've had to build this using bios_boot and
RAID1 /boot/efi and RAID1 /boot partitions for now and the RAID6
partition is currently syncing with a projected finish around 15 hours
from now.  However given what I've learnt I'm convinced that using
initramfs on pre-existing created partitions is the way to
go.....RAID6 for all the arrays, including /boot and /boot/efi.  Once
I've got this migration out of the way and another test box to use I
intend to take this a stage further and make it work.

Thanks for everyones help and ideas, much appreciated.

Tony



On 24 May 2015 at 15:57, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
> On Sun, 24 May 2015, Wols Lists wrote:
>
>> On 24/05/15 15:06, Mikael Abrahamsson wrote:
>>>
>>> On Sun, 24 May 2015, Wols Lists wrote:
>>>
>>>> And if you get read errors, well, aiui, raid won't help here either -
>>>> especially with mirrored raid, you just get a read failure. Raid does
>>>> NOT give you error recovery unless the drive physically fails, and if
>>>> it's a bad block it gets fixed at the disk or disk driver level - well
>>>> below the raid driver.
>>>
>>>
>>> You're wrong. In case of a read error from the physical drive on RAID1,
>>> RAID5 or RAID6 then the information will be re-created from another
>>> drive, and written to the drive that threw a read error. This is the
>>> whole point of RAID with parity information.
>>>
>> Except raid 1 isn't parity ... :-)
>
>
> RAID1 means every drive will have the same information, it's mirrored
> between the member disks. What do you think RAID1 is?
>
>> Personally, I still don't think "raid"ing swap is worth it, though.
>> Horses for courses, ram is cheap, and in my circumstances I don't think
>> I'd gain anything.
>
>
> You're welcome to believe anything you want, but if you're publically
> telling people things that are just not true then you should expect to be
> told so.
>
> You're welcome to tell people to not use SWAP at all, but telling people
> RAID1 has no benefit for SWAP because it won't protect you from read erorrs
> is just wrong.
>
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se
