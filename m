From: =?ISO-8859-1?Q?Torbj=F6rn?= Olander <tosse@wlug.westbo.se>
Subject: Re: How to stop raid prior to shutdown...
Date: Tue, 24 Aug 2004 08:49:13 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1093330153.743.1.camel@iota>
References: <1093321412.2221.101.camel@south.rosestar.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1093321412.2221.101.camel@south.rosestar.lan>
To: Bob Hillegas <bobhillegas@houston.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2004-08-24 at 06:23, Bob Hillegas wrote:
> Sorry for newbie question. Software-RAID-HOWTO said the following
> would stop an array for shutdown. mdadm complains the array is still=20
> in use. Why?=20
>=20
> mdadm --stop --scan
>=20
> md: md0 still in use.
> mdadm: fail to stop array /dev/md0: Device or resource busy

Check if mdadm is still monitoring the array, if it is, shut it down.
Worked for me  :)

--=20
Med v=E4nliga h=E4lsningar / Best regards
Torbj=F6rn Olander
tosse@wlug.westbo.se

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
