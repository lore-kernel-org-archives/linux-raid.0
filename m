From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Promise TX2-plus and kernel 2.6
Date: Thu, 22 Jan 2004 11:25:42 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <400FF986.2090509@pobox.com>
References: <20040122004820.GA2515@rap.rap.dk> <400FF229.6000507@pobox.com> <20040122161929.GA26026@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040122161929.GA26026@rap.rap.dk>
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:
> I am running linux kernel 2.4.22-26mdk and it supports PATA right out=
 of
> the box, on a Promise TX2-plus controller. I have one disk on the PAT=
A
> port (and one disk on one of the SATA ports). I would probably like t=
o
> run kernel 2.6, mostly because I think of implementing some striping
> RAID-1 on it and try that new module out, but if kernel 2.6 does not
> support PATA on the TX2-plus then I am at a loss.


It sounds like Mandrake added a non-standard Promise driver...  Consult=
=20
your vendor in this case.

	Jeff



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
