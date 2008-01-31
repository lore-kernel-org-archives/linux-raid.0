From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Thu, 31 Jan 2008 09:40:53 -0500
Message-ID: <47A1DDF5.6040600@tmr.com>
References: <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <479F5177.6060206@pobox.com> <479F557D.20502@rabbit.us> <479F7FCD.7030106@pobox.com> <479FBA54.6010009@tmr.com> <20080130002237.GC7975@rap.rap.dk> <479FC5B6.10308@pobox.com> <20080130005311.GA12717@rap.rap.dk> <479FCC45.7050207@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479FCC45.7050207@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Moshe Yudkowsky wrote:
> Keld J=F8rn Simonsen wrote:
>> On Tue, Jan 29, 2008 at 06:32:54PM -0600, Moshe Yudkowsky wrote:
>>>> Hmm, why would you put swap on a raid10? I would in a production
>>>> environment always put it on separate swap partitions, possibly a=20
>>>> number,
>>>> given that a number of drives are available.
>>> In a production server, however, I'd use swap on RAID in order to=20
>>> prevent server downtime if a disk fails -- a suddenly bad swap can=20
>>> easily (will absolutely?) cause the server to crash (even though yo=
u=20
>>> can boot the server up again afterwards on the surviving swap=20
>>> partitions).
>>
>> I see. Which file system type would be good for this?
>> I normally use XFS but maybe other FS is better, given that swap is =
used
>> very randomly 8read/write).
>>
>> Will a bad swap crash the system?
>
> Well, Peter says it will, and that's good enough for me. :-)
>
I've done unplanned research into this, it will crash the system, and i=
f=20
you're unlucky some part of what's needed for a graceful crash will be=20
swapped out :-(
> As for which file system: I would use fdisk to partition the md disk=20
> and then use mkswap on the partition to make it into a swap partition=
=2E=20
> It's a naive approach but I suspect it's almost certainly the correct=
=20
> one.
>
I generally dedicate a partition of each drive to swap, but the type is=
=20
"raid array." Then I create a raid10 on that set of partitions and=20
mkswap on the md device. While raid10 is fast and reliable, raid[56]=20
have similar reliability and a higher usable space from any given=20
configuration.

--=20
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will stil=
l
  be valid when the war is over..." Otto von Bismark=20



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
