From: NeilBrown <mr@neil.brown.name>
Subject: Re: Probable bug in md with rdev->new_data_offset
Date: Fri, 01 Apr 2016 16:31:28 +1100
Message-ID: <877fghrj2n.fsf@notabene.neil.brown.name>
References: <20160328103123.GC8633@rcKGHUlyQfVFW> <56F92140.6080801@turmel.org> <20160329110750.GA2529@rcKGHUlyQfVFW>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160329110750.GA2529@rcKGHUlyQfVFW>
Sender: linux-raid-owner@vger.kernel.org
To: =?utf-8?Q?=C3=89tienne?= Buira <etienne.buira@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 29 2016, =C3=89tienne Buira wrote:

> Sorry, forgot to reply to list as well, resending for completeness.
>
> On Mon, Mar 28, 2016 at 08:19:12AM -0400, Phil Turmel wrote:
>> On 03/28/2016 06:31 AM, =C3=89tienne Buira wrote:
>
> ../..
>
>> > After printking the values for rdev->new_data_offset and
>> > rdev->data_offset in the
>> > if (rdev->new_data_offset !=3D rdev->data_offset) { ...
>> > block of super_1_sync, i found that new_data_offset (252928 in my case)
>> > where smaller than data_offset (258048), thus, the substraction to
>> > compute sb->new_data_offset yielded an insanely high value.
>>=20
>> Modern mdadm and kernels avoid the use of backup files by adjusting the
>> data offset.  The lowered offset you see is normal.
>>=20
>> I suspect the grsecurity kernels haven't kept up with this.  If you can
>> reproduce a problem with a vanilla kernel, please report back here.
>> Otherwise you'll have to report to your kernel provider.
>>=20
>> Phil
>
> Hi,
>
> Thank you for the answer.
>
> I tried to reproduce the case with vanilla 4.4.6, but couldn't enter the
> above said 'if', so i'm giving up on this topic.
>
> However, i'm still surprised that sb->new_offset gets assigned a
> 'negative' (well, high, because it is computed unsigned) value.
>

I guess sb->new_offset should be called sb->delta_offset.  If you look
in md_p.h you will see:

	__le32  new_offset;	/* signed number to add to data_offset in new
				 * layout.  0 =3D=3D no-change.  This can be
				 * different on each device in the array.
				 */

which goes some way to explaining the situation.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW/gewAAoJEDnsnt1WYoG5/vsP/2E37ny6RsrDVOkac99xJgCQ
R+bsYjFNlt0SRR/NUXUE4CdMBd8l+2gEiujggxDgsdJH6lJHu61ekwxPjY1iFGJI
PFrnaOhXUHkJQYuksxypk8YKn89e9LhmYv4LGBqqW/8z8lrZSCO0m01iS/kzFM8u
DY6spjrpsX4+FK1f6ahPkJ9Sh6mBOlp/KHsBzL3VxJUjM1nnu3BosBzuDFJuKHk0
3Rm19Vl2Te1yU5v51QlZwKqmrkdwi6kGxSqQHt+YazoE20aOjPcwsBb0EVsI9N+6
jC7p17cgZSfzEI4DOS9FgZ67zWkBKBZyCu7DKuy5xwEG67urOvFlY7bfvFfWN8Dy
c3N8ee3ryRkQFXK0Z2B2R+9qbw8DXkOouscIUyoji+MBeVn8blt0KCOOAuH8KTS9
SyfZ5qUAm77AuediXeGJ/eT4+kLZmwooWqhmf4qKZPdf3ukccZqKBf6JT98AH3w4
ytDXvmLWVLuV83HLAbuSbfU6IVjMRDsuvax324SGpUpul5tLAJd6Rz0wFvLuhOrg
ekRE5kBV5euDqyFbVhvq8Tf1XxsMOUrEoXcUFe6FOygi063Tq8JSWkO1HL19CD6h
C0ktxDQHo4J5A409tYpQgYgfSZyytkn3fRHuwHmZop0StVcLwx29R7dz+5V5OC6x
btJOJc8TiruVedx4rqDG
=3b6M
-----END PGP SIGNATURE-----
--=-=-=--
