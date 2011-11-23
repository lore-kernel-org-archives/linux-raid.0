From: =?iso-8859-1?Q?=22Ramon_Sch=F6nborn=22?= <RSchoenborn@gmx.net>
Subject: Re: md device io request split
Date: Wed, 23 Nov 2011 14:22:16 +0100
Message-ID: <20111123132216.162860@gmx.net>
References: <20111122093634.105520@gmx.net>
 <20111123133124.2042c1f4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111123133124.2042c1f4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

=20
> RAID1 will only limit requests to 4K if the device beneath it is
> non-contiguous - e.g. a striped array or LVM arrangement were consecu=
tive
> blocks might be on different devices.

how does it know if a device is non-contiguous? Is there a way to have =
a dm device "marked" like that or force md to use bigger requests?
Lets assume a host with about 20 raid1 devices consisting of dm-devices=
 with the mentioned overhead - do you think that not splitting the requ=
ests could lead to a noticeable performance improvement?

Thanx for your help,
Ramon Sch=C3=B6nborn
--=20
Empfehlen Sie GMX DSL Ihren Freunden und Bekannten und wir
belohnen Sie mit bis zu 50,- Euro! https://freundschaftswerbung.gmx.de
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
