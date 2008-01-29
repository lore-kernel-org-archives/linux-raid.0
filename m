From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 18:45:28 -0500
Message-ID: <479FBA98.10202@tmr.com>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <479F5177.6060206@pobox.com> <479F557D.20502@rabbit.us> <479F7FCD.7030106@pobox.com> <20080129202156.GA32434@rap.rap.dk> <479FA540.70707@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479FA540.70707@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Moshe Yudkowsky wrote:
> Keld J=F8rn Simonsen wrote:
>
> Based on your reports of better performance on RAID10 -- which are=20
> more significant that I'd expected -- I'll just go with RAID10. The=20
> only question now is if LVM is worth the performance hit or not.
>
>> I would be interested if you would experiment with this wrt boot tim=
e,
>> for example the difference between /root on a raid5, raid10,f2 and=20
>> raid10,o2.
>
> According to man md(4), the o2 is likely to offer the best combinatio=
n=20
> of read and write performance. Why would you consider f2 instead?
>
f2 is faster for read, most systems spend more time reading than writin=
g.

> I'm unlike to do any testing beyond running bonnie++ or something=20
> similar once it's installed.
>
>


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
