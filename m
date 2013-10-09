From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: Multiple SSDs - RAID-1, -10, or stacked? TRIM?
Date: Wed, 9 Oct 2013 10:00:17 -0300
Message-ID: <CAH3kUhH0Y5zhsSYas4tn3LUi+K46Xb6eUd_qrUyC41R2eOBomQ@mail.gmail.com>
References: <20131009123135.GT1779@bitfolk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131009123135.GT1779@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

well some time ago i asked about a bcache with ssd and raid devices
maybe, but only maybe, a bcache with two ssd raid1(10) + hdd raid1(10)
could help you

in my workload (50% read/write) the raid1 is faster than raid10,
because i have more disks to read different tables / threads
maybe only changing the raid layout could help too

2013/10/9 Andy Smith <andy@strugglers.net>:
> Hello,
>
> Due to increasing load of random read IOPS I am considering using 8
> SSDs and md in my next server, instead of 8 SATA HDDs with
> battery-backed hardware RAID. I am thinking of using Crucial m500s.
>
> Are there any gotchas to be aware of? I haven't much experience with
> SSDs.
>
> If these were normal HDDs then (aside from small partitions for
> /boot) I'd just RAID-10 for the main bulk of the storage. Is there
> any reason not to do that with SSDs currently?
>
> I think I read somewhere that offline TRIM is only supported by md
> for RAID-1, is that correct? If so, should I be finding a way to use
> four pairs of RAID-1s, or does it not matter?
>
> Any insights appreciated.
>
> Cheers,
> Andy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Roberto Spadim
