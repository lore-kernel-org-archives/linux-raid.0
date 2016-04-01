From: =?utf-8?Q?=C3=89tienne?= Buira <etienne.buira@gmail.com>
Subject: Re: Probable bug in md with rdev->new_data_offset
Date: Fri, 1 Apr 2016 08:15:16 +0200
Message-ID: <20160401061515.GA24288@rcKGHUlyQfVFW>
References: <20160328103123.GC8633@rcKGHUlyQfVFW>
 <56F92140.6080801@turmel.org>
 <20160329110750.GA2529@rcKGHUlyQfVFW>
 <877fghrj2n.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <877fghrj2n.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <mr@neil.brown.name>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Apr 01, 2016 at 04:31:28PM +1100, NeilBrown wrote:
> On Tue, Mar 29 2016, =C3=89tienne Buira wrote:

=2E./..

>=20
> I guess sb->new_offset should be called sb->delta_offset.  If you loo=
k
> in md_p.h you will see:
>=20
> 	__le32  new_offset;	/* signed number to add to data_offset in new
> 				 * layout.  0 =3D=3D no-change.  This can be
> 				 * different on each device in the array.
> 				 */
>=20
> which goes some way to explaining the situation.
>=20
> NeilBrown

Hi Neil,

Thank you for the explanation, i have also looked at the sb loading
counterpart, and indeed, PAX did catch a false positive here.

=46or the record, the bug have been reported on Gentoo bugtracker [1].

[1] https://bugs.gentoo.org/show_bug.cgi?id=3D578502

Regards.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
