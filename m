From: Neil Brown <neilb@suse.de>
Subject: Re: devices get kicked from RAID about once a month
Date: Thu, 3 Jun 2010 10:13:59 +1000
Message-ID: <20100603101359.01f61d0d@notabene.brown>
References: <4C06A31A.4060907@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C06A31A.4060907@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: st0ff@npl.de
Cc: st0ff@gmx.net, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 02 Jun 2010 20:29:46 +0200
Stefan /*St0fF*/ H=C3=BCbner <st0ff@gmx.net> wrote:

> >=20
> > Any other suggestions? =20
>=20
> Not really, it's up to Neil to export some sysfs-variable, where you
> could tune how long a drive may take to respond to some command.
>=20

Nope.  md doesn't do any timeouts.
You need to look for, or ask for, such variables at the scsi/sata layer=
=2E

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
