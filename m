From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Promise TX2-plus and kernel 2.6
Date: Thu, 22 Jan 2004 10:54:17 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <400FF229.6000507@pobox.com>
References: <20040122004820.GA2515@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040122004820.GA2515@rap.rap.dk>
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:
> Does anybody know what level of support that is planned for the
> Promise TX2 Plus SATA disk controller in the 2.6 kernel? My understan=
ding
> is that the PATA channels will not work under 2.6, while it works fin=
e
> under 2.4. This does have some influence on deciding whether to upgra=
de
> to 2.6 :-(


No Linux kernel, 2.4 or 2.6, supports the PATA channels currently.  Onl=
y=20
the SATA channels are supported.

	Jeff


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
