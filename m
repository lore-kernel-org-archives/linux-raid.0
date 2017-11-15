From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Impossibly level change request for RAID1
Date: Wed, 15 Nov 2017 17:14:54 +0000
Message-ID: <5A0C760E.9010105@youngman.org.uk>
References: <CAJh8RqV84uXJ9hV4uSAK-GsnN=FP4fT-S0VNNkSVOay5xZqt8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJh8RqV84uXJ9hV4uSAK-GsnN=FP4fT-S0VNNkSVOay5xZqt8w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Santiago DIEZ <santiago.diez@caoba.fr>, Linux Raid LIST <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 15/11/17 16:52, Santiago DIEZ wrote:
> Hi,
> 
> I started by mistake a raid as RAID1 with 5 disks when my desire was
> to start it as RAID5. Technically, there is no data at all so I could
> entirely recreate the raid but this is NOT what I want. I'm taking
> this opportunity as an exercise to change a raid level.
> 
> The initial state of the raid is:
> md9 : active raid1 sda9[0] sdb9[1] sdc9[2] sdd9[3] sde9[4]
>       5846755328 blocks super 1.2 [5/5] [UUUUU]
>       bitmap: 0/44 pages [0KB], 65536KB chunk
> 
> # I tried to change the level with:
> mdadm /dev/md9 --grow --level=5
> # But got the error :
> mdadm: Impossibly level change request for RAID1

I'll leave the rest for someone else (or maybe me later :-) but just to
explain the "impossible level change", you cannot change a mirror with
more than two active devices. You need to have two active, three spares,
before it will change.

Cheers,
Wol
