From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid1 and raid 10 always writes all data to all disks?
Date: Sun, 03 Feb 2008 10:56:01 -0500
Message-ID: <47A5E411.10208@tmr.com>
References: <20080202235335.GA29029@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080202235335.GA29029@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:
>  I found a sentence in the HOWTO:
>
> "raid1 and raid 10 always writes all data to all disks"
>
> I think this is wrong for raid10.
>
> eg
>
> a raid10,f2 of 4 disks only writes to two of the disks -
> not all 4 disks. Is that true?
>  =20

I suspect that really should have read "all mirror copies," in the=20
raid10 case.

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
