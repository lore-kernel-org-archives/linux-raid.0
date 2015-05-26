From: Another Sillyname <anothersname@googlemail.com>
Subject: Re: Fwd: Installing Linux directly onto RAID6 Array...........
Date: Tue, 26 May 2015 08:08:00 +0100
Message-ID: <CAOS+5GEBJ8dxF4s91dGmF7jx36LyNnu40UQZjLAmK2xVhqLAHw@mail.gmail.com>
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
	<CAOS+5GHz-4J_n7UAU1xVLWp3h7CRTuuSHdmP9rbL6=8=qx30CQ@mail.gmail.com>
	<5563AE50.4090806@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5563AE50.4090806@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Not bothered about raiding the swap thanks, my way will suffice as it
gives me maximum flexibility and resilience......I'm not really
performance driven on this project.

On 26 May 2015 at 00:20, Wols Lists <antlists@youngman.org.uk> wrote:
> On 25/05/15 22:03, Another Sillyname wrote:
>> My workaround, found on the web and re hashed, is to instead create a
>> 4GB swap partition on each drive then using the following script
>> automount the swaps at boot time using a systemd script.
>>
>> #!/bin/bash
>>
>> #  Script for service that autodetects and starts swap partitions
>>
>> for f in $(fdisk -l | grep "Linux swap" | sort | cut -d' ' -f1 | tr
>> '\n' ' '); do swapon $f; done
>>
>> as it only 'finds' swaps on active partitions it prevents boot
>> problems in the case of a dead drive.
>
> Do you want linux to raid 0 your swap for you? ime your script will use
> just one disk for swap until it overflows before bringing the next into
> use, etc etc.
>
> If you want swap striped, I think you'll need to use "swapon -p=1" or
> whatever number. Otherwise I think you'll find all your swaps are
> assigned different priorities. Of course, that may be what you want,
> depending on how your disks are laid out.
>
> Cheers,
> Wol
