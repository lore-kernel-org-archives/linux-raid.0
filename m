From: =?utf-8?Q?=C3=89tienne?= Buira <etienne.buira@gmail.com>
Subject: Re: Probable bug in md with rdev->new_data_offset
Date: Tue, 29 Mar 2016 13:07:56 +0200
Message-ID: <20160329110750.GA2529@rcKGHUlyQfVFW>
References: <20160328103123.GC8633@rcKGHUlyQfVFW>
 <56F92140.6080801@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56F92140.6080801@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry, forgot to reply to list as well, resending for completeness.

On Mon, Mar 28, 2016 at 08:19:12AM -0400, Phil Turmel wrote:
> On 03/28/2016 06:31 AM, =C3=89tienne Buira wrote:

=2E./..

> > After printking the values for rdev->new_data_offset and
> > rdev->data_offset in the
> > if (rdev->new_data_offset !=3D rdev->data_offset) { ...
> > block of super_1_sync, i found that new_data_offset (252928 in my c=
ase)
> > where smaller than data_offset (258048), thus, the substraction to
> > compute sb->new_data_offset yielded an insanely high value.
>=20
> Modern mdadm and kernels avoid the use of backup files by adjusting t=
he
> data offset.  The lowered offset you see is normal.
>=20
> I suspect the grsecurity kernels haven't kept up with this.  If you c=
an
> reproduce a problem with a vanilla kernel, please report back here.
> Otherwise you'll have to report to your kernel provider.
>=20
> Phil

Hi,

Thank you for the answer.

I tried to reproduce the case with vanilla 4.4.6, but couldn't enter th=
e
above said 'if', so i'm giving up on this topic.

However, i'm still surprised that sb->new_offset gets assigned a
'negative' (well, high, because it is computed unsigned) value.

Regards.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
