From: Chris Murphy <lists@colorremedies.com>
Subject: Re: 3TB drives failure rate
Date: Sun, 28 Oct 2012 13:50:41 -0600
Message-ID: <DB91871A-731F-44B4-9381-8FBF7D9CC3BF@colorremedies.com>
References: <11510711257.20121028131527@oudeis.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <11510711257.20121028131527@oudeis.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Oct 28, 2012, at 6:15 AM, Rainer F=FCgenstein <rfu@oudeis.org> wrote=
:

>=20
> when trying to upgrade my raid5 with 4 Western digital caviar green
> 3TB drives [WDC WD30EZRX-00MMMB0] (3 brandnew, 1 about 4months old),
> the "old" drive and one of the brand new ones failed with
> unrecoverable read errors and about 70 reallocated sectors each. the
> failures already occured during the initial resync after creating the
> raid.
>=20
> until now I was very fond of WD caviar green drives, but after this
> 50% failure rate I'm not very eager to restore data from the backup.

Sounds like they are cooking or vibrating themselves to death?

But also, longer term, you realize Greens are explicitly stated by WDC =
as not for RAID 5? And RAID 5 implies 24x7 and they're also not a 24x7 =
drive? The early failure isn't what you asked for, but you've got drive=
s that aren't really applicable for your use case.


> what is your experience with 3TB drives, WD and others?
>=20
> (low power drives appreciated, performance is not an issue)

The WDC Reds are what (it seems) the buyers of Greens thought they were=
 buying. Take a look at those, you can use them in RAID5 and 24x7 and t=
hey have a 3 year warranty.

And for a non-enterprise disk the Hitachi Deskstar for that same size a=
nd warranty range, and I *think* it's a 24x7 drive also but I could be =
wrong.

Chris Murphy

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
