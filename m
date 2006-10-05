From: "Jurriaan Kalkman" <jurriaan@rivierenland.xs4all.nl>
Subject: Re: converting RAID5 to RAID10
Date: Thu, 5 Oct 2006 12:15:02 +0200 (CEST)
Message-ID: <23368.194.178.120.170.1160043302.squirrel@webmail.xs4all.nl>
References: <20061005095913.GA2530@piper.madduck.net>
Reply-To: jurriaan@rivierenland.xs4all.nl
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061005095913.GA2530@piper.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> I have a 1.5Tb RAID5 machine (3*750Gb disks + 1 spare) and need to
> move some write-intensive services there. Unfortunately, the
> performance is unacceptable. Thus, I wanted to convert the machine
> to RAID10.
>
> My theory was: backup, remove the spare, set one disk faulty, remove
> it, create a degraded RAID10 on the two freed disks, copy data, kill
> RAID5, add disks to new RAID10.
>
> Unfortunately, mdadm (2.5.3) doesn't seem to agree; it complains
> that it cannot assemble a RAID10 with 4 devices when I ask it to:
>
>   mdadm --create -l 10 -n4 -pn2 /dev/md1 /dev/sd[cd] missing missing
>
> I can kind of understand, but on the other hand I don't. After all,
> if you'll allow me to think in terms of 1+0 instead of 10 for
> a second, why doesn't mdadm just assemble /dev/sd[cd] as RAID0 and
> make the couple one of the two components of the RAID1? What I mean
> is: I could set up RAID1+0 that way; why doesn't it work for RAID10?
>
> Do you know of a way in which I could migrate the data to RAID10?
> Unfortunately, I do not have more 750Gb disks available nor
> a budget, and the 1.5Tb are 96% full.
>
AFAIK, linux raid-10 is not exactly raid 1+0, it allows you to, for
example, use 3 disks. You could create a raid-0, then later add that as a
component to a raid-1. A tested backup would certainly be helpful,
although it should work without it (and I can easily say that, as it's not
my data that will be lost: YMMV!)

Jurriaan


