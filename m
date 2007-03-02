From: Laurent CARON <lcaron@unix-scripts.info>
Subject: Re: Growing a raid 6 array
Date: Fri, 02 Mar 2007 10:51:18 +0100
Message-ID: <45E7F396.9020000@unix-scripts.info>
References: <45E72549.2080108@unix-scripts.info>	<Pine.LNX.4.64.0703011728270.7560@p34.internal.lan> <17895.34033.867599.954940@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17895.34033.867599.954940@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown a =E9crit :
> And Laurent:
>   1/ Yes, it is that easy
>   2/ I doubt a nearly-full ext3 array increases the risk
>   3/ The effect of adding a bitmap is that if you suffer a crash whil=
e
>      the array is degraded, it will resync faster so you have less
>      exposure to multiple failure.
>=20

Ok,

Thanks for your advice.

Laurent
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
