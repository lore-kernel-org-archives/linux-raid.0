From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: AW: Am I dead?
Date: Mon, 2 Dec 2002 15:17:48 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021202141748.GF6155@unthought.net>
References: <4D618F6493CE064A844A5D496733D667031549@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D618F6493CE064A844A5D496733D667031549@freedom.icomedias.com>
To: Martin Bene <martin.bene@icomedias.com>
Cc: Nick Lindsell <nick@nexnix.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Dec 02, 2002 at 02:53:44PM +0100, Martin Bene wrote:
> Hi Jakob / Nick
>=20
> > > Am I dead or can I "freshen" sda2 so I can at least have 2=20
> > > devices in my  array and therefore
> > > have a chance of either backing off the data or rebulding=20
> > > with a new sdc ?
> >=20
> > http://unthought.net/Software-RAID.HOWTO/Software-RAID.HOWTO.html
> >=20
> > Section 6.1 "Recovery from Multiple Disk Failure"
>=20
> I think a pointer to neils mdadm should be included in the howto: Nei=
ls tool
> allows much easier recovery from this situation, as it'll just overri=
de the
> event counter and reuse all the other information. This means that yo=
u can't
> mess up because of incorrect raidtab etc.
>=20

I completely agree. mdadm is a tremendously useful tool, which I
unfortunately hasn't had the time to get acquainted to.

I will be very happy to include your submission  ;)

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
