From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: Perhaps this has been answered before...
Date: Thu, 22 Aug 2002 01:53:26 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020821235326.GE5617@unthought.net>
References: <Pine.OSF.4.30.0208212024340.15250-100000@soul.helsinki.fi> <3D63D0BD.50005@hum.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3D63D0BD.50005@hum.auc.dk>
To: Mads Peter Bach <mpb@hum.auc.dk>
Cc: Mikael Johansson <mpjohans@pcu.helsinki.fi>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Aug 21, 2002 at 07:41:17PM +0200, Mads Peter Bach wrote:
=2E..
> >I however do not see why this should freeze your machine.
>=20
>=20
> Me neither. Swap on RAID-1 works fine for me (though on 2.4).

RAID in 2.2 is seriously broken unless the RAID patches are applied.

With the patches, there are problems with stability in the case where
you actually swap on the RAID device.

With a recent 2.4 kernel, the swap stability problem should be gone. At
least swapping on RAID-1 works for me as well, on several systems here.

So just don't swap on RAID if you're on 2.2  :)   On 2.4 it should work=
=2E

--=20
=2E...............................................................
:   jakob@unthought.net   : And I see the elder races,         :
:.........................: putrid forms of man                :
:   Jakob =D8stergaard      : See him rise and claim the earth,  :
:        OZ9ABN           : his downfall is at hand.           :
:.........................:............{Konkhra}...............:
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
