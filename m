From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: device-mapper: : dm-linear: Device lookup failed
Date: Wed, 2 Feb 2005 14:54:14 +0000
Message-ID: <20050202145414.GA14105@agk.surrey.redhat.com>
References: <41FE832D.6000600@knoepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-Disposition: inline
In-Reply-To: <41FE832D.6000600@knoepfle.de>
Sender: linux-raid-owner@vger.kernel.org
To: Rudolf =?iso-8859-1?Q?B=F6rner?= <rb@knoepfle.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 31, 2005 at 08:12:45PM +0100, Rudolf B=F6rner wrote:
> since my Update 9.1. --> 9.2 SUSE I've get a lot of Error/Information=
 in=20

> <6>device-mapper: 4.1.0-ioctl (2003-12-10) initialised: dm@uk.sistina=
=2Ecom
> <3>device-mapper: : dm-linear: Device lookup failed
> <4>device-mapper: error adding target to table
> <3>device-mapper: : dm-linear: Device lookup failed
=20
What version of LVM2 ('lvm version') ?

Combining md and dm can be problematic prior to 2.00.32 - you may
need to fiddle with filters and md_component_detection settings
in lvm.conf.
=20
Alasdair
--=20
agk@redhat.com
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
