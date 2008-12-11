From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: problem with software RAID5
Date: Thu, 11 Dec 2008 13:08:13 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812111306470.26824@p34.internal.lan>
References: <49411DAC.8000502@cgv.tugraz.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49411DAC.8000502@cgv.tugraz.at>
Sender: linux-raid-owner@vger.kernel.org
To: Lars Schimmer <l.schimmer@cgv.tugraz.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 11 Dec 2008, Lars Schimmer wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Hi!
>
> I run a 3 disk RAID5 on a debian 2.6.26 machine.
>
> Last weekend one of that disk went bad and the raid went on with 2 disks.
>
> Now I restarted and added the 3d disk and the RAID5 went crazy, callind
> disks after disk faulty and (S)... and I do not know why.
>

Sounds like you want to try:
mdadm --assemble --force /dev/md1 /dev/sde1 /dev/sdg1 missing

When you do it, it should look like this (example)
# mdadm --assemble --force /dev/md3 /dev/sd[c-l]1 
mdadm: forcing event count in /dev/sdd1(1) from 151848 upto 151856 -> mdadm: clearing FAULTY flag for device 1 in /dev/md3 for /dev/sdd1 
mdadm: /dev/md3 has been started with 9 drives (out of 10) and 1 spare.

Justin.

