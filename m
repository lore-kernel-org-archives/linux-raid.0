From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 16:14:24 -0600
Message-ID: <479FA540.70707@pobox.com>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <479F5177.6060206@pobox.com> <479F557D.20502@rabbit.us> <479F7FCD.7030106@pobox.com> <20080129202156.GA32434@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080129202156.GA32434@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:

Based on your reports of better performance on RAID10 -- which are more=
=20
significant that I'd expected -- I'll just go with RAID10. The only=20
question now is if LVM is worth the performance hit or not.

> I would be interested if you would experiment with this wrt boot time=
,
> for example the difference between /root on a raid5, raid10,f2 and ra=
id10,o2.

According to man md(4), the o2 is likely to offer the best combination=20
of read and write performance. Why would you consider f2 instead?

I'm unlike to do any testing beyond running bonnie++ or something=20
similar once it's installed.


--=20
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
