From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: Re: raid5 write performance
Date: Fri, 18 Nov 2005 11:19:55 -0800
Message-ID: <1132341596.28924.10.camel@seki.nac.uci.edu>
References: <20051118150543.59fbdfd9.pegasus@nerv.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051118150543.59fbdfd9.pegasus@nerv.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jure =?iso-8859-2?Q?Pe=E8ar?= <pegasus@nerv.eu.org>
Cc: linux-raid@vger.kernel.org, strombrg@dcs.nac.uci.edu
List-Id: linux-raid.ids


Would it really be that much slower to have a journal of RAID 5 writes?

On Fri, 2005-11-18 at 15:05 +0100, Jure Pe=E8ar wrote:
> Hi all,
>=20
> Currently zfs is a major news in the storage area. It is very interes=
ting to read various details about it on varios blogs of Sun employees.=
 Among the more interesting I found was this:
>=20
> http://blogs.sun.com/roller/page/bonwick?entry=3Draid_z
>=20
> The point the guy makes is that it is impossible to atomically both w=
rite data and update parity, which leaves a window of crash that would =
silently leave on-disk data+paritiy in an inconsistent state. Then he m=
entions that there are software only workarounds for that but that they=
 are very very slow.
>=20
> It's interesting that my expirience with veritas raid5 for example is=
 just that: slow to the point of being unuseable. Now, I'm wondering wh=
at kind of magic does linux md raid5 does, since its write performance =
is quite good? Or, does it actually do something regarding this? :)
>=20
> Niel?
>=20

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
